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
      children: [
        Text("Meals"),
        MealCard(
          assetName: ,
          calorieValue: ,
          proteinValue: ,
          fatValue: ,
          carbValue: ,
          timeValue: ,
        )
      ],
    ),
    );
  }

  }
