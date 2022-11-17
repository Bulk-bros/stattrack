import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:stattrack/pages/log_page.dart';
import 'package:stattrack/pages/nav_wrapper.dart';
import 'package:stattrack/pages/user_profile_page.dart';
import 'package:stattrack/styles/palette.dart';

import '../utils/nav_button_options.dart';

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({Key? key, required this.onChange}) : super(key: key);

  final void Function(String) onChange;

  /// Handles the event when one item from the nav bar
  /// is pressed
  ///
  /// [context] the current build context
  /// [itemIndex] the index of the item pressed
  void _handleNavPress(BuildContext context, num itemIndex) {
    switch (itemIndex) {
      case 0:
        onChange(NavButtonOptions.profile);
        break;
      case 1:
        // TODO: Open add meal dialog
        print('Opening add meal dialog');
        break;
      case 2:
        onChange(NavButtonOptions.log);
        break;
    }
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
