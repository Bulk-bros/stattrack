import 'package:flutter/material.dart';
import 'package:stattrack/components/CustomAppBar.dart';
import 'package:stattrack/components/buttons/auth_button.dart';
import 'package:stattrack/components/logos/logo.dart';
import 'package:stattrack/main.dart';
import 'package:stattrack/styles/font_styles.dart';
import 'package:stattrack/styles/palette.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(headerTitle: 'User Profile'),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    const spacing = SizedBox(height: 20.0);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildUserInformation(),
          spacing,
          _buildStatbox("Calories", "1236", 150),
          spacing,
          _buildStatbox("Proteins", "83g"),
          spacing,
          _buildStatbox("Carbs", "340g"),
          spacing,
          //_buildStatbox("Fat", "27g"),
        ],
      ),
    );
  }

// move this to component folder
  Widget _buildStatbox(String categoryText, String amountText,
      [double size = 100]) {
    return Container(
      height: size,
      child: Text(categoryText),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.10),
              spreadRadius: 5,
              blurRadius: 10,
              offset: Offset(0, 5))
        ],
      ),
    );
  }

  Widget _elevateStatbox(Widget widgetToElevate) {
    return Material(
      elevation: 20,
      child: widgetToElevate,
    );
  }

  Widget _buildUserInformation() {
    return Container(
      height: 250,
      color: Colors.red,
    );
  }
}
