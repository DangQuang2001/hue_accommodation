import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../constants/route_name.dart';
import '../../generated/l10n.dart';

class MyActivity extends StatefulWidget {
  const MyActivity({super.key});

  @override
  State<MyActivity> createState() => _MyActivityState();
}

class _MyActivityState extends State<MyActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [appBar(context), categories(context), content(context)],
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
            '     My Activity    ',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(
            width: 30,
          )
        ],
      ),
    );
  }

  //Filter by categories
  categories(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buttonLinkSmall(
              context,
              'https://cdn-icons-png.flaticon.com/512/4612/4612366.png',
              "Posts",
              RouteName.postHistory,
              300,
              false),
          buttonLinkSmall(
              context,
              'https://cdn-icons-png.flaticon.com/512/580/580670.png',
              "Rents",
              RouteName.rentHistory,
              300,
              false),
          buttonLinkSmall(
              context,
              'https://cdn-icons-png.flaticon.com/512/3208/3208707.png',
              "Favourites",
              RouteName.favorite,
              300,
              false),
        ],
      ),
    );
  }

  Widget content(BuildContext context) {
    return Column(
      children: [Text('')],
    );
  }

  Widget buttonLinkSmall(BuildContext context, String image, String name,
      String page, int duration, bool isComingSoon) {
    return SlideInRight(
      duration: Duration(milliseconds: duration),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              if (isComingSoon) {
                final snackBar = SnackBar(
                  backgroundColor: Colors.redAccent,
                  content: const Text('Chức năng đang được phát triển!'),
                  action: SnackBarAction(
                    label: 'Close',
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else {
                Navigator.pushNamed(context, page);
              }
            },
            child: Hero(
              tag: name,
              child: Container(
                padding: const EdgeInsets.all(15),
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: Theme.of(context).brightness == Brightness.light
                        ? [
                            BoxShadow(
                                blurRadius: 3,
                                offset: const Offset(0, 2),
                                color: Colors.grey.withOpacity(0.2))
                          ]
                        : null),
                child: Center(
                  child: CachedNetworkImage(imageUrl: image),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          SizedBox(
            width: 90,
            child: Center(
              child: Text(name,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall),
            ),
          ),
        ],
      ),
    );
  }
}
