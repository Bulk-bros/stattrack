import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stattrack/components/buttons/main_button.dart';
import 'package:stattrack/models/meal.dart';
import 'package:stattrack/providers/auth_provider.dart';
import 'package:stattrack/providers/repository_provider.dart';
import 'package:stattrack/services/auth.dart';
import 'package:stattrack/services/repository.dart';
import 'package:stattrack/styles/font_styles.dart';
import 'package:stattrack/styles/palette.dart';

/// Showcases a meal in a modal with all its nutriments
/// [meal] the meal to be shown in the modal
/// [width] width of the modal
class MealShowcase extends ConsumerStatefulWidget {
  MealShowcase({Key? key, required this.meal, this.width}) : super(key: key);

  final Meal meal;
  double? width;

  @override
  _MealShowcaseState createState() => _MealShowcaseState();
}

class _MealShowcaseState extends ConsumerState<MealShowcase> {
  bool _editable = false;

  void _toggleEditable() {
    setState(() {
      _editable = !_editable;
    });
  }

  void _logMeal(AuthBase auth, Repository repo) {
    try {
      repo.logMeal(meal: widget.meal, uid: auth.currentUser!.uid);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile picture was succesfully changed!'),
        ),
      );
    } finally {
      Navigator.of(context).pop();
    }
  }

  Future<void> _deleteMeal(
      BuildContext context, AuthBase auth, Repository repo) async {
    try {
      // Get image reference
      String imgUrl = widget.meal.imageUrl;

      // Delete meal
      await repo.deleteMeal(auth.currentUser!.uid, widget.meal.id);

      // Delete img
      await repo.deleteImage(imgUrl);

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not delete meal. Please try again!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthBase auth = ref.read(authProvider);
    final Repository repo = ref.read(repositoryProvider);

    const SizedBox separetor = SizedBox(
      height: 25.0,
    );

    return SizedBox(
      width: widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildHeader(),
              separetor,
              _buildNutrients(),
              separetor,
              _buildIngredients(),
              separetor,
              _buildInstructions(),
            ],
          ),
          _editable
              ? MainButton(
                  callback: () => _deleteMeal(context, auth, repo),
                  label: 'Delete meal',
                  backgroundColor: Colors.white,
                  borderColor: Colors.red,
                  color: Colors.red,
                  elevation: 0,
                )
              : MainButton(
                  callback: () => _logMeal(auth, repo),
                  label: 'Eat meal',
                ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: TextStyle(
              color: Palette.accent[400],
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(
                height: 20.0,
              ),
              CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: const AssetImage('assets/gifs/loading.gif'),
                radius: 50.0,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(widget.meal.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Text(
                widget.meal.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontStyles.fwTitle,
                  fontSize: FontStyles.fsTitle3,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: _toggleEditable,
          icon: const Icon(Icons.edit),
        )
      ],
    );
  }

  Widget _buildNutrients() {
    const SizedBox separetor = SizedBox(
      height: 6.0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const Text(
          'Nutrituons:',
          style: TextStyle(fontWeight: FontStyles.fwTitle),
        ),
        separetor,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text('Calories:'),
            Text('${widget.meal.calories}kcal'),
          ],
        ),
        separetor,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text('Fat:'),
            Text('${widget.meal.fat}g'),
          ],
        ),
        separetor,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text('Carbs:'),
            Text('${widget.meal.carbs}g'),
          ],
        ),
        separetor,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text('Protein:'),
            Text('${widget.meal.proteins}g'),
          ],
        ),
      ],
    );
  }

  Widget _buildIngredients() {
    const SizedBox separetor = SizedBox(
      height: 6.0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const Text(
          'Ingredients:',
          style: TextStyle(fontWeight: FontStyles.fwTitle),
        ),
        separetor,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[..._creatIngredientNameList(separetor)],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[..._creatIngredientValueList(separetor)],
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _creatIngredientNameList(SizedBox separetor) {
    List<Widget> list = [];

    for (String? string in widget.meal.ingredients.keys) {
      list.add(
        Text('$string'),
      );
      list.add(separetor);
    }

    return list;
  }

  List<Widget> _creatIngredientValueList(SizedBox separetor) {
    List<Widget> list = [];

    for (num value in widget.meal.ingredients.values) {
      list.add(
        Text('${value}g'),
      );
      list.add(separetor);
    }

    return list;
  }

  Widget _buildInstructions() {
    const SizedBox separetor = SizedBox(
      height: 6.0,
    );

    int stepNumber = 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const Text(
          'Instructions:',
          style: TextStyle(fontWeight: FontStyles.fwTitle),
        ),
        separetor,
        ...widget.meal.instuctions!.map((instruction) {
          stepNumber += 1;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              RowSuper(
                alignment: Alignment.topLeft,
                children: <Widget>[
                  Text('$stepNumber. '),
                  Text(instruction),
                ],
              ),
              separetor,
            ],
          );
        }),
      ],
    );
  }
}
