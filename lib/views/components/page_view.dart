import 'package:flutter/material.dart';
import 'package:hue_accommodation/views/boarding_house/boarding_house.dart';
import 'package:hue_accommodation/views/home/home.dart';
import 'package:hue_accommodation/views/messages/message.dart';

import '../user_info/user_info.dart';

class PageViewLayout extends StatefulWidget {
  final int selectedIndex;

  const PageViewLayout({Key? key, required this.selectedIndex})
      : super(key: key);

  @override
  State<PageViewLayout> createState() => _PageViewLayoutState();
}

class _PageViewLayoutState extends State<PageViewLayout> {
  PageController? controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = PageController(initialPage: widget.selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
      controller: controller,
      scrollDirection: Axis.horizontal,
      children: const [
        HomePage(),
        BoardingHousePage(),
        MessagePage(),
        UserInfoPage(),
      ],
    ));
  }
}
