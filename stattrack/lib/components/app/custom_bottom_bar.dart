import 'package:flutter/material.dart';
import 'package:stattrack/components/meals/add_meal.dart';
import 'package:stattrack/styles/palette.dart';

import '../../utils/nav_button_options.dart';

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({Key? key, required this.onChange}) : super(key: key);

  final void Function(String) onChange;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: IconButton(
            onPressed: () => onChange(NavButtonOptions.profile),
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
                isScrollControlled: true,
                context: context,
                builder: (context) => SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: const AddMeal(),
                ),
              );
            },
          ),
          label: "Add Button",
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            onPressed: () => onChange(NavButtonOptions.log),
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
      selectedIconTheme: const IconThemeData(color: Colors.black, size: 39.0),
      unselectedIconTheme: const IconThemeData(color: Colors.black, size: 39.0),
      //onTap: (value) => _handleNavPress(context, value),
    );
  }
}
