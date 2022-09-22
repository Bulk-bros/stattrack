import 'package:flutter/material.dart';
import 'package:stattrack/pages/sign_in_page.dart';
import 'package:stattrack/styles/palette.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // Colors
        primarySwatch: Palette.accent,

        // Fonts
        // Default font
        fontFamily: 'Inter',
        // Specific font styles
        textTheme: const TextTheme(
          headline1: TextStyle(
            fontSize: 31.0,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      home: const SignInPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
