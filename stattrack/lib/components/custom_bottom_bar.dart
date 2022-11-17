import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:stattrack/components/add_meal.dart';
import 'package:stattrack/pages/log_page.dart';
import 'package:stattrack/styles/palette.dart';

class CustomBottomBar extends StatelessWidget {
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
        BottomNavigationBarItem(
          icon: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.person,
            ),
          ),
          label: "Profile",
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            icon: const Icon(
              Icons.add_circle_rounded,
            ),
            color: Palette.accent[400],
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return const AddMeal();
                },
              );
            },
          ),
          label: "Add Button",
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            onPressed: () => _navigteToLog(context),
            icon: const Icon(
              Icons.menu_rounded,
            ),
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
      //onTap: (value) => _handleNavPress(context, value),
    );
  }
}
