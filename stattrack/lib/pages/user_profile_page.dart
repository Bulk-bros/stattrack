import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:stattrack/components/CustomAppBar.dart';
import 'package:stattrack/components/buttons/auth_button.dart';
import 'package:stattrack/components/logos/logo.dart';
import 'package:stattrack/main.dart';
import 'package:stattrack/styles/font_styles.dart';
import 'package:stattrack/styles/palette.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'dart:math' as math;

enum NavButtons {
  macros,
  meals,
}

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  NavButtons activeButton = NavButtons.macros;

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
            _buildBaseContainer(
                _buildUserInformation("Jenny Nilsen", "23", "62kg", "173cm")),
            spacing,
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildCard(
                      _buildProfilePageMainStatContent(
                          "Calories", "GRAPH HERE"),
                      230),
                  spacing,
                  _buildCard(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _statDetails("Proteins", "83g", FontStyles.fsTitle3,
                            FontStyles.fsTitle1)
                      ],
                    ),
                  ),
                  spacing,
                  _buildCard(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _statDetails("Carbs", "340g", FontStyles.fsTitle3,
                            FontStyles.fsTitle1)
                      ],
                    ),
                  ),
                  spacing,
                  _buildCard(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _statDetails("Fat", "27g", FontStyles.fsTitle3,
                            FontStyles.fsTitle1)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfilePageMainStatContent(String text, String amountText) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(fontSize: FontStyles.fsTitle3),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: Text(
            amountText,
            style: const TextStyle(fontSize: FontStyles.fsTitle1),
          ),
        )
      ],
    );
  }

// move this to component folder
  Widget _buildCard(Widget content, [double size = 100]) {
    return Container(
        padding: const EdgeInsets.only(left: 20),
        height: size,
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
        child: content);
  }

  Widget _buildUserInformation(
      String name, String age, String weight, String height,
      [DecorationImage image = const DecorationImage(
          image: AssetImage("assets/images/eddyboy.jpeg"))]) {
    return ColumnSuper(
      outerDistance: -10,
      children: [
        const SizedBox(
          height: 55,
        ),
        RowSuper(
          fill: true,
          children: [
            _encaseProfilePicture(image),
            WrapSuper(
              wrapFit: WrapFit.divided,
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
                    const SizedBox(height: 25),
                    SizedBox(
                      width: 190,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _statDetails("age", age, FontStyles.fsBodySmall,
                              FontStyles.fsBody, Colors.white),
                          _statDetails(
                              "weight",
                              weight,
                              FontStyles.fsBodySmall,
                              FontStyles.fsBody,
                              Colors.white,
                              const Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 16,
                              )),
                          _statDetails("height", height, FontStyles.fsBodySmall,
                              FontStyles.fsBody, Colors.white),
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
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Container(
              width: 160,
              alignment: Alignment.centerLeft,
              child: _userInformationTextButton(
                  "Todays macros", activeButton == NavButtons.macros, () {
                setState(() {
                  activeButton = NavButtons.macros;
                });
              }),
            ),
            Container(
              width: 160,
              alignment: Alignment.centerLeft,
              child: _userInformationTextButton(
                  "Todays meals", activeButton == NavButtons.meals, () {
                setState(() {
                  activeButton = NavButtons.meals;
                });
              }),
            )
          ],
        ),
      ],
    );
  }

  //Base Container
  //Takes a widget parameter which is the body to be displayed on top
  //Widget makes sure the body has a padding
  Widget _buildBaseContainer(Widget body) {
    return Container(
      height: 320,
      width: 1000,
      decoration: BoxDecoration(
        color: Palette.accent[400],
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: body,
      ),
    );
  }

  Widget _userInformationTextButton(
      String text, bool highlight, VoidCallback callback) {
    FontWeight weight = FontStyles.fw400;
    TextDecoration decoration = TextDecoration.none; // Standard weight
    if (highlight) {
      weight = FontStyles.fw600;
      decoration = TextDecoration.underline;
    }
    return TextButton(
      onPressed: callback,
      style: TextButton.styleFrom(
        primary: Colors.white,
        padding: const EdgeInsets.all(0),
        splashFactory: NoSplash.splashFactory,
      ),
      child: Text(
        text,
        style: TextStyle(
            fontWeight: weight,
            decoration: decoration,
            decorationThickness: 2,
            fontSize: FontStyles.fs500),
      ),
    );
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
      Color color = Colors.black,
      Icon? icon]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(categoryText,
            style: TextStyle(fontSize: catergoryTextSize, color: color)),
        Row(
          children: [
            Text(
              amountText,
              style: TextStyle(
                  fontSize: amountTextSize,
                  fontWeight: FontStyles.fw600,
                  color: color),
            ),
            Transform.rotate(
              angle: -90 * math.pi / 180,
              child: icon ?? Text(""),
            )
          ],
        )
      ],
    );
  }
}
