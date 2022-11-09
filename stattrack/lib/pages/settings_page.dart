import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stattrack/components/CustomAppBar.dart';
import 'package:stattrack/components/buttons/main_button.dart';
import 'package:stattrack/providers/auth_provider.dart';
import 'package:stattrack/services/auth.dart';
import 'package:stattrack/styles/font_styles.dart';

import '../styles/palette.dart';

enum ProfileColors { green, pink, blue, red, yellow }

const spacing = SizedBox(
  height: 20,
);

class SettingsPage extends ConsumerStatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  void _signOut(BuildContext context, WidgetRef ref) {
    AuthBase auth = ref.read(authProvider);

    auth.signOut();
    Navigator.pop(context);
  }

  ProfileColors activeColor = ProfileColors.green;

  @override
  Widget build(BuildContext context) {
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
            _colorMenu(),
            spacing,
            MainButton(
              callback: () => _signOut(context, ref),
              label: "Log out",
            ),
          ],
        ),
      ),
    );
  }

  ProfileColors getActiveColor() {
    return activeColor;
  }

  Widget _colorContainer(Color value, ProfileColors color) {
    Border border = Border.all(width: 1, color: Colors.white);

    if (activeColor == color) {
      border = Border.all(width: 3, color: Colors.black);
    }

    return Container(
      margin: const EdgeInsets.all(3.0),
      padding: const EdgeInsets.all(3.0),
      height: 30,
      width: 30,
      decoration: BoxDecoration(color: value, border: border),
      child: InkWell(
        onTap: () => setState(() {
          activeColor = color;
        }),
        child: Ink(height: 100, width: 100, color: Colors.blue),
      ),
    );
  }

  Widget _colorMenu() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 50,
          child: Text(
            "Profile color: ",
            style: TextStyle(fontSize: FontStyles.fsTitle2),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _colorContainer(const Color(0xff51cf66), ProfileColors.green),
            _colorContainer(const Color(0xfff06595), ProfileColors.pink),
            _colorContainer(const Color(0xff339af0), ProfileColors.blue),
            _colorContainer(const Color(0xfffa5252), ProfileColors.red),
            _colorContainer(const Color(0xfffcc419), ProfileColors.yellow),
          ],
        )
      ],
    );
  }
}
