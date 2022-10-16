import 'package:flutter/material.dart';

import '../styles/font_styles.dart';




class MealCard extends StatelessWidget {
  MealCard({Key? key, required this.assetName, required this.calorieValue, required this.carbValue,
  required this.fatValue, required this.proteinValue, required this.timeValue,
  required this.foodName}) : super(key: key);

  String assetName;
  String timeValue; //change to date later on
  String foodName;

  int calorieValue;
  int proteinValue;
  int fatValue;
  int carbValue;

  get onPressed => null;

  void mealCardClicked() {
    print("the button is clickable");
  }

  @override
  Widget build(BuildContext context) {
    const calorieLabel = 'Calories';
    const proteinLabel = 'Proteins';
    const fatLabel = 'Fat';
    const carbsLabel = 'Carbs';
    return
            ElevatedButton(onPressed: mealCardClicked,
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column( mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 50.0,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration:  BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AssetImage(assetName),
                                fit: BoxFit.fill
                            ),
                          ),
                        ),
                      ),
                      Text(foodName, style: TextStyle(fontSize: FontStyles.fsTitle3,
                          fontWeight: FontStyles.fwTitle, color: Colors.black87))
                    ],),
                  Column(
                    children: [
                      Text("Time:", style: TextStyle(fontSize: FontStyles.fsTitle3,
                          fontWeight: FontStyles.fwTitle, color: Colors.black87)),
                      Text("$timeValue", style: TextStyle(fontSize: FontStyles.fsBody,
                          fontWeight: FontStyles.fwBody, color: Colors.black87)),
                    ],

                  ),
                  Column(
                    children:  [
                      Container(
                        width: 70,
                        alignment: Alignment.centerLeft,
                        child: Text(calorieLabel, style: TextStyle(fontSize: FontStyles.fsTitle3,
                          fontWeight: FontStyles.fwTitle, color: Colors.black87), textAlign: TextAlign.left,),
                      ),
                      Container(
                        width: 70,
                        alignment: Alignment.centerLeft,
                        child: Text(proteinLabel, style: TextStyle(fontSize: FontStyles.fsTitle3,
                          fontWeight: FontStyles.fwTitle, color: Colors.black87),),
                      ),
                      Container(
                        width: 70,
                        alignment: Alignment.centerLeft,
                        child: Text(fatLabel, style: TextStyle(fontSize: FontStyles.fsTitle3,
                          fontWeight: FontStyles.fwTitle, color: Colors.black87),  textAlign: TextAlign.left,),
                      ),
                      Container(
                        width: 70,
                        alignment: Alignment.centerLeft,
                        child: Text(carbsLabel, style: TextStyle(fontSize: FontStyles.fsTitle3,
                          fontWeight: FontStyles.fwTitle, color: Colors.black87),),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: 70,
                        alignment: Alignment.centerRight,
                        child: Text("$calorieValue kcal", style: TextStyle(fontSize: FontStyles.fsBody,
                          fontWeight: FontStyles.fwBody, color: Colors.black87),),
                      ),
                      Container(
                        width: 70,
                        alignment: Alignment.centerRight,
                        child: Text("$proteinValue g", style: TextStyle(fontSize: FontStyles.fsBody,
                          fontWeight: FontStyles.fwBody, color: Colors.black87),),
                      ),
                      Container(
                        width: 70,
                        alignment: Alignment.centerRight,
                        child: Text("$fatValue g", style: TextStyle(fontSize: FontStyles.fsBody,
                          fontWeight: FontStyles.fwBody, color: Colors.black87),),
                      ),
                      Container(
                        width: 70,
                        alignment: Alignment.centerRight,
                        child: Text("$carbValue g", style: TextStyle(fontSize: FontStyles.fsBody,
                          fontWeight: FontStyles.fwBody, color: Colors.black87),),
                      ),
                    ],
                  ),
                ],
              ),
      );
  }
}
