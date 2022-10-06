import 'package:flutter/material.dart';
import 'package:stattrack/components/CustomAppBar.dart';
import 'package:stattrack/services/auth.dart';
import 'package:stattrack/styles/font_styles.dart';

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
            child: const Icon(
              Icons.logout,
              color: Colors.black87,
            ),
          )
        ],
      ),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Sign in as: ${auth.currentUser?.email}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: FontStyles.fsTitle2,
                  fontWeight: FontStyles.fwTitle,
                ),
              )
            ],
          )),
    );
  }
}
