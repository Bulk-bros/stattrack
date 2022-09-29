import 'package:flutter/material.dart';
import 'package:stattrack/pages/log_page.dart';
import 'package:stattrack/pages/sign_in_page.dart';
import 'package:stattrack/pages/user_profile_page.dart';
import 'package:stattrack/styles/palette.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      home: const UserProfilePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
