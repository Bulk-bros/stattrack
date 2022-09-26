import 'package:flutter/material.dart';
import 'package:stattrack/pages/log_page.dart';
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
        // Default font
        fontFamily: 'Inter',
      ),
      home: const LogPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
