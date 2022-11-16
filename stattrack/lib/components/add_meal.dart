import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stattrack/styles/palette.dart';

import '../styles/font_styles.dart';
import 'MealCard.dart';

class AddMeal extends StatelessWidget {

  get onPressed => null;

  void searchAndSubmit() {
    print("make this function search for food");
  }

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        color: Colors.white,
      ),
      padding: EdgeInsetsDirectional.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(onPressed: onPressed,
                child: Text("Cancel",
                  style: TextStyle(
                      color: Palette.accent[200],
                      fontSize: FontStyles.fsBody,
                      fontWeight: FontStyles.fwBody,
                  ),),),
              TextButton(onPressed: onPressed,
                child: Text("Create new meal",
                  style: TextStyle(
                      color: Palette.accent[200],
                      fontSize: FontStyles.fsBody,
                      fontWeight: FontStyles.fwBody,
                  ),),),
            ],
          ),
          SizedBox(height: 20.0,),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: ("Search"),
              fillColor: Colors.white12,
              filled: true,
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey,)
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey,)
              ),
            ),
            textInputAction: TextInputAction.done,
            onEditingComplete:searchAndSubmit, // få den til å kalle en søkefunksjon
          ),
          SizedBox(height: 20.0,),
          MealCard(
            assetName: "assets/images/foodstockpic.jpg",
            foodName: "Salad",
            calorieValue: 500,
            proteinValue: 50,
            fatValue: 5,
            carbValue: 150,
            timeValue: "08:45",
          ),
          SizedBox(height: 20.0,),
          MealCard(
            assetName: "assets/images/foodstockpic.jpg",
            foodName: "Taco wrap",
            calorieValue: 638,
            proteinValue: 38,
            fatValue: 32,
            carbValue: 241,
            timeValue: "16:13",
          ),
          SizedBox(height: 20.0,),
          OutlinedButton(onPressed: onPressed, child: Text("Add",
            style: TextStyle(
              fontSize: FontStyles.fsBody,
              fontWeight: FontStyles.fw500,
              color: Colors.black87),),
          style: OutlinedButton.styleFrom(
            backgroundColor: Palette.accent[400],
            elevation: 8.0,
          ),)
        ],
      ),
    );
  }
}
