import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stattrack/styles/palette.dart';

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
          ),
          label: "Profile",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.add_circle_rounded,
            color: Palette.accent[400],
          ),
          label: "Add Button",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.menu_rounded,
          ),
          label: "Menu",
        ),
      ],
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedFontSize: 0,
      unselectedFontSize: 0,
      selectedIconTheme: (IconThemeData(color: Colors.black, size: 48.0)),
      unselectedIconTheme: IconThemeData(color: Colors.black, size: 48.0),
    );
  }
}
