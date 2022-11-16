import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Ingridient extends StatelessWidget {

  get onPressed => null;

  void submit() {
    print("make this function search for food");
  }

  final TextEditingController _ingridientController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          SizedBox(
            width: 360,
            child: TextField(
              controller: _ingridientController,
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
          SizedBox(width: 15,),
          SizedBox(
            width: 252,
            child: TextField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: ("Amount"),
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
          ),
        ],
      ),
    );
  }
}
