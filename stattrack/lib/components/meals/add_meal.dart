import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:stattrack/components/buttons/main_button.dart';
import 'package:stattrack/components/forms/form_fields/bordered_text_input.dart';
import 'package:stattrack/components/meals/meal_card.dart';
import 'package:stattrack/components/meals/meal_showcase.dart';
import 'package:stattrack/models/meal.dart';
import 'package:stattrack/pages/meal_pages/create_meal_page.dart';
import 'package:stattrack/providers/auth_provider.dart';
import 'package:stattrack/providers/meal_service_provider.dart';
import 'package:stattrack/services/auth.dart';
import 'package:stattrack/services/meal_service.dart';
import 'package:stattrack/styles/palette.dart';

class AddMeal extends ConsumerStatefulWidget {
  const AddMeal({Key? key}) : super(key: key);

  @override
  ConsumerState<AddMeal> createState() => _AddMealState();
}

class _AddMealState extends ConsumerState<AddMeal> {
  String _searchWord = '';

  void _updateSearchWord(String value) {
    setState(() {
      _searchWord = value;
    });
  }

  void _goToCreateMeal(BuildContext context) {
    Navigator.of(context).push(
      PageTransition(
        child: const CreateMealPage(),
        type: PageTransitionType.rightToLeft,
      ),
    );
  }

  Future<void> _openMealModal(BuildContext context, Meal meal) {
    final double modalContentWidth = MediaQuery.of(context).size.width * 1;

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(20.0),
            contentPadding: const EdgeInsets.all(16.0),
            content: MealShowcase(meal: meal, width: modalContentWidth),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final AuthBase auth = ref.read(authProvider);
    final MealService mealService = ref.read(mealServiceProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildNav(context),
          _buildSearch(),
          const SizedBox(
            height: 25.0,
          ),
          _buildGrid(auth, mealService, context),
        ],
      ),
    );
  }

  Widget _buildNav(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        TextButton(
          onPressed: () => _goToCreateMeal(context),
          child: Text(
            'Create new meal',
            style: TextStyle(
              color: Palette.accent[400],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearch() {
    return BorderedTextInput(
      hintText: 'Search...',
      onChanged: (value) => _updateSearchWord(value),
    );
  }

  Widget _buildGrid(
      AuthBase auth, MealService mealService, BuildContext context) {
    return StreamBuilder<List<Meal>>(
      stream: mealService.getMeals(auth.currentUser!.uid),
      builder: ((context, snapshot) {
        if (snapshot.connectionState != ConnectionState.active) {
          return Center(
            child: SizedBox(
              height: 50.0,
              width: 50.0,
              child: CircularProgressIndicator(
                color: Palette.accent[400],
              ),
            ),
          );
        }
        if (snapshot.data == null || snapshot.data!.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'You have no meals. Create one to get started!',
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 16.0,
              ),
              MainButton(
                onPressed: () => _goToCreateMeal(context),
                label: 'Create a new meal',
              ),
            ],
          );
        }

        List<Meal> meals = snapshot.data!
            .where((meal) =>
                meal.name.toLowerCase().contains(_searchWord.toLowerCase()))
            .toList();

        return Expanded(
          child: GridView.count(
            childAspectRatio: 1,
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            children: <Widget>[
              ...meals.map(
                (meal) => MealCard(
                  meal: meal,
                  onPressed: (m) => _openMealModal(context, m),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
