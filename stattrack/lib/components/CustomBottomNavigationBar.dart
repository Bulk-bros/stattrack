import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:stattrack/components/add_meal.dart';
import 'package:stattrack/pages/user_profile_page.dart';
import 'package:stattrack/styles/palette.dart';

import 'MealCard.dart';

class CustomBottomBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: IconButton(
            onPressed: () {  }, icon: Icon(Icons.person,),
          ),
          label: "Profile",
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            icon: Icon(Icons.add_circle_rounded,),
            color: Palette.accent[400],
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,

                builder: (BuildContext context) {
                  return AddMeal();
                },
              );
            },),
          label: "Add Button",
        ),
        BottomNavigationBarItem(
          icon: IconButton(
             onPressed: () {  }, icon: Icon(Icons.menu_rounded,),
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

  void showAddMeal (BuildContext buildContext) {
    Navigator.push(
        buildContext,
        PageTransition(
          type: PageTransitionType.bottomToTopPop,
          childCurrent: MealCard(
            assetName: "assets/images/foodstockpic.jpg",
            foodName: "Salad",
            calorieValue: 500,
            proteinValue: 50,
            fatValue: 5,
            carbValue: 150,
            timeValue: "08:45",
          ),
          child: AddMeal(),
        ));
  }



}


