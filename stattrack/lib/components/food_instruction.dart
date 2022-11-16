import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FoodInstruction extends StatelessWidget {


  get onPressed => null;

  void submit() {
    print("make this function search for food");
  }

  final TextEditingController _instuctionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
            child: TextField(
              controller: _instuctionController,
              decoration: InputDecoration(
                labelText: ("Instruction"),
                fillColor: Colors.white12,
                filled: true,
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey,)
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey,)
                ),
              ),
              textInputAction: TextInputAction.done,
              onEditingComplete:submit, // få den til å kalle en søkefunksjon
            ),
          );
  }
}
