import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_accommodation/view_models/google_map_provider.dart';
import 'package:hue_accommodation/view_models/room_provider.dart';
import 'package:hue_accommodation/view_models/user_provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';

List<String> listFurnishing = <String>['Full', 'Empty', 'Less'];
List<String> listCategory = <String>['Rent', 'Buy', 'Project'];
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

class _AddRoomPageState extends State<AddRoomPage>
    with TickerProviderStateMixin {
  String dropdownFurnishingValue = listFurnishing.first;
  String dropdownTypeRoomValue = listTypeRoom.first;
  String dropdownCategory = listCategory.first;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  String title = "";
  String description = "";
  String address = "Address";
  double area = 0;
  double price = 0;
  bool _isLoading = false;
  bool showDistricts = false;
  bool showWards = false;
  bool showRoad = false;
  String city = "";
  String district = "";
  String ward = "";
  late AnimationController controller;

  @override
  initState() {
    super.initState();
    controller = BottomSheet.createAnimationController(this);
    controller.duration = const Duration(milliseconds: 500);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var roomProvider = Provider.of<RoomProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              appBar(context),
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    typeRoom(context),
                    Container(
                      padding: const EdgeInsets.only(left: 20),
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      color: Theme.of(context).colorScheme.onBackground,
                      child: Text(
                        'INFO ROOM',
                        style: GoogleFonts.readexPro(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 1.5),
                      ),
                    ),
                    infoRoom(context),
                    Container(
                      padding: const EdgeInsets.only(left: 20),
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      color: Theme.of(context).colorScheme.onBackground,
                      child: Text(
                        'DETAIL ROOM',
                        style: GoogleFonts.readexPro(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 1.5),
                      ),
                    ),
                    detailRoom(context),
                    multiImageUploadScreen(context)
                  ],
                ),
              ))
            ],
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
      ),
      floatingActionButton: Consumer2<UserProvider, GoogleMapProvider>(
        builder: (context, userProvider, googleMapProvider, child) =>
            FloatingActionButton(
          onPressed: () {
            if (_formKey.currentState!.validate() &&
                _formKey2.currentState!.validate()) {
              if (roomProvider.images.isNotEmpty) {
                (() async {
                  setState(() {
                    _isLoading = true;
                  });

                  await roomProvider.uploadImages();
                  final position =
                      await googleMapProvider.getLatLngFromAddress(address);
                  roomProvider.createRoom(
                      userProvider.userCurrent!.id,
                      userProvider.userCurrent!.name,
                      userProvider.userCurrent!.image,
                      title,
                      description,
                      address,
                      position!,
                      area,
                      dropdownCategory,
                      dropdownFurnishingValue,
                      price,
                      dropdownTypeRoomValue,
                      roomProvider.listImageUrl);
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
      padding:
          const EdgeInsets.only(top: 40.0, right: 20, left: 20, bottom: 10),
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
            TextFormField(
                style: Theme.of(context).textTheme.displayMedium,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: S.of(context).add_room_name,
                  labelStyle:
                      GoogleFonts.readexPro(fontSize: 18, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
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
              height: 20,
            ),
            SizedBox(
              height: 150,
              child: TextFormField(
                  textAlignVertical: TextAlignVertical.top,
                  maxLines: null,
                  expands: true,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: S.of(context).add_room_description,
                    labelStyle:
                        GoogleFonts.readexPro(fontSize: 18, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Vui lòng nhập mô tả";
                    }
                    if (value!.length < 2) {
                      return "Mô tả quá ngắn!";
                    }
                    description = value;
                    return null;
                  }),
            ),
            const SizedBox(
              height: 20,
            ),
            chooseAddress(context),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget multiImageUploadScreen(BuildContext context) {
    return Consumer<RoomProvider>(
      builder: (context, roomProvider, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 100,
            child: Flex(direction: Axis.horizontal, children: [
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () => roomProvider.selectImages(context),
                  child: Container(
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                    height: 100,
                    decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.image_outlined,
                          size: 40,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'CHOOSE IMAGE',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.readexPro(
                              fontSize: 13, fontWeight: FontWeight.w300),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: roomProvider.images.isEmpty ? 0 : 2,
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
                                    height: 100,
                                    width: 100,
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
            ]),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget typeRoom(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet<void>(
          context: context,
          isDismissible: true,
          builder: (BuildContext context) {
            return Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_new_outlined,
                            color: Colors.white,
                            size: 20,
                          )),
                      Text(
                        'Type Room',
                        style: GoogleFonts.readexPro(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                      const SizedBox(
                        width: 40,
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  color: Theme.of(context).colorScheme.background,
                  child: Text(
                    'SELECTED',
                    style: GoogleFonts.readexPro(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1.5),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.house_outlined),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            dropdownTypeRoomValue,
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.check,
                        color: Colors.green,
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  color: Theme.of(context).colorScheme.background,
                  child: Text(
                    'OTHERS',
                    style: GoogleFonts.readexPro(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1.5),
                  ),
                ),
                ...listTypeRoom.map((e) {
                  if (e != dropdownTypeRoomValue) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          dropdownTypeRoomValue = e;
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20.0),
                        decoration: const BoxDecoration(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.warehouse_outlined),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  e,
                                  style:
                                      Theme.of(context).textTheme.displayMedium,
                                ),
                              ],
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 15,
                            )
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      height: 0,
                    );
                  }
                })
              ],
            );
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(S.of(context).add_room_type_room,
                      style: GoogleFonts.readexPro(
                        color: Colors.grey,
                      )),
                  Text(
                    dropdownTypeRoomValue,
                    style: Theme.of(context).textTheme.displayMedium,
                  )
                ],
              ),
              const Icon(
                Icons.arrow_drop_down_outlined,
                size: 30,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget chooseAddress(BuildContext context) {
    return Consumer<RoomProvider>(
      builder: (context, roomProvider, child) => GestureDetector(
        onTap: () {
          showDistricts = false;
          showWards = false;
          showRoad = false;
          showModalBottomSheet<void>(
            transitionAnimationController: controller,
            context: context,
            isDismissible: true,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return FractionallySizedBox(
                heightFactor: 0.9,
                child: StatefulBuilder(
                  builder: (context, setState) => Stack(children: [
                    Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          color: Colors.blue,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back_ios_new_outlined,
                                    color: Colors.white,
                                    size: 20,
                                  )),
                              Text(
                                'Choose City',
                                style: GoogleFonts.readexPro(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white),
                              ),
                              const SizedBox(
                                width: 40,
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: FutureBuilder(
                            future: roomProvider.getCity(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return const Text('Có gì đó sai sai!');
                              }
                              if (snapshot.hasData) {
                                return ListView.builder(
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 20, right: 20),
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) => InkWell(
                                          onTap: () {
                                            setState(() {
                                              city =
                                                  snapshot.data![index]['name'];
                                            });
                                            showDistricts = true;
                                            roomProvider.getDistricts(
                                                snapshot.data![index]['code']);
                                          },
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color: Colors.grey
                                                            .withOpacity(0.4),
                                                        width: 1))),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  snapshot.data![index]['name'],
                                                  style: GoogleFonts.readexPro(
                                                      fontSize: 17),
                                                ),
                                                snapshot.data![index]['name'] ==
                                                        city
                                                    ? const Icon(
                                                        Icons.check,
                                                        color: Colors.green,
                                                      )
                                                    : const Text('')
                                              ],
                                            ),
                                          ),
                                        ));
                              } else {
                                return Container();
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                    districts(context),
                    wards(context),
                  ]),
                ),
              );
            },
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 60,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        GoogleFonts.readexPro(fontSize: 18, color: Colors.grey),
                  ),
                ),
                const Icon(
                  Icons.arrow_drop_down_outlined,
                  size: 30,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget districts(BuildContext context) {
    return Consumer<RoomProvider>(
      builder: (context, roomProvider, child) => StatefulBuilder(
        builder: (context, setState) => AnimatedPositioned(
          duration: const Duration(milliseconds: 400),
          left: showDistricts ? 0 : MediaQuery.of(context).size.width,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Column(children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                color: Colors.blue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            showDistricts = false;
                          });
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new_outlined,
                          color: Colors.white,
                          size: 20,
                        )),
                    Text(
                      'Choose District',
                      style: GoogleFonts.readexPro(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      width: 40,
                    )
                  ],
                ),
              ),
              roomProvider.listDistrict.isEmpty
                  ? Container()
                  : Expanded(
                      child: ListView.builder(
                          padding: const EdgeInsets.only(
                              top: 10, left: 20, right: 20),
                          itemCount: roomProvider.listDistrict.length,
                          itemBuilder: (context, index) => InkWell(
                                onTap: () {
                                  setState(() {
                                    district = roomProvider.listDistrict[index]
                                        ['name'];
                                  });
                                  showWards = true;
                                  roomProvider.getWards(
                                      roomProvider.listDistrict[index]['code']);
                                },
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color:
                                                  Colors.grey.withOpacity(0.4),
                                              width: 1))),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        roomProvider.listDistrict[index]
                                            ['name'],
                                        style:
                                            GoogleFonts.readexPro(fontSize: 17),
                                      ),
                                      roomProvider.listDistrict[index]
                                                  ['name'] ==
                                              district
                                          ? const Icon(Icons.check,
                                              color: Colors.green)
                                          : const Text(''),
                                    ],
                                  ),
                                ),
                              )),
                    ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget wards(BuildContext context) {
    return Consumer<RoomProvider>(
      builder: (context, roomProvider, child) => StatefulBuilder(
        builder: (context, setState) => AnimatedPositioned(
          duration: const Duration(milliseconds: 400),
          left: showWards ? 0 : MediaQuery.of(context).size.width,
          child: Stack(children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: Column(children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              showWards = false;
                            });
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_new_outlined,
                            color: Colors.white,
                            size: 20,
                          )),
                      Text(
                        'Choose Ward',
                        style: GoogleFonts.readexPro(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                      const SizedBox(
                        width: 40,
                      )
                    ],
                  ),
                ),
                roomProvider.listWard.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Expanded(
                        child: ListView.builder(
                            padding: const EdgeInsets.only(
                                top: 10, left: 20, right: 20),
                            itemCount: roomProvider.listWard.length,
                            itemBuilder: (context, index) => InkWell(
                                  onTap: () {
                                    setState(() {
                                      ward =
                                          roomProvider.listWard[index]['name'];
                                    });

                                    showRoad = true;
                                  },
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey
                                                    .withOpacity(0.4),
                                                width: 1))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          roomProvider.listWard[index]['name'],
                                          style: GoogleFonts.readexPro(
                                              fontSize: 17),
                                        ),
                                        roomProvider.listWard[index]['name'] ==
                                                ward
                                            ? const Icon(Icons.check,
                                                color: Colors.green)
                                            : const Text(''),
                                      ],
                                    ),
                                  ),
                                )),
                      ),
              ]),
            ),
            road(context),
          ]),
        ),
      ),
    );
  }

  Widget road(BuildContext context) {
    return Consumer<GoogleMapProvider>(
      builder: (context, googleMapProvider, child) => StatefulBuilder(
        builder: (context, setState) => AnimatedPositioned(
          duration: const Duration(milliseconds: 400),
          left: showRoad ? 0 : MediaQuery.of(context).size.width,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Column(children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                color: Colors.blue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            FocusScope.of(context).unfocus();
                            showRoad = false;
                          });
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new_outlined,
                          color: Colors.white,
                          size: 20,
                        )),
                    Text(
                      'Type house number & street name',
                      style: GoogleFonts.readexPro(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      width: 40,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      googleMapProvider
                          .placeAutocomplete('$value,$ward,$district,$city');
                    } else {}
                  },
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.transparent)),
                      focusColor: Colors.transparent,
                      hintText: 'Type road..',
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.2),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.transparent))),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    padding:
                        const EdgeInsets.only(top: 10, left: 20, right: 20),
                    itemCount: googleMapProvider.placePredictions.length,
                    itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            address = googleMapProvider
                                .placePredictions[index].description!;
                            Navigator.pop(context);
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey.withOpacity(0.4),
                                        width: 1))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.location_on_sharp),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Text(
                                    googleMapProvider
                                        .placePredictions[index].description!,
                                    style: GoogleFonts.readexPro(fontSize: 17),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget detailRoom(BuildContext context) {
    return Form(
      key: _formKey2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            category(context),
            const SizedBox(
              height: 20,
            ),
            furnishing(context),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                style: Theme.of(context).textTheme.displayMedium,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: S.of(context).add_room_area,
                  labelStyle:
                      GoogleFonts.readexPro(fontSize: 20, color: Colors.grey),
                  suffixText: 'm2',
                  hintText: '0',
                  suffixStyle: GoogleFonts.readexPro(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Vui lòng nhập diện tích!";
                  }
                  if (double.parse(value) < 0) {
                    return 'Diện tích không được âm!';
                  }
                  area = double.parse(value);
                  return null;
                }),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                style: Theme.of(context).textTheme.displayMedium,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: S.of(context).add_room_price,
                  labelStyle:
                      GoogleFonts.readexPro(fontSize: 20, color: Colors.grey),
                  suffixText: 'VND',
                  hintText: '0',
                  suffixStyle: GoogleFonts.readexPro(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Vui lòng nhập giá tiền!";
                  }
                  if (double.parse(value) < 0) {
                    return 'Giá tiền không được âm!';
                  }
                  if (double.parse(value) < 50000) {
                    return 'Giá tiền tối thiểu 50.000 VND!';
                  }
                  price = double.parse(value);
                  return null;
                }),
          ],
        ),
      ),
    );
  }

  Widget furnishing(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet<void>(
          context: context,
          isDismissible: true,
          builder: (BuildContext context) {
            return Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_new_outlined,
                            color: Colors.white,
                            size: 20,
                          )),
                      Text(
                        'Furnishing',
                        style: GoogleFonts.readexPro(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                      const SizedBox(
                        width: 40,
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  color: Theme.of(context).colorScheme.background,
                  child: Text(
                    'SELECTED',
                    style: GoogleFonts.readexPro(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1.5),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.home_repair_service_outlined),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            dropdownFurnishingValue,
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.check,
                        color: Colors.green,
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  color: Theme.of(context).colorScheme.background,
                  child: Text(
                    'OTHERS',
                    style: GoogleFonts.readexPro(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1.5),
                  ),
                ),
                ...listFurnishing.map((e) {
                  if (e != dropdownFurnishingValue) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          dropdownFurnishingValue = e;
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20.0),
                        decoration: const BoxDecoration(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.home_repair_service_outlined),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  e,
                                  style:
                                      Theme.of(context).textTheme.displayMedium,
                                ),
                              ],
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 15,
                            )
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      height: 0,
                    );
                  }
                })
              ],
            );
          },
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(S.of(context).add_room_furnishing,
                      style: GoogleFonts.readexPro(
                        color: Colors.grey,
                      )),
                  Text(
                    dropdownFurnishingValue,
                    style: Theme.of(context).textTheme.displayMedium,
                  )
                ],
              ),
              const Icon(
                Icons.arrow_drop_down_outlined,
                size: 30,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget category(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet<void>(
          context: context,
          isDismissible: true,
          builder: (BuildContext context) {
            return Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_new_outlined,
                            color: Colors.white,
                            size: 20,
                          )),
                      Text(
                        'Categories',
                        style: GoogleFonts.readexPro(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                      const SizedBox(
                        width: 40,
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  color: Theme.of(context).colorScheme.background,
                  child: Text(
                    'SELECTED',
                    style: GoogleFonts.readexPro(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1.5),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.category_outlined),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            dropdownCategory,
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.check,
                        color: Colors.green,
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  color: Theme.of(context).colorScheme.background,
                  child: Text(
                    'OTHERS',
                    style: GoogleFonts.readexPro(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1.5),
                  ),
                ),
                ...listCategory.map((e) {
                  if (e != dropdownCategory) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          dropdownCategory = e;
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20.0),
                        decoration: const BoxDecoration(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.category_outlined),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  e,
                                  style:
                                      Theme.of(context).textTheme.displayMedium,
                                ),
                              ],
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 15,
                            )
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      height: 0,
                    );
                  }
                })
              ],
            );
          },
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Category',
                      style: GoogleFonts.readexPro(
                        color: Colors.grey,
                      )),
                  Text(
                    dropdownCategory,
                    style: Theme.of(context).textTheme.displayMedium,
                  )
                ],
              ),
              const Icon(
                Icons.arrow_drop_down_outlined,
                size: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}
