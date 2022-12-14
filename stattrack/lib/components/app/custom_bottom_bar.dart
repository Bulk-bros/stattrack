import 'package:flutter/material.dart';
import 'package:stattrack/components/meals/add_meal.dart';
import 'package:stattrack/styles/palette.dart';

import '../../utils/nav_button_options.dart';

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({Key? key, required this.onChange}) : super(key: key);

  final void Function(String) onChange;

  void _handleNavPressed(BuildContext context, int iconIndex) {
    double modalHeight = MediaQuery.of(context).size.height * 0.9;

    switch (iconIndex) {
      case 0:
        onChange(NavButtonOptions.profile);
        break;
      case 1:
        showModalBottomSheet<void>(
          isScrollControlled: true,
          context: context,
          builder: (context) => SizedBox(
            height: modalHeight,
            child: const AddMeal(),
          ),
        );
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
          label: "Profile",
          icon: Icon(
            Icons.person,
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.add_circle_rounded,
            color: Palette.accent[400]!,
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
      selectedIconTheme: const IconThemeData(
        color: Colors.black,
        size: 39.0,
      ),
      unselectedIconTheme: const IconThemeData(
        color: Colors.black,
        size: 39.0,
      ),
      onTap: (value) => _handleNavPressed(context, value),
    );
  }
}
