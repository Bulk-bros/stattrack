import 'package:flutter/material.dart';




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


  @override
  Widget build(BuildContext context) {
    const calorieLabel = 'Calories';
    const proteinLabel = 'Proteins';
    const fatLabel = 'Fat';
    const carbsLabel = 'Carbs';
    return
      Card(
        elevation: 2.0,
        child: Column(
          children: [
            ElevatedButton(onPressed: onPressed,
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
                      Text(foodName)
                    ],),
                  Text("Time \n $timeValue"),
                  Column(
                    children: const [
                      Text(calorieLabel),
                      Text(proteinLabel),
                      Text(fatLabel),
                      Text(carbsLabel),
                    ],
                  ),
                  Column(
                    children: [
                      Text("$calorieValue kcal"),
                      const Text("$proteinLabel g"),
                      const Text("$fatLabel g"),
                      const Text("$carbsLabel g"),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12.0,)],
        ),
      );
  }
}
