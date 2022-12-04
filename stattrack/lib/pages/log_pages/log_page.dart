import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:stattrack/components/app/custom_app_bar.dart';
import 'package:stattrack/components/cards/clickable_card.dart';
import 'package:stattrack/components/cards/custom_card.dart';
import 'package:stattrack/components/stats/stat_card_layout.dart';
import 'package:stattrack/models/consumed_meal.dart';
import 'package:stattrack/pages/log_pages/graph_page.dart';
import 'package:stattrack/pages/log_pages/log_details.dart';
import 'package:stattrack/pages/user_profile_page.dart';
import 'package:stattrack/providers/auth_provider.dart';
import 'package:stattrack/providers/repository_provider.dart';
import 'package:stattrack/services/repository.dart';
import 'package:stattrack/styles/palette.dart';
import 'package:week_of_year/week_of_year.dart';

enum NavItem { daily, weekly, monthly, yearly }

final List<num> daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
final List<String> month = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];

class LogPage extends ConsumerStatefulWidget {
  const LogPage({Key? key}) : super(key: key);

  @override
  _LogPageState createState() => _LogPageState();
}

class _LogPageState extends ConsumerState<LogPage> {
  NavItem activeNavItem = NavItem.daily;

  /// Handlse the event when nav item is presses
  ///
  /// [selected] the nav item presses
  void _handleNavSelect(NavItem selected) {
    setState(() {
      activeNavItem = selected;
    });
  }

  /// Navigates to graph page
  void _navToGrapgPage(BuildContext context) {
    Navigator.of(context).push(PageTransition(
      child: const GraphPage(),
      type: PageTransitionType.rightToLeft,
    ));
  }

  /// Converts a list of [ConsumedMeal]'s to a map group by day, week,
  /// month or year based on the active nav item that is sorted by time
  ///
  /// [meals] list of meals to convert
  /// [activeNavItem] the active nav item determining the grouping
  /// (day, week, month or year)
  Map<DateTime, List<ConsumedMeal>> _groupMeals(
      List<ConsumedMeal> meals, NavItem activeNavItem) {
    final Map<DateTime, List<ConsumedMeal>> groupedMeals = {};

    for (var meal in meals) {
      final DateTime date = meal.time;
      final DateTime dateKey = _getDateKey(date, activeNavItem);

      if (groupedMeals.containsKey(dateKey)) {
        groupedMeals[dateKey]!.add(meal);
      } else {
        groupedMeals[dateKey] = [meal];
      }
    }

    return groupedMeals;
  }

  /// Returns the date key for a given date based on the active nav item.
  ///
  /// [date] the date to get the key for
  /// [activeNavItem] the active nav item determining the grouping
  /// (day, week, month or year)
  DateTime _getDateKey(DateTime date, NavItem activeNavItem) {
    switch (activeNavItem) {
      case NavItem.daily:
        return DateTime(date.year, date.month, date.day);
      case NavItem.weekly:
        return DateTime(date.year, date.month, date.day - date.weekday);
      case NavItem.monthly:
        return DateTime(date.year, date.month);
      case NavItem.yearly:
        return DateTime(date.year);
    }
  }

  /// Returns a string representing the day, week, month or year for a given date
  /// based on the active nav item. (e.g. if daily is active, card will display
  /// the date, if weekly is active, the card will display the week number, if
  /// monthly is active, the card will display the month...)
  ///
  /// [date] the date to represent
  String _getCardDate(DateTime date) {
    switch (activeNavItem) {
      case NavItem.daily:
        return "${date.day}.${date.month}.${date.year}";
      case NavItem.weekly:
        return "Week ${date.weekOfYear}, ${date.year}";
      case NavItem.monthly:
        return "${month[date.month - 1]} ${date.year}";
      case NavItem.yearly:
        return "${date.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        headerTitle: 'Log',
        actions: <Widget>[
          IconButton(
            onPressed: () => _navToGrapgPage(context),
            icon: const Icon(Icons.bar_chart_rounded),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  /// Returns the body of the log page
  Widget _buildBody() {
    final Repository repo = ref.read(repositoryProvider);
    final String uid = ref.read(authProvider).currentUser!.uid;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: <Widget>[
          _buildNav(),
          const SizedBox(
            height: 16.0,
          ),
          StreamBuilder<List<ConsumedMeal>>(
            stream: repo.getLog(uid),
            builder: ((context, snapshot) {
              if (snapshot.connectionState != ConnectionState.active) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return _buildErrorText('Error: ${snapshot.error}');
              }
              if (!snapshot.hasData) {
                return _buildErrorText('You have no meals logged');
              }
              if (snapshot.data!.isEmpty) {
                return _buildErrorText('You have no meals logged');
              }
              // Group items by date
              final Map<DateTime, List<ConsumedMeal>> groupedMeals =
                  _groupMeals(
                snapshot.data!,
                activeNavItem,
              );
              // Build list of card based on the grouped meals
              return _buildList(groupedMeals);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorText(String msg) {
    return SizedBox(
      height: 48.0,
      child: Center(
        child: Text(msg),
      ),
    );
  }

  Widget _buildList(Map<DateTime, List<ConsumedMeal>> groupedMeals) {
    return Expanded(
      child: ListView(
        children: <Widget>[
          ...groupedMeals.values.map(
            (meals) => Column(
              children: [
                spacing,
                ClickableCard(
                  onPressed: () =>
                      _showLogItemDetails(meals, _getCardDate(meals[0].time)),
                  child: StatCard(
                    date: _getCardDate(meals[0].time),
                    calories: meals
                        .map((consumedMeal) => consumedMeal.calories)
                        .reduce((value, element) => value + element),
                    proteins: meals
                        .map((consumedMeal) => consumedMeal.proteins)
                        .reduce((value, element) => value + element),
                    fat: meals
                        .map((consumedMeal) => consumedMeal.fat)
                        .reduce((value, element) => value + element),
                    carbs: meals
                        .map((consumedMeal) => consumedMeal.carbs)
                        .reduce((value, element) => value + element),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _showLogItemDetails(List<ConsumedMeal> meals, String time) {
    Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          child: LogDetails(
            meals: meals,
            time: time,
          ),
        ));
  }

  /// Returns a nav widget
  Widget _buildNav() {
    return CustomCard(
      content: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: <Widget>[
            _navItem(
              label: 'Daily',
              onPress: () => _handleNavSelect(NavItem.daily),
              active: activeNavItem == NavItem.daily,
            ),
            _navItem(
              label: 'Weekly',
              onPress: () => _handleNavSelect(NavItem.weekly),
              active: activeNavItem == NavItem.weekly,
            ),
            _navItem(
              label: 'Monthly',
              onPress: () => _handleNavSelect(NavItem.monthly),
              active: activeNavItem == NavItem.monthly,
            ),
            _navItem(
              label: 'Yearly',
              onPress: () => _handleNavSelect(NavItem.yearly),
              active: activeNavItem == NavItem.yearly,
            ),
          ],
        ),
      ),
      size: 50,
      padded: false,
    );
  }

  /// Returns a nav item
  ///
  /// [label] the label displayed in the item
  /// [onPress] the callback function called when the item is pressed
  /// [active] a boolean describing if the item is currently active or
  /// not. Active items has a change in style
  Widget _navItem(
      {required String label,
      required VoidCallback onPress,
      required bool active}) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: active ? Palette.accent[400] : Colors.transparent,
        ),
        child: TextButton(
          onPressed: onPress,
          child: Text(
            label,
            style: TextStyle(
              color: active ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
