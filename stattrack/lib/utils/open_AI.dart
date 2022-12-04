///Recommends Meal from the OpenAI Recipie Creator API

///Create a meal from a list of ingredients
///[ingredients] is a list of ingredients to create a meal from
///[temperature] is the temperature of the model
///[topP] is the topP of the model
///[frequencyPenalty] is the frequencyPenalty of the model
///[presencePenalty] is the presencePenalty of the model
///[bestOf] is the bestOf of the model
///[maxTokens] is the maxTokens of the model

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:stattrack/models/ingredient.dart';

class OpenAI {
  static const String _apiKey = '';
  static const String _engineId = 'davinci';
  static const String _url =
      'https://api.openai.com/v1/engines/$_engineId/completions';
  static const String _prompt =
      'Write a recipe based on these ingredients and instructions';

  static Future<String> recommendMeal(
      List<Ingredient> ingredients, List<String> instructions,
      {String model = 'text-davinci-003',
      double temperature = 0.3,
      double topP = 1,
      double frequencyPenalty = 0,
      double presencePenalty = 0,
      int bestOf = 1,
      int maxTokens = 250}) async {
    final String ingredientsString =
        ingredients.map((Ingredient ingredient) => ingredient.name).join(', ');
    final String instructionsString = instructions.join(', ');
    final String request = jsonEncode({
      'prompt':
          '${OpenAI._prompt} \n Ingredients : $ingredientsString \n Instructions : $instructionsString',
      'temperature': temperature,
      'top_p': topP,
      'frequency_penalty': frequencyPenalty,
      'presence_penalty': presencePenalty,
      'best_of': bestOf,
      'max_tokens': maxTokens,
    });

    final http.Response response = await http.post(
      Uri.parse(OpenAI._url),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${OpenAI._apiKey}',
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: request,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      print(data);
      return data['choices'][0]['text'];
    } else {
      throw Exception('Failed to recommend meal');
    }
  }
}
