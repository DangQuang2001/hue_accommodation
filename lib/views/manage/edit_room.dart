import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_accommodation/models/room.dart';
import 'package:hue_accommodation/view_models/room_provider.dart';
import 'package:hue_accommodation/view_models/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

List<String> listFurnishing = <String>['Full', 'Less'];
List<String> listTypeRoom = <String>[
  'Mini House',
  'Motel House',
  'Whole House'
];

class EditRoomPage extends StatefulWidget {
  final Room room;

  const EditRoomPage({Key? key, required this.room}) : super(key: key);

  @override
  State<EditRoomPage> createState() => _EditRoomPageState();
}

class _EditRoomPageState extends State<EditRoomPage> {
  late String dropdownFurnishingValue;
  late String dropdownTypeRoomValue;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<AssetEntity> _images = [];
  late List<String> listImageUrl = [];
  bool _isLoading = false;

  String? title;
  String? description;
  String? address;
  double? area;
  double? price;

  @override
  void initState() {
    super.initState();
    dropdownFurnishingValue = listFurnishing.first;
    dropdownTypeRoomValue = listTypeRoom.first;
    listImageUrl = widget.room.images;
  }

  Future<void> _selectImages() async {
    List<AssetEntity>? result = await AssetPicker.pickAssets(context,
        pickerConfig: const AssetPickerConfig(
          maxAssets: 10,
          requestType: RequestType.image,
          selectedAssets: [],
        ));
    setState(() {
      _images = result!;
    });
  }

  Future<void> _uploadImages() async {
    listImageUrl = [];
    final storage = FirebaseStorage.instance;
    for (var asset in _images) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference = storage.ref().child('images').child(fileName);
      final File? file = await asset.file;
      if (file != null) {
        UploadTask task = reference.putFile(file);
        await task.whenComplete(() => null);
        String imageUrl = await reference.getDownloadURL();
        listImageUrl.add(imageUrl);

        // rest of the code here
      } else {
        // handle error, e.g. file is null
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var roomProvider = Provider.of<RoomProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              appBar(context),
              infoRoom(context),
            ],
          ),
        ),
        _isLoading
            ? Center(
                child: Container(
                alignment: Alignment.center,
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onBackground,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator()),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Updating..',
                      style: Theme.of(context).textTheme.displayLarge,
                    )
                  ],
                ),
              ))
            : Container(),
      ]),
      floatingActionButton: Consumer<UserProvider>(
        builder: (context, userProvider, child) => FloatingActionButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              if (_images.isNotEmpty || listImageUrl.isNotEmpty) {
                (() async {
                  setState(() {
                    _isLoading = true;
                  });
                  if (_images.isNotEmpty) {
                    await _uploadImages();
                  }

                  await roomProvider.updateRoom(
                      widget.room.id,
                      userProvider.userCurrent!.id,
                      title!,
                      description!,
                      address!,
                      area!,
                      dropdownFurnishingValue,
                      price!,
                      dropdownTypeRoomValue,
                      listImageUrl);
                  setState(() {
                    _isLoading = false;
                  });
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                })();
              }
            }
          },
          backgroundColor: Theme.of(context).colorScheme.onBackground,
          child: const Icon(
            Icons.edit,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget appBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, right: 20, left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(),
              child: const Center(
                child: Icon(
                  Icons.arrow_back_outlined,
                  size: 30,
                ),
              ),
            ),
          ),
          Hero(
            tag: "EditRoom",
            child: Text(
              '     Edit Room    ',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          const SizedBox(
            width: 30,
          )
        ],
      ),
    );
  }

  Widget infoRoom(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
                initialValue: widget.room.name,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  RegExp regex = RegExp(
                      r'^[a-zA-Z0-9.a-zA-Z0-9+" "+ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂ ưăạảấầẩẫậắằẳẵặẹẻẽềềểỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ]+$');
                  if (value!.isEmpty) {
                    return "Vui lòng nhập tên";
                  }

                  if (value!.length < 2 || value.length > 50) {
                    return "Vui lòng nhập tên ít nhất 2 ký tự và không quá 50 ký tự";
                  }
                  if (!regex.hasMatch(value)) {
                    return "Tên không được chứa ký tự đặc biệt!";
                  }
                  title = value;
                  return null;
                }),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Description',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
                initialValue: widget.room.description,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Vui lòng nhập mô tả";
                  }
                  if (value.length < 2) {
                    return "Mô tả quá ngắn!";
                  }
                  description = value;
                  return null;
                }),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Address',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
                initialValue: widget.room.adParams['address']['value'],
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Vui lòng nhập địa chỉ";
                  }
                  if (value.length < 2) {
                    return "Địa chỉ quá ngắn!";
                  }
                  address = value;
                  return null;
                }),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Area',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                        initialValue:
                            widget.room.adParams['size']['value'].toString(),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Vui lòng nhập diện tích";
                          }
                          if (double.parse(value) < 0) {
                            return "Diện tích không được âm";
                          }
                          area = double.parse(value);
                          return null;
                        }),
                  ],
                )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Furnishing ',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    DropdownButtonFormField(
                      value: dropdownFurnishingValue,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge!
                          .copyWith(fontSize: 15),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            //<-- SEE HERE
                            borderSide:
                                const BorderSide(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            //<-- SEE HERE
                            borderSide:
                                const BorderSide(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          dropdownFurnishingValue = value!;
                        });
                      },
                      items: listFurnishing
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )
                  ],
                ))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                        initialValue: widget.room.adParams['deposit']['value'],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Giá tiền không được để trống!";
                          }
                          price = double.parse(value);
                          return null;
                        }),
                  ],
                )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Type Room ',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    DropdownButtonFormField(
                      value: dropdownTypeRoomValue,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge!
                          .copyWith(fontSize: 15),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            //<-- SEE HERE
                            borderSide:
                                const BorderSide(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            //<-- SEE HERE
                            borderSide:
                                const BorderSide(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          dropdownTypeRoomValue = value!;
                        });
                      },
                      items: listTypeRoom
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )
                  ],
                ))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Room Images',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            multiImageUploadScreen(context)
          ],
        ),
      ),
    );
  }

  Widget multiImageUploadScreen(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      width: MediaQuery.of(context).size.width,
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => _selectImages(),
            child: Container(
              width: 130,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.blue),
              child: Center(
                child: Text(
                  'Choose Image',
                  style: GoogleFonts.readexPro(color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: _images.isEmpty
                ? ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: listImageUrl.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: CachedNetworkImage(
                          imageUrl: listImageUrl[index],
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _images.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder<File?>(
                        future: _images[index].file,
                        builder: (BuildContext context,
                            AsyncSnapshot<File?> snapshot) {
                          if (snapshot.hasData) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Image.file(
                                snapshot.data!,
                                width: 200,
                                fit: BoxFit.cover,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return const Text('Error loading image');
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
