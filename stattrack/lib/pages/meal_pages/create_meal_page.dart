import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stattrack/models/meal.dart';
import 'package:stattrack/pages/meal_pages/create_meal_info.dart';
import 'package:stattrack/pages/meal_pages/create_meal_ingredients.dart';
import 'package:stattrack/pages/meal_pages/create_meal_instructions.dart';
import 'package:stattrack/pages/meal_pages/create_meal_overview.dart';
import 'package:stattrack/providers/auth_provider.dart';
import 'package:stattrack/providers/repository_provider.dart';
import 'package:stattrack/repository/repository.dart';
import 'package:stattrack/services/api_paths.dart';
import 'package:stattrack/services/auth.dart';

enum SubPages {
  info,
  ingredients,
  instructions,
  overview,
}

class CreateMealPage extends ConsumerStatefulWidget {
  const CreateMealPage({Key? key}) : super(key: key);

  @override
  _CreateMealPageState createState() => _CreateMealPageState();
}

class _CreateMealPageState extends ConsumerState<CreateMealPage> {
  SubPages _activePage = SubPages.info;

  String? _name;
  Uint8List? _imageData;
  Map<String, num> _ingredients = {};
  List<dynamic> _instructions = [];

  num? _calories;
  num? _fat;
  num? _carbs;
  num? _proteins;

  Future<void> _handleSubmit() async {
    if (_name == null ||
        _imageData == null ||
        _ingredients.isEmpty ||
        _instructions.isEmpty ||
        _calories == null ||
        _fat == null ||
        _carbs == null ||
        _proteins == null) {
      print('something went wrong!!!');
    } else {
      final AuthBase auth = ref.read(authProvider);
      final Repository repo = ref.read(repositoryProvider);

      String imageUrl = await repo.uploadFileAsBytes(_imageData!,
          ApiPaths.mealImage(auth.currentUser!.uid, UniqueKey().toString()));

      await repo.addMeal(
          Meal(
            id: UniqueKey().toString(),
            name: _name!,
            imageUrl: imageUrl,
            ingredients: _ingredients,
            instuctions: _instructions,
            calories: _calories!,
            fat: _fat!,
            carbs: _carbs!,
            proteins: _proteins!,
          ),
          auth.currentUser!.uid);

      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(31.0),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    switch (_activePage) {
      case SubPages.info:
        return CreateMealInfo(
          navPrev: () => setState(() {
            Navigator.of(context).pop();
          }),
          onComplete: (name, image) => setState(() {
            _name = name;
            _imageData = image;
            _activePage = SubPages.ingredients;
          }),
        );
      case SubPages.ingredients:
        return CreateMealIngredients(
          navPrev: () => setState(() {
            _activePage = SubPages.info;
          }),
          onComplete: (ingredients, calories, fat, carbs, proteins) =>
              setState(() {
            _ingredients = ingredients;
            _calories = calories;
            _fat = fat;
            _carbs = carbs;
            _proteins = proteins;
            _activePage = SubPages.instructions;
          }),
        );
      case SubPages.instructions:
        return CreateMealInstructions(
          navPrev: () => setState(() {
            _activePage = SubPages.ingredients;
          }),
          onComplete: (instructions) => setState(() {
            _instructions = instructions;
            _activePage = SubPages.overview;
          }),
        );
      case SubPages.overview:
        return CreateMealOverview(
          navPrev: () => setState(() {
            _activePage = SubPages.instructions;
          }),
          onComplete: _handleSubmit,
          name: _name!,
          ingredients: _ingredients,
          instructions: _instructions,
          calories: _calories!,
          fat: _fat!,
          carbs: _carbs!,
          proteins: _proteins!,
        );
    }
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:stattrack/components/app/custom_app_bar.dart';
// import 'package:stattrack/components/forms/create_meal_form.dart';
// import 'package:stattrack/models/ingredient.dart';
// import 'package:stattrack/providers/auth_provider.dart';
// import 'package:stattrack/providers/repository_provider.dart';
// import 'package:stattrack/services/auth.dart';
// import 'package:stattrack/services/repository.dart';

// class CreateMeal extends ConsumerStatefulWidget {
//   const CreateMeal({Key? key}) : super(key: key);

//   @override
//   _CreateMealState createState() => _CreateMealState();
// }

// class _CreateMealState extends ConsumerState<CreateMeal> {
//   @override
//   Widget build(BuildContext context) {
//     final AuthBase auth = ref.read(authProvider);
//     final Repository repo = ref.read(repositoryProvider);

//     return Scaffold(
//       appBar: CustomAppBar(
//         headerTitle: 'Create Meal',
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(31.0),
//             stream: repo.getIngredients(auth.currentUser!.uid),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState != ConnectionState.active) {
//                 return const Text('No connection');
//               }
//               if (snapshot.data == null) {
//                 return const Text('No ingredients');
//               }
//               return CreateMealForm(
//                 storedIngredients: snapshot.data!,
//               );
//             }),
//       ),
//     );
//   }
// }
