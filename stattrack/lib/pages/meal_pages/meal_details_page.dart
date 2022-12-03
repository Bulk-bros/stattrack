import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/material.dart';
import 'package:stattrack/components/app/custom_body.dart';
import 'package:stattrack/components/cards/custom_card.dart';
import 'package:stattrack/models/consumed_meal.dart';
import 'package:stattrack/styles/font_styles.dart';

class MealDetails extends StatelessWidget {
  MealDetails({Key? key, required this.meal}) : super(key: key);

  ConsumedMeal meal;

  final spacing = const SizedBox(
    height: 5,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody(context));
  }

  Widget _buildBody(context) {
    return CustomBody(
        header: _buildheader(context), bodyWidgets: [..._buildBodyWidgets()]);
  }

  Widget _buildheader(context) {
    return Column(
      children: [
        const SizedBox(
          height: 39,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.navigate_before_rounded,
                color: Colors.white,
              ),
              iconSize: 40,
            ),
            Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: const AssetImage('assets/gifs/loading.gif'),
                  radius: 65.0,
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
                  height: 8,
                ),
                _buildHeaderText(meal.name)
              ],
            ),
            Opacity(
              opacity: 0,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.navigate_before_rounded),
                iconSize: 40,
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildBodyWidgets() {
    const calorieLabel = 'Calories';
    const proteinLabel = 'Proteins';
    const fatLabel = 'Fat';
    const carbsLabel = 'Carbs';
    return [
      CustomCard(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Nutrition",
              style: TextStyle(
                  fontSize: FontStyles.fsBody, fontWeight: FontStyles.fwTitle),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: const <Widget>[
                    Text(
                      calorieLabel,
                      style: TextStyle(
                        fontSize: FontStyles.fsTitle3,
                        fontWeight: FontStyles.fwTitle,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      proteinLabel,
                      style: TextStyle(
                        fontSize: FontStyles.fsTitle3,
                        fontWeight: FontStyles.fwTitle,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      fatLabel,
                      style: TextStyle(
                        fontSize: FontStyles.fsTitle3,
                        fontWeight: FontStyles.fwTitle,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      carbsLabel,
                      style: TextStyle(
                        fontSize: FontStyles.fsTitle3,
                        fontWeight: FontStyles.fwTitle,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      '${meal.calories} kcal',
                      style: const TextStyle(
                        fontSize: FontStyles.fsBody,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '${meal.proteins} g',
                      style: const TextStyle(
                        fontSize: FontStyles.fsBody,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '${meal.fat} g',
                      style: const TextStyle(
                        fontSize: FontStyles.fsBody,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '${meal.carbs} g',
                      style: const TextStyle(
                        fontSize: FontStyles.fsBody,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      CustomCard(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Ingredients",
              style: TextStyle(
                  fontSize: FontStyles.fsBody, fontWeight: FontStyles.fwTitle),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [..._createIngredientList("name")],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [..._createIngredientList("value")],
                )
              ],
            )
          ],
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      CustomCard(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Step By Step",
              style: TextStyle(
                  fontSize: FontStyles.fsBody, fontWeight: FontStyles.fwTitle),
            ),
            const SizedBox(
              height: 20,
            ),
            _buildInstructions(),
          ],
        ),
      ),
    ];
  }

  Widget _buildInstructions() {
    int stepNumber = 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ...meal.instuctions!.map((intruction) {
          stepNumber += 1;

          return RowSuper(
            alignment: Alignment.topLeft,
            children: <Widget>[
              Text('$stepNumber. '),
              Text(intruction),
            ],
          );
        })
      ],
    );
  }

  List<Widget> _createIngredientList(String wantedList) {
    List<Widget> list = [];

    if (wantedList == "name") {
      if (meal.ingredients != null) {
        for (String? string in meal.ingredients!.keys) {
          list.add(Text(
            "- $string",
            style: const TextStyle(
                fontSize: FontStyles.fsBody, fontWeight: FontStyles.fwBody),
          ));
        }
      } else if (meal.ingredients == null) {
        list.add(const Text("No ingredients found"));
      }
    }
    if (wantedList == "value") {
      if (meal.ingredients != null) {
        for (num number in meal.ingredients!.values) {
          list.add(Text(
            "${number}g",
            style: const TextStyle(
                fontSize: FontStyles.fsBody, fontWeight: FontStyles.fwBody),
          ));
        }
      } else if (meal.ingredients == null) {
        list.add(const Text("No ingredients found"));
      }
    }

    return list;
  }

  Widget _buildHeaderText(String text) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: FontStyles.fsTitle1,
          fontWeight: FontStyles.fwTitle,
          color: Colors.white),
    );
  }
}
