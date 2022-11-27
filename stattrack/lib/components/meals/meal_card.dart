import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stattrack/components/cards/clickable_card.dart';
import 'package:stattrack/models/meal.dart';
import 'package:stattrack/providers/auth_provider.dart';
import 'package:stattrack/providers/repository_provider.dart';
import 'package:stattrack/services/api_paths.dart';
import 'package:stattrack/services/auth.dart';
import 'package:stattrack/services/repository.dart';
import 'package:stattrack/styles/font_styles.dart';

class MealCard extends ConsumerWidget {
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

  void _deleteMeal(BuildContext context, WidgetRef ref) {
    final AuthBase auth = ref.read(authProvider);
    final Repository repo = ref.read(repositoryProvider);

    // Delete image
    repo.deleteImage(meal.imageUrl);

    // Delete document
    repo.deleteMeal(auth.currentUser!.uid, meal.id).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Meal deleted'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const calorieLabel = 'Calories';
    const proteinLabel = 'Proteins';
    const fatLabel = 'Fat';
    const carbsLabel = 'Carbs';

    return Dismissible(
      key: Key(meal.id),
      onDismissed: (direction) {
        _deleteMeal(context, ref);
      },
      background: Container(
        color: Colors.red,
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const <Widget>[
              Icon(
                Icons.delete,
                color: Colors.white,
              ),
              Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
      child: ClickableCard(
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
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(meal.imageUrl),
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
      ),
    );
  }
}
