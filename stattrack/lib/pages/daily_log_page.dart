import 'package:flutter/material.dart';
import 'package:stattrack/components/custom_app_bar.dart';
import 'package:stattrack/components/meal_card.dart';
import 'package:stattrack/styles/font_styles.dart';
import 'package:stattrack/styles/palette.dart';

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
        headerTitle: 'Daily log',
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Overiew",
            style: TextStyle(
              fontSize: FontStyles.fsTitle3,
              fontWeight: FontStyles.fwTitle,
            ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(
            height: 16.0,
          ),
          Material(
            elevation: 2.0,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              width: 375,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                color: Palette.accent[400],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const <Widget>[
                  Text(
                    "Calories \n 2500",
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    "Protein \n 200g",
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    "fat \n 70g",
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    "Carbs \n 700",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 24.0,
          ),
          const Text(
            " Meals",
            style: TextStyle(
              fontSize: FontStyles.fsTitle3,
              fontWeight: FontStyles.fwTitle,
            ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(
            height: 16.0,
          ),
          MealCard(
            assetName: "assets/images/foodstockpic.jpg",
            foodName: "Salad",
            calorieValue: 500,
            proteinValue: 50,
            fatValue: 5,
            carbValue: 150,
            timeValue: "08:45",
          ),
          const SizedBox(
            height: 8.0,
          ),
          MealCard(
            assetName: "assets/images/foodstockpic.jpg",
            foodName: "Egg sandwich",
            calorieValue: 359,
            proteinValue: 27,
            fatValue: 19,
            carbValue: 190,
            timeValue: "11:30",
          ),
          const SizedBox(
            height: 8.0,
          ),
          MealCard(
            assetName: "assets/images/foodstockpic.jpg",
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
