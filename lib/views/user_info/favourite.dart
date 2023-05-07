import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hue_accommodation/view_models/favourite_model.dart';
import 'package:hue_accommodation/views/boarding_house/boarding_house_detail.dart';
import 'package:hue_accommodation/views/components/slide_route.dart';
import 'package:provider/provider.dart';

import '../../view_models/user_model.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [appBar(context), content(context)],
      ),
    );
  }

  Widget appBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0, right: 20, left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_outlined,
              size: 30,
            ),
          ),
          Text(
            '     Favourite    ',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(
            width: 30,
          )
        ],
      ),
    );
  }

  Widget content(BuildContext context) {
    return Consumer2<FavouriteModel, UserModel>(
      builder: (context, favouriteProvider, userProvider, child) => Expanded(
        child: FutureBuilder(
          future: favouriteProvider.getFavourite(userProvider.userCurrent!.id),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Danh sách yêu thích trống!'),
              );
            }
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: ()=>Navigator.of(context).push(slideRightToLeft(BoardingHouseDetail(motel: snapshot.data![index].room))),
                    child: Container(
                          margin: const EdgeInsets.only(
                              bottom: 20, left: 20, right: 20),
                          height: 150,
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onBackground,
                              borderRadius: BorderRadius.circular(20)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Slidable(
                              key: const ValueKey(0),

                              // The start action pane is the one at the left or the top side.
                              endActionPane: ActionPane(
                                // A motion is a widget used to control how the pane animates.
                                motion: const ScrollMotion(),

                                // A pane can dismiss the Slidable.
                                // dismissible: DismissiblePane(onDismissed: () {}),

                                // All actions are defined in the children parameter.
                                children: [
                                  // A SlidableAction can have an icon and/or a label.

                                  SlidableAction(
                                    onPressed: (context) async{
                                     await favouriteProvider.removeFavourite(snapshot.data![index].room.roomId, userProvider.userCurrent!.id);
                                      setState(() {
                                      });
                                    },
                                    backgroundColor:
                                    const Color(0xFFFE4A49),
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Remove favourite',
                                  ),
                                ],
                              ),
                              child: Flex(direction: Axis.horizontal, children: [
                                Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: CachedNetworkImage(
                                          imageUrl: snapshot.data![index].room.image,
                                          fit: BoxFit.cover,
                                          width: MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context).size.width,
                                        ),
                                      ),
                                    )),
                                Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15.0, bottom: 10, right: 10),
                                      child: Column(
                                        children: [
                                          Text(
                                            snapshot.data![index].room.name,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayMedium,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Icon(Icons.location_on_outlined),
                                              Expanded(
                                                  child: Text(
                                                snapshot.data![index].room
                                                    .adParams['address']['value'],
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displaySmall,
                                              )),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.star_rate,color: Colors.yellow,),
                                              Expanded(
                                                  child: Text("Rating: ${snapshot.data![index].room
                                                        .rating}",
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displayMedium!.copyWith(color: Colors.orange),
                                                  )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )),
                              ]),
                            ),
                          ),
                        ),
                  ));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
