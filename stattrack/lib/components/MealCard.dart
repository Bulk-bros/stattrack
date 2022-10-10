import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';




class MealCard extends StatelessWidget {
  MealCard({Key? key, required this.assetName, required this.calorieValue, required this.carbValue,
  required this.fatValue, required this.proteinValue, required this.timeValue}) : super(key: key);

  String assetName;
  String timeValue; //change to date later on

  int calorieValue;
  int proteinValue;
  int fatValue;
  int carbValue;

  get onPressed => null;


  @override
  Widget build(BuildContext context) {
    const calorieLabel = 'Calories';
    const proteinLabel = 'Proteins';
    const fatLabel = 'Fat';
    const carbsLabel = 'Carbs';
    return ElevatedButton(onPressed: onPressed, child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(assetName),
        Text("Time \n $timeValue"),
        Column(
            children: [
              Text(calorieLabel),
              Text(proteinLabel),
              Text(fatLabel),
              Text(carbsLabel),
            ],
        ),
        Column(
          children: [
            Text("$calorieValue kcal"),
            Text("$proteinLabel g"),
            Text("$fatLabel g"),
            Text("$carbsLabel g"),
          ],
        ),
      ],
    ));
  }
}
