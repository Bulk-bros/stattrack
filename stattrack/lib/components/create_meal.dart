import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stattrack/components/food_instruction.dart';
import 'package:stattrack/components/ingridient.dart';
import 'package:stattrack/models/ingredient.dart';
import 'package:stattrack/styles/palette.dart';

import '../styles/font_styles.dart';

class CreateMeal extends StatelessWidget {

  get onPressed => null;

  void submit() {
    print("make this function search for food");
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextButton(onPressed: () => Navigator.pop(context),
              style: ButtonStyle(
                alignment: Alignment.topLeft
              ),
              child: Text("Cancel",
                style: TextStyle(
                  color: Palette.accent[200],
                  fontSize: FontStyles.fsBody,
                  fontWeight: FontStyles.fwBody,
                ),),),
            SizedBox(height: 10,),
            Text("Info", style: TextStyle(
              fontSize: FontStyles.fsBody,
              fontWeight: FontStyles.fwBody,
            ),),
            SizedBox(height: 8,),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: ("Name"),
                fillColor: Colors.white12,
                filled: true,
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey,)
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey,)
                ),

              ),
              textInputAction: TextInputAction.next,
              onEditingComplete:submit, // få den til å kalle en søkefunksjon
            ),
            SizedBox(height: 20,),
            Row(
              children: [
                Flexible(
                  flex: 3,
                  child: TextField(
                    controller: _imageController,
                    decoration: InputDecoration(
                      labelText: ("Image"),
                      fillColor: Colors.white12,
                      filled: true,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey,)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey,)
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    onEditingComplete:submit, // få den til å kalle en søkefunksjon
                  ),
                ),
                SizedBox(width: 20,),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: (){},
                      style: ElevatedButton.styleFrom(backgroundColor: Palette.accent[400]),
                      child: Text("Upload",
                        style: TextStyle(
                        color: Colors.white,
                      ),),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20,),
            Text("Ingredients", style: TextStyle(
    fontSize: FontStyles.fsBody,
    fontWeight: FontStyles.fwBody,
    ),),
            SizedBox(height: 10,),
            Ingridient(),
            SizedBox(height: 20,),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: (){},
                style: ElevatedButton.styleFrom(backgroundColor: Palette.accent[400]),
                child: Text("Add ingredient",
                  style: TextStyle(
                    color: Colors.white,
                  ),),
              ),
            ),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Instructions", style: TextStyle(
                  fontSize: FontStyles.fsBody,
                  fontWeight: FontStyles.fwBody,
                ),),
                TextButton(onPressed: (){},
                    child: Text("Create Ingredient",
                      style: TextStyle(
                        color: Palette.accent[200],
                        fontSize: FontStyles.fsBody,
                        fontWeight: FontStyles.fwBody,
              ),))
              ],
            ),
            SizedBox(height: 8,),
            FoodInstruction(),
            SizedBox(height: 20,),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: (){},
                style: ElevatedButton.styleFrom(backgroundColor: Palette.accent[400]),
                child: Text("Add Instruction",
                  style: TextStyle(
                    color: Colors.white,
                  ),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
