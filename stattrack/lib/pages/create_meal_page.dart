import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:stattrack/components/app/custom_app_bar.dart';
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

    Material(
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: ButtonStyle(alignment: Alignment.topLeft),
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Palette.accent[200],
                  fontSize: FontStyles.fsBody,
                  fontWeight: FontStyles.fwBody,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Info",
              style: TextStyle(
                fontSize: FontStyles.fsBody,
                fontWeight: FontStyles.fwBody,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: ("Name"),
                fillColor: Colors.white12,
                filled: true,
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.grey,
                )),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.grey,
                )),
              ),
              textInputAction: TextInputAction.next,
              onEditingComplete: _submit, // få den til å kalle en søkefunksjon
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Flexible(
                  flex: 3,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: ("Image"),
                      fillColor: Colors.white12,
                      filled: true,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.grey,
                      )),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.grey,
                      )),
                    ),
                    textInputAction: TextInputAction.next,
                    onEditingComplete:
                        _submit, // få den til å kalle en søkefunksjon
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Palette.accent[400]),
                      child: Text(
                        "Upload",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Ingredients",
              style: TextStyle(
                fontSize: FontStyles.fsBody,
                fontWeight: FontStyles.fwBody,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Ingridient(),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    backgroundColor: Palette.accent[400]),
                child: Text(
                  "Add ingredient",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Instructions",
                  style: TextStyle(
                    fontSize: FontStyles.fsBody,
                    fontWeight: FontStyles.fwBody,
                  ),
                ),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      "Create Ingredient",
                      style: TextStyle(
                        color: Palette.accent[200],
                        fontSize: FontStyles.fsBody,
                        fontWeight: FontStyles.fwBody,
                      ),
                    ))
              ],
            ),
            SizedBox(
              height: 8,
            ),
            FoodInstruction(),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    backgroundColor: Palette.accent[400]),
                child: Text(
                  "Add Instruction",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
