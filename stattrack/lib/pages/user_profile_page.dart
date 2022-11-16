import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:stattrack/models/user.dart';
import 'package:stattrack/pages/settings_page.dart';
import 'package:stattrack/providers/auth_provider.dart';
import 'package:stattrack/providers/repository_provider.dart';
import 'package:stattrack/services/auth.dart';
import 'package:stattrack/services/repository.dart';
import 'package:stattrack/styles/font_styles.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:stattrack/components/custom_body.dart';
import 'package:stattrack/components/stats/single_stat_card.dart';
import 'package:stattrack/components/stats/single_stat_layout.dart';
import 'package:stattrack/components/meal_card.dart';
import 'package:stattrack/components/custom_bottom_bar.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:math' as math;
import 'package:stattrack/pages/account_setup/account_setup_page.dart';

import 'package:stattrack/styles/palette.dart';

import '../models/consumed_meal.dart';

enum NavButtons {
  macros,
  meals,
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
  num total = 0;
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
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
      bottomNavigationBar: const CustomBottomBar(),
    );
  }

  /// Builds the body of the profile page
  Widget _buildBody(BuildContext context) {
    final AuthBase auth = ref.read(authProvider);
    final Repository repo = ref.read(repositoryProvider);

    return CustomBody(
      header: StreamBuilder<User?>(
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
          total = user.dailyCalories;
          return _buildUserInformation(
              context, user.name, user.getAge(), user.weight, user.height);
        }),
      ),
      bodyWidgets: activeButton == NavButtons.macros
          ? [_buildTodaysMacros()]
          : [..._buildTodaysMeals()],
    );
  }

  /// Fills macro layout with correct macros
  Widget _buildTodaysMacros() {
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
          return _buildMacroLayout(
              macros: _calculateMacros(meals!),
              outputWidget: const Text(
                "No meals registered today",
                style:
                    TextStyle(color: Colors.white, fontSize: FontStyles.fsBody),
              ));
        }

        return _buildMacroLayout(macros: _calculateMacros(meals!));
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
      {required List<String> macros, Widget outputWidget = spacing}) {
    Widget output = Column(
      children: [spacing, outputWidget, spacing],
    );

    OpenPainter painter = OpenPainter(total: total, current: current);

    return Column(
      children: [
        outputWidget == spacing ? spacing : output,
        SingleStatCard(
            key: Key("mainDisplay"),
            content: SingleStatLayout(
                categoryText: "Calories",
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 230 - 60,
                      width: 200,
                      color: Colors.red,
                      child: CustomPaint(painter: painter),
                    )
                  ],
                )),
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

  /// Builds the main content of a user page
  Widget _buildProfilePageMainStatContent(String text, String amountText) {
    OpenPainter painter = OpenPainter(total: total, current: current);
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
            child: CustomPaint(painter: painter))
      ],
    );
  }

  /// Creates user information for the header in the custombody
  Widget _buildUserInformation(
      BuildContext context, String name, num age, num weight, num height,
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
                        Text(
                          name,
                          style: const TextStyle(
                              fontSize: FontStyles.fsTitle2,
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

  List<Widget> _buildTodaysMeals() {
    return [
      spacing,
      MealCard(
        assetName: "assets/images/foodstockpic.jpg",
        foodName: "Salad",
        calorieValue: 500,
        proteinValue: 50,
        fatValue: 5,
        carbValue: 150,
        timeValue: "08:45",
      ),
      spacing,
      MealCard(
        assetName: "assets/images/foodstockpic.jpg",
        foodName: "Taco wrap",
        calorieValue: 638,
        proteinValue: 38,
        fatValue: 32,
        carbValue: 241,
        timeValue: "16:13",
      ),
    ];
  }
}

class OpenPainter extends CustomPainter {
  num total = 0;
  num current = 0;

  OpenPainter({required this.total, required this.current});

  @override
  void paint(Canvas canvas, Size size) {
    size = Size(120, 200);
    print(size);

    String midText = "$current";
    String rightText = "$total";

    const rect = Rect.fromLTRB(40, 10, 300, 270);
    const startAngle = -math.pi;
    const sweepAngle = math.pi;
    const useCenter = false;
    final background = Paint()
      ..color = Colors.black12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 12;
    final fill = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 12;
    canvas.drawArc(rect, startAngle, sweepAngle, useCenter, background);

    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: FontStyles.fsBody,
    );

    final firstPainter = TextPainter(
      text: TextSpan(
        text: '0',
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
    );

    final middlePainter = TextPainter(
      text: TextSpan(
        text: midText,
        style: const TextStyle(
            color: Colors.black,
            fontSize: FontStyles.fsTitle1,
            fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    );

    firstPainter.layout(
      minWidth: 0,
      maxWidth: 2000,
    );
    middlePainter.layout(
      minWidth: 0,
      maxWidth: 2000,
    );

    firstPainter.paint(canvas, const Offset(40, 150));
    middlePainter.paint(canvas, const Offset(130, 80));

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
