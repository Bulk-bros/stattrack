import 'package:flutter/material.dart';
import 'package:stattrack/styles/font_styles.dart';

/// A card displaying stat data like calories, proteins, fat and carbs
///
/// [date] the date the stats where recorded
/// [calories] calories to be siaplayed
/// [proteins] proteins to be displayed
/// [fat] fat to be displayed
/// [carbs] carbs to be displayed
/// with more info
class StatCard extends StatelessWidget {
  const StatCard({
    Key? key,
    required this.date,
    required this.calories,
    required this.proteins,
    required this.fat,
    required this.carbs,
  }) : super(key: key);

  final String date;
  final num calories;
  final num proteins;
  final num fat;
  final num carbs;

  @override
  Widget build(BuildContext context) {
    const calorieLabel = 'Calories';
    const proteinLabel = 'Proteins';
    const fatLabel = 'Fat';
    const carbsLabel = 'Carbs';

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(date),
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
          height: 20.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _statItem(calorieLabel, calories),
            _statItem(proteinLabel, proteins),
            _statItem(fatLabel, fat),
            _statItem(carbsLabel, carbs),
          ],
        )
      ],
    );
  }

  Widget _statItem(String label, num value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label),
        Text(
          "$value",
          style: const TextStyle(
            fontSize: FontStyles.fsTitle2,
            fontWeight: FontStyles.fwTitle,
          ),
        ),
      ],
    );
  }
}
