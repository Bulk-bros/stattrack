import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stattrack/components/buttons/main_button.dart';
import 'package:stattrack/components/meals/meal_card.dart';
import 'package:stattrack/models/meal.dart';
import 'package:stattrack/providers/auth_provider.dart';
import 'package:stattrack/providers/repository_provider.dart';
import 'package:stattrack/services/auth.dart';
import 'package:stattrack/services/repository.dart';
import 'package:stattrack/styles/palette.dart';

class AddMealSelect extends ConsumerStatefulWidget {
  const AddMealSelect({Key? key, required this.meals}) : super(key: key);

  final List<Meal> meals;
  @override
  _AddMealSelectState createState() => _AddMealSelectState();
}

class _AddMealSelectState extends ConsumerState<AddMealSelect> {
  Meal? _activeMeal;
  String? _errorMsg;

  void _updateAcitveMeal(Meal meal) {
    setState(() {
      _activeMeal = meal;
    });
  }

  void _logMeal(BuildContext context, String uid, Repository repo) {
    try {
      repo.logMeal(meal: _activeMeal!, uid: uid);
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _errorMsg = "Something wen't wrong... Please try again";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthBase auth = ref.read(authProvider);
    final Repository repo = ref.read(repositoryProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _buildList(context),
        MainButton(
          callback: _activeMeal == null
              ? null
              : () => _logMeal(context, auth.currentUser!.uid, repo),
          label: 'Eat Meal',
        ),
        Text(
          _errorMsg != null ? _errorMsg! : '',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildList(BuildContext context) {
    return Expanded(
      child: ListView(children: <Widget>[
        ...widget.meals.map(
          (meal) => Column(
            children: <Widget>[
              MealCard(
                meal: meal,
                onPressed: (m) => _updateAcitveMeal(m),
                backgroundColor:
                    _activeMeal == meal ? Palette.accent[400] : null,
                color: _activeMeal == meal ? Colors.white : null,
              ),
              const SizedBox(
                height: 16.0,
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
