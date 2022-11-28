import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stattrack/components/app/custom_app_bar.dart';
import 'package:stattrack/components/forms/create_meal_form.dart';
import 'package:stattrack/models/ingredient.dart';
import 'package:stattrack/providers/auth_provider.dart';
import 'package:stattrack/providers/repository_provider.dart';
import 'package:stattrack/services/auth.dart';
import 'package:stattrack/services/repository.dart';

class CreateMeal extends ConsumerStatefulWidget {
  const CreateMeal({Key? key}) : super(key: key);

  @override
  _CreateMealState createState() => _CreateMealState();
}

class _CreateMealState extends ConsumerState<CreateMeal> {
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
