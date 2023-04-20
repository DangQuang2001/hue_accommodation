import 'package:flutter/material.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_accommodation/view_models/room_provider.dart';
import 'package:hue_accommodation/view_models/user_provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';

List<String> listFurnishing = <String>['Full', 'Less'];
List<String> listTypeRoom = <String>[
  'Mini House',
  'Motel House',
  'Whole House'
];

class AddRoomPage extends StatefulWidget {
  const AddRoomPage({Key? key}) : super(key: key);

  @override
  State<AddRoomPage> createState() => _AddRoomPageState();
}

class _AddRoomPageState extends State<AddRoomPage> {
  String dropdownFurnishingValue = listFurnishing.first;
  String dropdownTypeRoomValue = listTypeRoom.first;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? title;
  String? description;
  String? address;
  double? area;
  double? price;
  bool _isLoading = false;



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
            ? Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: Center(
            child: LoadingAnimationWidget.inkDrop(
              color: Colors.white,
              size: 100,
            ),
          ),
        )
            : Container(),
      ]),
      floatingActionButton: Consumer<UserProvider>(
        builder: (context, userProvider, child) =>  FloatingActionButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              if(roomProvider.images.isNotEmpty){
                (()async{
                  setState(() {
                    _isLoading = true;
                  });
                  await roomProvider.uploadImages();
                  roomProvider.createRoom(userProvider.userCurrent!.id,userProvider.userCurrent!.name,userProvider.userCurrent!.image,title!, description!, address!, area!, dropdownFurnishingValue, price!, dropdownTypeRoomValue, roomProvider.listImageUrl);
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
            Icons.add_home_outlined,
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
          Text(
            '     ${S.of(context).add_room_title}    ',
            style: Theme.of(context).textTheme.headlineLarge,
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
              S.of(context).add_room_name,
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
                initialValue: '',
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
                  title=value;
                  return null;
                }),
            const SizedBox(
              height: 10,
            ),
            Text(
              S.of(context).add_room_description,
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
                initialValue: '',
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Vui lòng nhập mô tả";
                  }
                  if (value!.length < 2) {
                    return "Mô tả quá ngắn!";
                  }
                  description=value;
                  return null;
                }),
            const SizedBox(
              height: 10,
            ),
            Text(
              S.of(context).add_room_address,
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
                initialValue: '',
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Vui lòng nhập địa chỉ";
                  }
                  if (value!.length < 2) {
                    return "Địa chỉ quá ngắn!";
                  }
                  address=value;
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
                      S.of(context).add_room_area,
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                        initialValue: '',
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Vui lòng nhập diện tích";
                          }
                          if (double.parse(value!) < 0) {
                            return "Diện tích không được âm";
                          }
                          area=double.parse(value);
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
                      S.of(context).add_room_furnishing,
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
                      S.of(context).add_room_price,
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                        initialValue: '',
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Giá tiền không được để trống!";
                          }
                          price=double.parse(value);
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
                      S.of(context).add_room_type_room,
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
              S.of(context).add_room_room_image,
              style: Theme.of(context).textTheme.displayLarge,
            ),
            multiImageUploadScreen(context)
          ],
        ),
      ),
    );
  }

  Widget multiImageUploadScreen(BuildContext context) {
    return Consumer<RoomProvider>(
      builder: (context, roomProvider, child) => Container(
        margin: const EdgeInsets.only(top: 20),
        width: MediaQuery.of(context).size.width,
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => roomProvider.selectImages(context),
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
              child: roomProvider.images.isEmpty
                  ? const Text('')
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: roomProvider.images.length,
                      itemBuilder: (context, index) {
                        return FutureBuilder<File?>(
                          future: roomProvider.images[index].file,
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
      ),
    );
  }
}
