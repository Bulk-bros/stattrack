import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:stattrack/pages/settings_page.dart';
import 'package:stattrack/services/auth.dart';
import 'package:stattrack/styles/font_styles.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:stattrack/components/CustomBody.dart';
import 'package:stattrack/components/stats/SingleStatCard.dart';
import 'package:stattrack/components/stats/SingleStatLayout.dart';

enum NavButtons {
  macros,
  meals,
}

const spacing = SizedBox(
  height: 20,
);

/// Page displaying a users profile and their macros
class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key, required this.auth}) : super(key: key);

  final AuthBase auth;

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  NavButtons activeButton = NavButtons.macros;

  /// Displays the settings page
  ///
  /// [context] the build context to show the settings page over
  void _showSettings(BuildContext context) {
    Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          child: SettingsPage(auth: widget.auth),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  /// Builds the body of the profile page
  Widget _buildBody(BuildContext context) {
    return CustomBody(
      header:
          _buildUserInformation(context, "Jenny Nilsen", "23", "62kg", "173cm"),
      bodyWidgets: [
        SingleStatCard(
            content: _buildProfilePageMainStatContent("Calories", "GRAPH HERE"),
            size: 230),
        spacing,
        SingleStatCard(
            content: SingleStatLayout(
                categoryText: "Proteins",
                amountText: "83g",
                categoryTextSize: FontStyles.fsTitle3,
                amountTextSize: FontStyles.fsTitle1)),
        spacing,
        SingleStatCard(
            content: SingleStatLayout(
                categoryText: "Carbs",
                amountText: "340g",
                categoryTextSize: FontStyles.fsTitle3,
                amountTextSize: FontStyles.fsTitle1)),
        spacing,
        SingleStatCard(
            content: SingleStatLayout(
                categoryText: "Fat",
                amountText: "27g",
                categoryTextSize: FontStyles.fsTitle3,
                amountTextSize: FontStyles.fsTitle1)),
      ],
    );
  }

  /// Builds the main content of a user page
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

  /// Creates user information for the header in the custombody
  Widget _buildUserInformation(BuildContext context, String name, String age,
      String weight, String height,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          name,
                          style: const TextStyle(
                              fontSize: FontStyles.fsTitle1,
                              color: Colors.white,
                              fontWeight: FontStyles.fwTitle),
                        ),
                        TextButton(
                          onPressed: () => _showSettings(context),
                          child: const Icon(
                            Icons.settings,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: 190,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SingleStatLayout(
                              categoryText: "age",
                              amountText: age,
                              color: Colors.white),
                          SingleStatLayout(
                              categoryText: "weight",
                              amountText: weight,
                              color: Colors.white,
                              icon: const Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 16,
                              )),
                          SingleStatLayout(
                              categoryText: "height",
                              amountText: height,
                              color: Colors.white),
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
}
