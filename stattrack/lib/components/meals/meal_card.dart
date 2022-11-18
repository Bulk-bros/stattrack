import 'package:flutter/material.dart';
import 'package:stattrack/components/cards/clickable_card.dart';
import 'package:stattrack/models/meal.dart';
import 'package:stattrack/styles/font_styles.dart';

class MealCard extends StatelessWidget {
  MealCard({
    Key? key,
    required this.meal,
    this.timeValue,
    this.backgroundColor,
    this.color,
    required this.onPressed,
  }) : super(key: key);

  Meal meal;
  String? timeValue; //change to date later on

  Color? backgroundColor;
  Color? color;
  final void Function(Meal) onPressed;

  void _handlePressed() {
    onPressed(meal);
  }

  @override
  Widget build(BuildContext context) {
    const calorieLabel = 'Calories';
    const proteinLabel = 'Proteins';
    const fatLabel = 'Fat';
    const carbsLabel = 'Carbs';

    return ClickableCard(
      backgroundColor: backgroundColor,
      onPressed: _handlePressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              CircleAvatar(
                radius: 40.0,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage("assets/images/foodstockpic.jpg"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Text(
                meal.name,
                style: TextStyle(
                  fontSize: FontStyles.fsTitle3,
                  fontWeight: FontStyles.fwTitle,
                  color: color ?? Colors.black87,
                ),
              ),
            ],
          ),
          timeValue != null
              ? Column(
                  children: <Widget>[
                    Text(
                      'Time:',
                      style: TextStyle(
                        fontSize: FontStyles.fsTitle3,
                        fontWeight: FontStyles.fwTitle,
                        color: color ?? Colors.black87,
                      ),
                    ),
                    Text(
                      timeValue!,
                      style: TextStyle(
                        fontSize: FontStyles.fsBody,
                        fontWeight: FontStyles.fwBody,
                        color: color ?? Colors.black87,
                      ),
                    ),
                  ],
                )
              : const SizedBox(
                  height: 0.0,
                ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                calorieLabel,
                style: TextStyle(
                  fontSize: FontStyles.fsTitle3,
                  fontWeight: FontStyles.fwTitle,
                  color: color ?? Colors.black87,
                ),
              ),
              Text(
                proteinLabel,
                style: TextStyle(
                  fontSize: FontStyles.fsTitle3,
                  fontWeight: FontStyles.fwTitle,
                  color: color ?? Colors.black87,
                ),
              ),
              Text(
                fatLabel,
                style: TextStyle(
                  fontSize: FontStyles.fsTitle3,
                  fontWeight: FontStyles.fwTitle,
                  color: color ?? Colors.black87,
                ),
              ),
              Text(
                carbsLabel,
                style: TextStyle(
                  fontSize: FontStyles.fsTitle3,
                  fontWeight: FontStyles.fwTitle,
                  color: color ?? Colors.black87,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                '${meal.calories} kcal',
                style: TextStyle(
                  fontSize: FontStyles.fsBody,
                  color: color ?? Colors.black87,
                ),
              ),
              Text(
                '${meal.proteins} g',
                style: TextStyle(
                  fontSize: FontStyles.fsBody,
                  color: color ?? Colors.black87,
                ),
              ),
              Text(
                '${meal.fat} g',
                style: TextStyle(
                  fontSize: FontStyles.fsBody,
                  color: color ?? Colors.black87,
                ),
              ),
              Text(
                '${meal.carbs} g',
                style: TextStyle(
                  fontSize: FontStyles.fsBody,
                  color: color ?? Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
