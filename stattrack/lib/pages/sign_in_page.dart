import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:stattrack/components/buttons/auth_button.dart';
import 'package:stattrack/components/logos/logo.dart';

/// The signin page
class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContext(),
    );
  }

  Widget _buildContext() {
    const spacing = SizedBox(height: 20.0);

    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: <Widget>[
        const Positioned(
          top: 50.0,
          child: Logo(),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Login',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              spacing,
              AuthButton(
                label: 'Facebook',
                iconPath: 'assets/square-facebook.svg',
                iconAlt: 'Facebook Logo',
                bgColor: Colors.blue,
                textColor: Colors.white,
                // TODO: implement action
                onPressed: () {},
              ),
              spacing,
              AuthButton(
                label: 'Google',
                iconPath: 'assets/google.svg',
                iconAlt: 'Google Logo',
                bgColor: Colors.deepOrange[400],
                textColor: Colors.white,
                // TODO: implement action
                onPressed: () {},
              ),
              spacing,
              AuthButton(
                label: 'Email',
                iconPath: 'assets/envelope-solid.svg',
                iconAlt: 'Mail Icon',
                bgColor: Colors.white,
                textColor: Colors.black87,
                // TODO: implement action
                onPressed: () {},
              ),
              spacing,
              const Text(
                "Don't have an account? Sign up here",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
