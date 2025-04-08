import 'package:flutter/material.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(children: [TabBarView(children: [])]),
      ),
    );
  }
  Widget _buildBody () {
    return SingleChildScrollView(

    );
  }
}
