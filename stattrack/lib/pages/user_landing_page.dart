import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stattrack/models/user.dart';
import 'package:stattrack/pages/account_setup/account_setup_page.dart';
import 'package:stattrack/pages/user_profile_page.dart';
import 'package:stattrack/providers/auth_provider.dart';
import 'package:stattrack/providers/repository_provider.dart';
import 'package:stattrack/services/auth.dart';
import 'package:stattrack/services/repository.dart';

class UserLandingPage extends ConsumerWidget {
  const UserLandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthBase auth = ref.read(authProvider);
    final Repository repo = ref.read(repositoryProvider);

    return StreamBuilder<User?>(
        stream: repo.getUsers(auth.currentUser!.uid),
        builder: ((context, snapshot) {
          if (snapshot.connectionState != ConnectionState.active) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          if (!snapshot.hasData) {
            return const AccountSetupPage();
          }
          return const UserProfilePage();
        }));
  }
}
