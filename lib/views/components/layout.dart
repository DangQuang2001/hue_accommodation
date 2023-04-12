import 'package:bottom_bar_matu/bottom_bar_matu.dart' as bottom_bar_matu;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_accommodation/view_models/chat_provider.dart';
import 'package:hue_accommodation/view_models/notification_provider.dart';
import 'package:hue_accommodation/views/notification/notification.dart';
import 'package:provider/provider.dart';

import '../home/home.dart';
import '../messages/message.dart';
import '../user_info/user_info.dart';

class Layout extends StatefulWidget {
  final Widget? child;
  final int selectedIndex;

  const Layout({Key? key, this.child, this.selectedIndex = 0})
      : super(key: key);

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int currentIndex = 0;
  bool _swipeIsInProgress = false;
  bool _tapIsBeingExecuted = false;
  int _selectedIndex = 0;
  int _prevIndex = 1;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(initialIndex: _selectedIndex, length: 4, vsync: this);
    _tabController.animation?.addListener(() {
      if (!_tapIsBeingExecuted &&
          !_swipeIsInProgress &&
          (_tabController.offset >= 0.5 || _tabController.offset <= -0.5)) {
        // detects if a swipe is being executed. limits set to 0.5 and -0.5 to make sure the swipe gesture triggered

        int newIndex = _tabController.offset > 0
            ? _tabController.index + 1
            : _tabController.index - 1;
        _swipeIsInProgress = true;
        _prevIndex = _selectedIndex;
        setState(() {
          _selectedIndex = newIndex;
        });
      } else {
        if (!_tapIsBeingExecuted &&
            _swipeIsInProgress &&
            ((_tabController.offset < 0.5 && _tabController.offset > 0) ||
                (_tabController.offset > -0.5 && _tabController.offset < 0))) {
          // detects if a swipe is being reversed. the

          _swipeIsInProgress = false;
          setState(() {
            _selectedIndex = _prevIndex;
          });
        }
      }
    });
    _tabController.addListener(() {
      _swipeIsInProgress = false;
      setState(() {
        _selectedIndex = _tabController.index;
      });
      if (_tapIsBeingExecuted == true) {
        _tapIsBeingExecuted = false;
      } else {
        if (_tabController.indexIsChanging) {
          // this is only true when the tab is changed via tap
          _tapIsBeingExecuted = true;
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer2<NotificationProvider,ChatProvider>(
      builder: (context, notificationProvider,chatProvider, child) => Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(color: Colors.white),
            child: TabBarView(
              controller: _tabController,
              children: const [
                HomePage(),
                MessagePage(),
                NotificationPage(),
                UserInfoPage(),
              ],
            ),
          ),
          Positioned(
              bottom: 10,
              left: 20,
              right: 20,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(70),
                child: bottom_bar_matu.BottomBarBubble(
                  backgroundColor: Theme.of(context).colorScheme.onBackground,
                  color: Colors.blue,
                  height: 70,
                  selectedIndex: _selectedIndex,
                  items: [
                    bottom_bar_matu.BottomBarItem(
                        iconData: Icons.home_outlined),
                  bottom_bar_matu.BottomBarItem(
                      iconBuilder: (color) => Stack(
                        children: [
                          Icon(
                            Icons.message_outlined,
                            color: color,
                            size: 31,
                          ),
                          chatProvider.listRoomChat.isEmpty?const Text(""):
                          Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.red,
                                ),
                                child: Center(
                                  child: Text(
                                    chatProvider.listRoomChat.length.toString() ,
                                    style: GoogleFonts.readexPro(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ))
                        ],
                      )),
                    bottom_bar_matu.BottomBarItem(
                        iconBuilder: (color) => Stack(
                              children: [
                                Icon(
                                  Icons.notifications_none,
                                  color: color,
                                  size: 31,
                                ),
                                notificationProvider.countNotification==0?const Text(""):
                                Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      width: 15,
                                      height: 15,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.red,
                                      ),
                                      child: Center(
                                        child: Text(
                                          notificationProvider.countNotification
                                              .toString(),
                                          style: GoogleFonts.readexPro(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ))
                              ],
                            )),
                    bottom_bar_matu.BottomBarItem(iconData: Icons.person),
                  ],
                  onSelect: (index) {
                    _tabController.animateTo(index);
                  },
                ),
              ))
        ],
      ),
    ));
  }
}
