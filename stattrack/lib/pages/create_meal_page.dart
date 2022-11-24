import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:stattrack/components/app/custom_app_bar.dart';
import 'package:stattrack/components/buttons/main_button.dart';
import 'package:stattrack/components/cards/clickable_card.dart';
import 'package:stattrack/components/forms/create_meal_form.dart';
import 'package:stattrack/components/forms/form_fields/bordered_text_input.dart';
import 'package:stattrack/components/forms/form_fields/image_picker_input.dart';
import 'package:stattrack/components/meals/food_instruction.dart';
import 'package:stattrack/components/meals/ingridient.dart';
import 'package:stattrack/models/ingredient.dart';
import 'package:stattrack/pages/create_ingredient_page.dart';
import 'package:stattrack/providers/auth_provider.dart';
import 'package:stattrack/providers/repository_provider.dart';
import 'package:stattrack/services/auth.dart';
import 'package:stattrack/services/repository.dart';
import 'package:stattrack/styles/palette.dart';

import '../styles/font_styles.dart';

class CreateMeal extends ConsumerStatefulWidget {
  const CreateMeal({Key? key}) : super(key: key);

  @override
  _CreateMealState createState() => _CreateMealState();
}

class _CreateMealState extends ConsumerState<CreateMeal> {
  final TextEditingController _nameController = TextEditingController();

  String get _name => _nameController.text;
  XFile? _image;
  Map<Ingredient, num> ingredients = {};

  void _submit() {
    print("make this function search for food");
  }

  void _updateState() {
    setState(() {});
  }

  void _navToCreateIngredient(BuildContext context) {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: CreateIngredientPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AuthBase auth = ref.read(authProvider);
    final Repository repo = ref.read(repositoryProvider);

    return Scaffold(
      appBar: CustomAppBar(
        headerTitle: 'Create Meal',
      ),
      body: Padding(
        padding: const EdgeInsets.all(31.0),
        child: StreamBuilder<List<Ingredient>?>(
            stream: repo.getIngredients(auth.currentUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.active) {
                return const Text('No connection');
              }
              if (snapshot.data == null) {
                return const Text('No ingredients');
              }
              return CreateMealForm(
                storedIngredients: snapshot.data!,
              );
            }),
      ),
    );
  }
}
