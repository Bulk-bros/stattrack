import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stattrack/components/app/custom_app_bar.dart';
import 'package:stattrack/pages/meal_pages/create_meal_info.dart';
import 'package:stattrack/pages/meal_pages/create_meal_ingredients.dart';
import 'package:stattrack/styles/palette.dart';

enum SubPages {
  info,
  ingredients,
  instructions,
  overview,
}

class CreateMealPage extends StatefulWidget {
  const CreateMealPage({Key? key}) : super(key: key);

  @override
  _CreateMealPageState createState() => _CreateMealPageState();
}

class _CreateMealPageState extends State<CreateMealPage> {
  SubPages _activePage = SubPages.ingredients;

  String? _id;
  String? _name;
  File? _image;
  Map<String?, num> _ingredients = {};
  List<dynamic> _instructions = [];

  void _handleNavBackwards() {
    switch (_activePage) {
      case SubPages.info:
        Navigator.of(context).pop();
        break;
      case SubPages.ingredients:
        setState(() {
          _activePage = SubPages.info;
        });
        break;
      case SubPages.instructions:
        setState(() {
          _activePage = SubPages.ingredients;
        });
        break;
      case SubPages.overview:
        setState(() {
          _activePage = SubPages.instructions;
        });
        break;
    }
  }

  String _getHeaderTitle() {
    switch (_activePage) {
      case SubPages.info:
        return 'Info';
      case SubPages.ingredients:
        return 'Ingredients';
      case SubPages.instructions:
        return 'Instructions';
      case SubPages.overview:
        return 'Overview';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        headerTitle: _getHeaderTitle(),
        navButton: IconButton(
          onPressed: _handleNavBackwards,
          icon: const Icon(
            Icons.navigate_before,
          ),
        ),
      ),
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
          onComplete: (name, image) => setState(() {
            _name = name;
            _image = image;
            _activePage = SubPages.ingredients;
          }),
        );
      case SubPages.ingredients:
        return CreateMealIngredients();

      case SubPages.instructions:
        return Text('yo');
      case SubPages.overview:
        return Text('yo');
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
