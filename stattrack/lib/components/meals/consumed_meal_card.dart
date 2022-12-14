import 'package:flutter/material.dart';
import 'package:stattrack/components/cards/clickable_card.dart';
import 'package:stattrack/models/consumed_meal.dart';
import 'package:stattrack/styles/font_styles.dart';

class ConsumedMealCard extends StatelessWidget {
  ConsumedMealCard({
    Key? key,
    required this.meal,
    this.timeValue,
    this.backgroundColor,
    this.color,
    required this.onPressed,
  }) : super(key: key);

  ConsumedMeal meal;

  String? timeValue; //change to date later on

  Color? backgroundColor;
  Color? color;
  final void Function(ConsumedMeal) onPressed;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              timeValue != null
                  ? Text(
                      timeValue!,
                      style: TextStyle(
                        fontSize: FontStyles.fsBody,
                        fontWeight: FontStyles.fwBody,
                        color: color ?? Colors.black87,
                      ),
                    )
                  : const SizedBox(
                      height: 0,
                    ),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: const <Widget>[
                  Text('Details'),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16.0,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: <Widget>[
                  const SizedBox(
                    height: 8,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage:
                        const AssetImage('assets/gifs/loading.gif'),
                    radius: 40.0,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(meal.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
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
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        ],
      ),
    );
  }
}
