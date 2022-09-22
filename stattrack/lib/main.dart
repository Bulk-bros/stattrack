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
        textTheme: TextTheme(
          headline1: const TextStyle(
            fontSize: 31.0,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
          headline2: const TextStyle(
            fontSize: 20.0,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
          headline3: const TextStyle(
            fontSize: 16.0,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
          bodyText1: const TextStyle(
            fontSize: 16.0,
            fontFamily: 'Inter',
            fontWeight: FontWeight.normal,
          ),
          bodyText2: const TextStyle(
            fontSize: 13.0,
            fontFamily: 'Inter',
            fontWeight: FontWeight.normal,
          ),
          bodySmall: const TextStyle(
            fontSize: 10.0,
            fontFamily: 'Inter',
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      home: const SignInPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
