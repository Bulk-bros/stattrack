import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stattrack/components/CustomAppBar.dart';
import 'package:stattrack/components/buttons/main_button.dart';
import 'package:stattrack/models/meal.dart';
import 'package:stattrack/providers/repository_provider.dart';
import 'package:stattrack/services/auth.dart';
import 'package:stattrack/services/repository.dart';
import 'package:stattrack/providers/auth_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key? key, required this.auth}) : super(key: key);

  final AuthBase auth;

  void _signOut(BuildContext context) {
    auth.signOut();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Repository repo = ref.read(repositoryProvider);
    AuthBase auth = ref.read(authProvider);

    return Scaffold(
      appBar: CustomAppBar(
        headerTitle: "Settings",
      ),
      body: Padding(
        padding: const EdgeInsets.all(31.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // TODO: Add more settings options here
            MainButton(
              callback: () => _signOut(context),
              label: "Log out",
            ),
            ElevatedButton(
                onPressed: () {
                  repo.addMeal(
                    Meal(
                        name: "taco",
                        ingredients: {},
                        instuctions: ["cook kjøttdeig", "mix together"],
                        calories: 500,
                        proteins: 13,
                        fat: 5,
                        carbs: 100),
                    auth.currentUser!.uid,
                  );
                },
                child: const Text("Add dummy meals")),
          ],
        ),
      ),
    );
  }
}
