import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_accommodation/view_models/user_model.dart';
import 'package:hue_accommodation/views/boarding_house/boarding_house_detail.dart';
import 'package:hue_accommodation/views/components/slide_route.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../models/room.dart';
import '../../view_models/room_model.dart';

class ReviewRoom extends StatefulWidget {
  final Room room;
  const ReviewRoom({Key? key, required this.room}) : super(key: key);

  @override
  State<ReviewRoom> createState() => _ReviewRoomState();
}

class _ReviewRoomState extends State<ReviewRoom> {
  final FocusNode _focusNode = FocusNode();
  String typeComment = "";
  double rating = 3;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var roomProvider = Provider.of<RoomModel>(context, listen: false);
    roomProvider.images = [];
    roomProvider.listImageUrl = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: GestureDetector(
        onTap: () => _focusNode.unfocus(),
        child: Stack(
          children:[ Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(),
            child: Column(
              children: [
                appBar(context),
                ratingStar(context),
                comment(context),
                images(context),
              ],
            ),
          ),
            isLoading
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
          ]
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
            S.of(context).qr_code_review_title,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(
            width: 30,
          )
        ],
      ),
    );
  }

  Widget ratingStar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: RatingBar.builder(
        initialRating: 3,
        minRating: 1,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
        itemBuilder: (context, _) => const Icon(
          Icons.star,
          color: Colors.amber,
        ),
        onRatingUpdate: (ratingStar) {
          rating = ratingStar;
        },
      ),
    );
  }

  Widget comment(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0, left: 20, right: 20),
      child: SizedBox(
        height: 200,
        child: TextField(
          onChanged: (value) {
            typeComment = value;
          },
          focusNode: _focusNode,
          textAlignVertical: TextAlignVertical.top,
          maxLines: null,
          expands: true,
          decoration: InputDecoration(
            hintText: 'Type a comment...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  Widget images(BuildContext context) {
    return Expanded(
      child: Consumer2<RoomModel,UserModel>(
        builder: (context, roomProvider,userProvider, child) => GestureDetector(
          onTap: () => roomProvider.selectImages(context),
          child: Column(
            children: [
              Container(
                height: 100,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                  child: Icon(
                    Icons.camera_alt_outlined,
                    size: 45,
                    color: Colors.black.withOpacity(0.2),
                  ),
                ),
              ),
              roomProvider.images.isNotEmpty?
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(left: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: roomProvider.images.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder<File?>(
                      future: roomProvider.images[index].file,
                      builder:
                          (BuildContext context, AsyncSnapshot<File?> snapshot) {
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
              ):const Text(''),
              Container(
                  height: 50,
                  margin: const EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(onPressed: () async{
                    if(roomProvider.images.isNotEmpty){
                      setState(() {
                        isLoading=true;
                      });
                      await roomProvider.uploadImages();
                      roomProvider.reviewRoom(widget.room.roomId, userProvider.userCurrent!.id, rating, typeComment, roomProvider.listImageUrl);
                      setState(() {
                        isLoading=false;
                      });
                      // ignore: use_build_context_synchronously
                      Navigator.

                      of(context).push(slideRightToLeft(BoardingHouseDetail(motel: widget.room))).then((value) {
                        Navigator.pop(context);
                      });
                    }
                  }, child:  Text(S.of(context).qr_code_review_send,style: GoogleFonts.readexPro(color: Colors.white,letterSpacing: 1.5,fontSize: 20))))

            ],
          ),
        ),
      ),
    );
  }
}
