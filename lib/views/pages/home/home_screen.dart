import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiktokclone/views/pages/home/user/user_info_screen.dart';
import 'package:tiktokclone/views/pages/home/video/videoscreen.dart';

import 'bottom_navigation_bar.dart';
import 'chat/chat_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _tabIndex = 0;
  final List<Widget> _list = [
    VideoScreen(),
    ChatScreen(),
    const UserInfoScreen(),
    const UserInfoScreen()
  ];

  void _changeTabIndex(int index) {
    setState(() {
      _tabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: _list[_tabIndex],
        ),
        bottomNavigationBar: CustomAnimatedBottomBar(
          selectedScreenIndex: _tabIndex,
          onItemTap: _changeTabIndex,
        ));
  }
}