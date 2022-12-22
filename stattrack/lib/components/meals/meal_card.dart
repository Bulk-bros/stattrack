import 'package:flutter/material.dart';
import 'package:stattrack/models/meal.dart';
import 'package:stattrack/styles/font_styles.dart';

class MealCard extends StatelessWidget {
  const MealCard({Key? key, required this.meal, required this.onPressed})
      : super(key: key);

  final Meal meal;
  final void Function(Meal) onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
      ),
      onPressed: () => onPressed(meal),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: const AssetImage('assets/gifs/loading.gif'),
              radius: 40.0,
              child: Container(
                width: 200,
                height: 200,
                decoration: meal.imageUrl != null
                    ? BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(meal.imageUrl!),
                          fit: BoxFit.cover,
                        ),
                      )
                    : const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage("assets/icons/meal-icon.png"),
                        ),
                      ),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            Flexible(
              child: Text(
                meal.name,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontStyles.fwTitle,
                  fontSize: FontStyles.fsTitle3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
