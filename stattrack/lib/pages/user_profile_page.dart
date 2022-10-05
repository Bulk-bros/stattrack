import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:stattrack/components/CustomAppBar.dart';
import 'package:stattrack/components/buttons/auth_button.dart';
import 'package:stattrack/components/logos/logo.dart';
import 'package:stattrack/main.dart';
import 'package:stattrack/styles/font_styles.dart';
import 'package:stattrack/styles/palette.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    const spacing = SizedBox(
      height: 20,
    );
    return Column(
      children: [
        ColumnSuper(
          innerDistance: -55,
          children: [
            _buildUserInformation("Jenny Nilsen", "23", "62kg", "173cm"),
            spacing,
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildStatbox("Calories", "1236", 230),
                  spacing,
                  _buildStatbox("Proteins", "83g"),
                  spacing,
                  _buildStatbox("Carbs", "340g"),
                  spacing,
                  _buildStatbox("Fat", "27g")
                ],
              ),
            ),
          ],
        ),
      ],
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
              offset: const Offset(0, 5))
        ],
      ),
    );
  }

  Widget _buildUserInformation(
      String name, String age, String weight, String height,
      [DecorationImage image = const DecorationImage(
          image: AssetImage("assets/images/eddyboy.jpeg"))]) {
    return Container(
        height: 320,
        width: 1000,
        decoration: BoxDecoration(
          color: Palette.accent[400],
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.10),
                spreadRadius: 5,
                blurRadius: 10,
                offset: Offset(0, 5))
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: RowSuper(
            fill: true,
            children: [
              _encaseProfilePicture(image),
              WrapSuper(
                wrapFit: WrapFit.proportional,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                            fontSize: FontStyles.fsTitle1,
                            color: Colors.white,
                            fontWeight: FontStyles.fwTitle),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: 190,
                        child: WrapSuper(
                          wrapFit: WrapFit.divided,
                          children: [
                            _statDetails("age", age, FontStyles.fsBodySmall,
                                FontStyles.fsBody, Colors.white),
                            _statDetails(
                                "weight",
                                weight,
                                FontStyles.fsBodySmall,
                                FontStyles.fsBody,
                                Colors.white),
                            _statDetails(
                                "height",
                                height,
                                FontStyles.fsBodySmall,
                                FontStyles.fsBody,
                                Colors.white),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30)
                    ],
                  )
                ],
              ),
            ],
          ),
        ));
  }

  Widget _encaseProfilePicture(DecorationImage image) {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(shape: BoxShape.circle, image: image),
    );
  }

  Widget _statDetails(String categoryText, String amountText,
      [double catergoryTextSize = FontStyles.fsBodySmall,
      double amountTextSize = FontStyles.fsBody,
      Color color = Colors.black]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(categoryText,
            style: TextStyle(fontSize: catergoryTextSize, color: color)),
        Text(amountText,
            style: TextStyle(
                fontSize: amountTextSize,
                fontWeight: FontStyles.fw600,
                color: color)),
      ],
    );
  }
}
