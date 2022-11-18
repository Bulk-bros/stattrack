import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:stattrack/components/meals/add_meal.dart';
import 'package:stattrack/models/meal.dart';
import 'package:stattrack/models/user.dart';
import 'package:stattrack/pages/settings_pages/settings_page.dart';
import 'package:stattrack/providers/auth_provider.dart';
import 'package:stattrack/providers/repository_provider.dart';
import 'package:stattrack/services/auth.dart';
import 'package:stattrack/services/repository.dart';
import 'package:stattrack/styles/font_styles.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:stattrack/components/app/custom_body.dart';
import 'package:stattrack/components/stats/single_stat_card.dart';
import 'package:stattrack/components/stats/single_stat_layout.dart';
import 'package:stattrack/components/meals/meal_card.dart';
import 'package:stattrack/components/app/custom_bottom_bar.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:math' as math;
import 'package:stattrack/pages/account_setup/account_setup_page.dart';

import 'package:stattrack/styles/palette.dart';

import '../models/consumed_meal.dart';

enum NavButtons {
  macros,
  meals,
  addMeal,
}

const spacing = SizedBox(
  height: 20,
);

/// Page displaying a users profile and their macros
class UserProfilePage extends ConsumerStatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends ConsumerState<UserProfilePage> {
  num current = 0;
  num dailyCalories = 0;
  bool hasDailyMeal = true;
  NavButtons activeButton = NavButtons.macros;

  /// Displays the settings page
  ///
  /// [context] the build context to show the settings page over
  void _showSettings(BuildContext context) {
    final AuthBase auth = ref.read(authProvider);

    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: SettingsPage(auth: auth),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  /// Builds the body of the profile page
  Widget _buildBody(BuildContext context) {
    final AuthBase auth = ref.read(authProvider);
    final Repository repo = ref.read(repositoryProvider);

    return StreamBuilder<User?>(
      stream: repo.getUsers(auth.currentUser!.uid),
      builder: ((context, snapshot) {
        if (snapshot.connectionState != ConnectionState.active) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }
        if (!snapshot.hasData) {
          return const Text("No data");
        }
        final User user = snapshot.data!;

        return CustomBody(
          header: _buildUserInformation(
            context,
            user.profilePictureUrl,
            user.name,
            user.getAge(),
            user.weight,
            user.height,
          ),
          bodyWidgets: activeButton == NavButtons.macros
              ? [_buildTodaysMacros(user.dailyCalories)]
              : [..._buildTodaysMeals()],
        );
      }),
    );
  }

  /// Fills macro layout with correct macros
  Widget _buildTodaysMacros(num dailyCalories) {
    return StreamBuilder<List<ConsumedMeal>>(
      stream: _mealStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.active) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final meals = snapshot.data;
        if (snapshot.hasError) {
          return _buildErrorText(snapshot.hasError.toString());
        }
        if (snapshot.data!.isEmpty) {
          hasDailyMeal = false;
          return _buildMacroLayout(
              macros: _calculateMacros(meals!), dailyCalories: dailyCalories);
        }
        hasDailyMeal = true;
        return _buildMacroLayout(
            macros: _calculateMacros(meals!), dailyCalories: dailyCalories);
      },
    );
  }

  Widget _buildErrorText(String msg) {
    return SizedBox(
      height: 48,
      child: Center(
        child: Text(msg),
      ),
    );
  }

  /// Calculates macros from the a list of meals
  List<String> _calculateMacros(List<ConsumedMeal> meals) {
    num calories = 0;
    num proteins = 0;
    num carbs = 0;
    num fat = 0;
    for (var element in meals) {
      {
        calories += element.calories;
        current = calories;
        proteins += element.proteins;
        carbs += element.carbs;
        fat += element.fat;
      }
    }

    return ["$calories", "$proteins", "$carbs", "$fat"];
  }

  /// returns a stream of meals from the firebase database
  Stream<List<ConsumedMeal>> _mealStream() {
    final Repository repo = ref.read(repositoryProvider);
    final AuthBase auth = ref.read(authProvider);
    return repo.getTodaysMeals(auth.currentUser!.uid);
  }

  /// Builds the macro layout
  Widget _buildMacroLayout(
      {required List<String> macros, required dailyCalories}) {
    OpenPainter painter = OpenPainter(total: dailyCalories, current: current);

    return Column(
      children: [
        spacing,
        SingleStatCard(
            content: SingleStatLayout(
              categoryText: "Calories",
              content: SizedBox(
                height: 230 - 60,
                width: 200,
                child: hasDailyMeal
                    ? CustomPaint(painter: painter)
                    : Container(
                        alignment: Alignment.center,
                        child: const Text(
                          "No meals registered today",
                          style: TextStyle(fontSize: FontStyles.fsTitle2),
                          textAlign: TextAlign.center,
                        ),
                      ),
              ),
              categoryTextSize: FontStyles.fsTitle3,
            ),
            size: 230),
        spacing,
        SingleStatCard(
            content: SingleStatLayout(
                categoryText: "Proteins",
                amountText: "${macros[1]}g",
                categoryTextSize: FontStyles.fsTitle3,
                amountTextSize: FontStyles.fsTitle1)),
        spacing,
        SingleStatCard(
            content: SingleStatLayout(
                categoryText: "Carbs",
                amountText: "${macros[2]}g",
                categoryTextSize: FontStyles.fsTitle3,
                amountTextSize: FontStyles.fsTitle1)),
        spacing,
        SingleStatCard(
            content: SingleStatLayout(
                categoryText: "Fat",
                amountText: "${macros[3]}g",
                categoryTextSize: FontStyles.fsTitle3,
                amountTextSize: FontStyles.fsTitle1)),
      ],
    );
  }

  /// Creates user information for the header in the custombody
  Widget _buildUserInformation(BuildContext context, String profilePictureUrl,
      String name, num age, num weight, num height) {
    return ColumnSuper(
      outerDistance: -10,
      children: [
        const SizedBox(
          height: 55,
        ),
        RowSuper(
          fill: true,
          children: [
            _buildProfileImage(profilePictureUrl),
            const SizedBox(
              width: 20,
            ),
            WrapSuper(
              wrapFit: WrapFit.divided,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: RichText(
                            overflow: TextOverflow.ellipsis,
                            strutStyle: const StrutStyle(fontSize: 16.0),
                            text: TextSpan(
                              text: name,
                              style: const TextStyle(
                                  fontSize: FontStyles.fsTitle2,
                                  color: Colors.white,
                                  fontWeight: FontStyles.fwTitle),
                            ),
                          ),
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
                              amountText: "$age",
                              color: Colors.white),
                          SingleStatLayout(
                              categoryText: "weight",
                              amountText: "$weight",
                              color: Colors.white,
                              icon: const Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 16,
                              )),
                          SingleStatLayout(
                              categoryText: "height",
                              amountText: "$height",
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
            ),
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
        foregroundColor: Colors.white,
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

  // [DecorationImage image = const DecorationImage(image: AssetImage("assets/images/eddyboy.jpeg"))]

  Widget _buildProfileImage(String profilePictureUrl) {
    if (profilePictureUrl != '') {
      return Container(
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(profilePictureUrl),
          ),
        ),
      );
    } else {
      return Container(
        width: 110,
        height: 110,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage("assets/images/default-profile-picture.png"),
            opacity: 0.4,
          ),
        ),
      );
    }
  }

  List<Widget> _buildTodaysMeals() {
    return [
      spacing,
      MealCard(
        meal: Meal(
          name: "Salad",
          calories: 500,
          proteins: 50,
          fat: 5,
          carbs: 150,
        ),
        timeValue: "08:45",
        onPressed: (id) => print("pressed $id"),
      ),
      spacing,
      MealCard(
        meal: Meal(
          name: "Taco wrap",
          calories: 638,
          proteins: 38,
          fat: 32,
          carbs: 241,
        ),
        timeValue: "16:13",
        onPressed: (id) => print("pressed $id"),
      ),
    ];
  }

  // TODO: Ask torstein if this is in use... should not be since it's moved
  // to custom bottom bar so it's available for every pages with nav bar
  List<Widget> _buildAddMeal() {
    return [
      AddMeal(),
    ];
  }
}

class OpenPainter extends CustomPainter {
  OpenPainter({required this.total, required this.current});
  num total = 0;
  num current = 0;

  @override
  void paint(Canvas canvas, Size size) {
    size = const Size(200, 200);

    const rect = Rect.fromLTRB(-30, 10, 230, 270);
    const startAngle = -math.pi;
    const sweepAngle = math.pi;
    const useCenter = false;
    final background = Paint()
      ..color = Colors.black12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 12;
    canvas.drawArc(rect, startAngle, sweepAngle, useCenter, background);

    _drawTextAt("0", const Offset(-25, 160), canvas, FontStyles.fsBody);
    _drawTextAt("$current", const Offset(100, 85), canvas, FontStyles.fsTitle1,
        fontWeight: FontStyles.fwTitle);
    _drawTextAt("$total", const Offset(235, 160), canvas, FontStyles.fsBody);

    /// update sweep angle with amount of calories

    Path path = Path()
      ..arcTo(rect, startAngle, _calculateAngle(current, total), true);
    canvas.drawPath(
        path,
        Paint()
          ..color = _calculateAngle(current, total) == math.pi
              ? Colors.red
              : Colors.green
          ..strokeWidth = 12
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke);
  }

  /// Draws text at a position offset
  /// has a disgusting way of centering text concidering how many characters are to be displayed
  void _drawTextAt(String text, Offset position, Canvas canvas, double textsize,
      {FontWeight fontWeight = FontStyles.fwBody}) {
    final textStyle = TextStyle(
      color: Colors.black,
      fontSize: textsize,
      fontWeight: fontWeight,
    );

    const halfOfCharWidth = 10;
    double x;

    if (text.length < 5) {
      x = position.dx - text.length * halfOfCharWidth;
    } else {
      const chubbyFaceHalfWidth = 28;
      x = position.dx - chubbyFaceHalfWidth;
      text = "o  o\n)-(";
    }

    final textSpan = TextSpan(
      text: text,
      style: textStyle,
    );
    final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center);
    textPainter.layout(minWidth: 0, maxWidth: 200);

    Offset drawPosition = Offset(x, position.dy - (textPainter.height / 2));
    textPainter.paint(canvas, drawPosition);
  }

  double _calculateAngle(num current, num total) {
    double percentage = current / total;
    double deg = percentage * 180;
    double rad = deg * (math.pi / 180);
    if (current > total) {
      rad = math.pi;
    }
    return rad;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
