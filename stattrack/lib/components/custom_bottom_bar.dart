import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:stattrack/pages/log_page.dart';
import 'package:stattrack/styles/palette.dart';

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({Key? key}) : super(key: key);

  /// Handles the event when one item from the nav bar
  /// is pressed
  ///
  /// [context] the current build context
  /// [itemIndex] the index of the item pressed
  void _handleNavPress(BuildContext context, num itemIndex) {
    switch (itemIndex) {
      case 0:
        // TODO: Navigate to profile page
        print('Navigate to profile page');
        break;
      case 1:
        // TODO: Open add meal dialog
        print('Opening add meal dialog');
        break;
      case 2:
        _navigteToLog(context);
        break;
    }
  }

  void _navigteToLog(BuildContext context) {
    Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          child: const LogPage(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
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
        const BottomNavigationBarItem(
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
      selectedIconTheme: const IconThemeData(color: Colors.black, size: 48.0),
      unselectedIconTheme: const IconThemeData(color: Colors.black, size: 48.0),
      onTap: (value) => _handleNavPress(context, value),
    );
  }
}
