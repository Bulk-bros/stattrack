import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stattrack/components/MealCard.dart';

import '../components/CustomAppBar.dart';



class DailyLogPage extends StatefulWidget {
  const DailyLogPage({Key? key}) : super(key: key);

  @override
  State<DailyLogPage> createState() => _DailyLogPageState();
}

class _DailyLogPageState extends State<DailyLogPage> {




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        headerTitle: 'Log',
        navButton: IconButton(
          // TODO: Nav back one page
          onPressed: () => print('going back'),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
        ),
        actions: [
          IconButton(
            // TODO: Nav to stats page
            onPressed: () => print('stats'),
            icon: const Icon(
              Icons.bar_chart,
            ),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }


  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Calories \n 2500"),
              Text("Protein \n 200g"),
              Text("Fat \n 70g"),
              Text("Carbs \n 700"),
            ],
          ),
        ),
        Text(" Meals", style: TextStyle(),),
        MealCard(
          assetName: "assets/foodstockpic.jpg",
          foodName: "Salad",
          calorieValue: 500,
          proteinValue: 50,
          fatValue: 5,
          carbValue: 150,
          timeValue: "08:45",
        ),
        MealCard(
          assetName: "assets/foodstockpic.jpg",
          foodName: "Egg sandwich",
          calorieValue: 359,
          proteinValue: 27,
          fatValue: 19,
          carbValue: 190,
          timeValue: "11:30",
        ),MealCard(
          assetName: "assets/foodstockpic.jpg",
          foodName: "Taco wrap",
          calorieValue: 638,
          proteinValue: 38,
          fatValue: 32,
          carbValue: 241,
          timeValue: "16:13",
        ),

      ],
    ),
    );
  }

  }
