import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stattrack/components/food_instruction.dart';
import 'package:stattrack/components/ingridient.dart';
import 'package:stattrack/models/ingredient.dart';
import 'package:stattrack/styles/palette.dart';

class CreateMeal extends StatelessWidget {

  get onPressed => null;

  void submit() {
    print("make this function search for food");
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Info"),
          SizedBox(height: 20,),
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
              SizedBox(
                width: 400,
                child: TextField(
                  controller: _imageController,
                  decoration: InputDecoration(
                    labelText: ("Ingridient"),
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
              SizedBox(
                width: 216,
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
            ],
          ),
          SizedBox(height: 20,),
          Text("Ingredients"),
          SizedBox(height: 10,),
          Ingridient(),
          SizedBox(height: 20,),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(backgroundColor: Palette.accent[400]),
            child: Text("Add ingredient",
              style: TextStyle(
                color: Colors.white,
              ),),
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Instructions"),
              TextButton(onPressed: onPressed,
                  child: Text("Create Ingredient"))
            ],
          ),
          SizedBox(height: 20,),
          FoodInstruction(),
          SizedBox(height: 20,),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(backgroundColor: Palette.accent[400]),
            child: Text("Add Instruction",
              style: TextStyle(
                color: Colors.white,
              ),),
          ),
        ],
      ),
    );
  }
}
