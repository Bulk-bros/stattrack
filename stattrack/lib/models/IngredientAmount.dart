// ignore: file_names
import 'package:flutter/material.dart';
import 'package:stattrack/models/ingredient.dart';

class IngredientAmount {
  const IngredientAmount(
      {Key? key, required this.ingredient, required this.amount});

  final Ingredient ingredient;
  final num amount;
}
