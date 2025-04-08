import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

import 'camera/camera_screen.dart';

class CustomAnimatedBottomBar extends StatelessWidget {
  const CustomAnimatedBottomBar({
    super.key,
    required this.selectedScreenIndex,
    required this.onItemTap,
  });

  final int selectedScreenIndex;
  final Function onItemTap;

  @override
  Widget build(BuildContext context) {
    var style = Theme.of(context)
        .textTheme
        .bodyMedium!
        .copyWith(fontSize: 11, fontWeight: FontWeight.w600);
    var barHeight = MediaQuery.of(context).size.height * 0.07;

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      color: selectedScreenIndex == 0 ? Colors.black : Colors.white,
      child: Container(
        decoration: BoxDecoration(
          color: selectedScreenIndex == 0 ? Colors.black : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        height: barHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _bottomNavBarItem(0, "Home", style, 'home'),
            _bottomNavBarItem(1, "Chat", style, 'message'),
            _addVideoNavItem(context, barHeight),
            _bottomNavBarItem(2, "Mailbox", style, 'profile'),
            _bottomNavBarItem(3, "Profile", style, 'profile'),
          ],
        ),
      ),
    );
  }

  Widget _bottomNavBarItem(
      int index, String label, TextStyle textStyle, String iconName) {
    bool isSelected = selectedScreenIndex == index;
    Color itemColor = isSelected ? Colors.black : Colors.grey.shade400;
    if (isSelected && selectedScreenIndex == 0) {
      itemColor = Colors.white;
    }

    return InkWell(
      onTap: () => onItemTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected ? itemColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: isSelected ? 24 : 20,
              height: isSelected ? 24 : 20,
              child: SvgPicture.asset(
                "assets/icons/${isSelected ? '${iconName}_filled' : iconName}.svg",
                color: itemColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: textStyle.copyWith(
                color: itemColor,
                fontSize: isSelected ? 11 : 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addVideoNavItem(BuildContext context, double barHeight) {
    bool _isNavigating = false;

    return InkWell(
      onTap: () {
        if (_isNavigating) {
          print("Navigation is already in progress.");
          return;
        }
        _isNavigating = true;
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return const CameraScreen();
        })).then((_) => _isNavigating = false);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: barHeight - 10,
        width: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.blueAccent, Colors.purpleAccent, Colors.redAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: 48,
            height: barHeight - 18,
            decoration: BoxDecoration(
              color: selectedScreenIndex == 0 ? Colors.white : Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.add,
              size: 28,
              color: selectedScreenIndex == 0 ? Colors.black : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}