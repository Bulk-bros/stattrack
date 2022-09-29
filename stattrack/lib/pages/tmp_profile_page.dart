import 'package:flutter/material.dart';
import 'package:stattrack/components/CustomAppBar.dart';
import 'package:stattrack/services/auth.dart';

class TmpProfilePage extends StatelessWidget {
  const TmpProfilePage({Key? key, required this.auth}) : super(key: key);

  final AuthBase auth;

  void _signOut() {
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        headerTitle: 'Tmp profile page',
        actions: <Widget>[
          TextButton(
            onPressed: _signOut,
            child: const Icon(Icons.logout),
          )
        ],
      ),
      body: Text('Sign in as: ${auth.currentUser?.uid}'),
    );
  }
}
