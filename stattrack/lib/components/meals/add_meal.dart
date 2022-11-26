import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:stattrack/components/forms/form_fields/bordered_text_input.dart';
import 'package:stattrack/components/meals/add_meal_select.dart';
import 'package:stattrack/pages/create_meal_page.dart';
import 'package:stattrack/models/meal.dart';
import 'package:stattrack/providers/auth_provider.dart';
import 'package:stattrack/providers/repository_provider.dart';
import 'package:stattrack/services/auth.dart';
import 'package:stattrack/services/repository.dart';
import 'package:stattrack/styles/font_styles.dart';
import 'package:stattrack/styles/palette.dart';

class AddMeal extends ConsumerStatefulWidget {
  const AddMeal({Key? key, required this.height}) : super(key: key);

  // Height of the widget
  final double height;

  @override
  _AddMealState createState() => _AddMealState();
}

class _AddMealState extends ConsumerState<AddMeal> {
  String _searchInput = '';

  void _showCreateMeal(BuildContext context) {
    Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          child: CreateMeal(),
        ));
  }

  void _updateSearch(String search) {
    setState(() {
      _searchInput = search.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    final AuthBase auth = ref.read(authProvider);
    final Repository repo = ref.read(repositoryProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Palette.accent[200],
                    fontSize: FontStyles.fsBody,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => _showCreateMeal(context),
                child: Text(
                  'Create new meal',
                  style: TextStyle(
                    color: Palette.accent[200],
                    fontSize: FontStyles.fsBody,
                  ),
                ),
              ),
            ],
          ),
          BorderedTextInput(
            hintText: 'Search',
            onChanged: (value) => _updateSearch(value),
          ),
          const SizedBox(
            height: 16.0,
          ),
          StreamBuilder<List<Meal>>(
            stream: repo.getMeals(auth.currentUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.active) {
                return const Text('');
              }
              if (snapshot.data == null || snapshot.data!.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'No meals',
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return SizedBox(
                height: widget.height * 0.79,
                child: AddMealSelect(
                    meals: snapshot.data!
                        .where((meal) =>
                            meal.name.toLowerCase().contains(_searchInput))
                        .toList()),
              );
            },
          ),
        ],
      ),
    );
  }
}
