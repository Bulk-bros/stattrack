import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stattrack/components/CustomAppBar.dart';
import 'package:stattrack/components/stats/StatCard.dart';
import 'package:stattrack/models/consumed_meal.dart';
import 'package:stattrack/providers/auth_provider.dart';
import 'package:stattrack/providers/repository_provider.dart';
import 'package:stattrack/services/auth.dart';
import 'package:stattrack/services/firestore_repository.dart';
import 'package:stattrack/services/repository.dart';
import 'package:stattrack/styles/palette.dart';

enum NavItem { daily, weekly, monthly, yearly }

final List<num> dayOfMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
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

  /// Converts a list of [ConsumedMeal]'s to a map group by day, week,
  /// month or year based on the active nav item that is sorted by time
  ///
  /// [meals] list of meals to convert
  /// [activeNavItem] the active nav item determining the grouping
  /// (day, week, month or year)
  List<List<ConsumedMeal>> _groupMeals(
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

    // Sort list by time
    // TODO: sort based on selected trunc. Should probably be extracted to a separate function
    List<List<ConsumedMeal>>? sortedMeals = groupedMeals.values.toList();
    sortedMeals = _sortMeals(sortedMeals, activeNavItem);

    return sortedMeals;
  }

  /// Sorts a list of truncated meals based on the active nav item
  /// (e.g. if daily is selected, sort based on date. If weekly is selected,
  /// sort based on week and year. If monthly is selected, sort based on month and year)
  List<List<ConsumedMeal>>? _sortMeals(
      List<List<ConsumedMeal>> meals, NavItem activeNavItem) {
    // TODO: Implement method...
    return null;
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
        return "Week ${_getWeekNumber(date)} ${date.year}";
      case NavItem.monthly:
        return "${month[date.month - 1]} ${date.year}";
      case NavItem.yearly:
        return "${date.year}";
    }
  }

  /// Returns the week number for a given date
  ///
  /// [date] the date to get the week number for
  num _getWeekNumber(DateTime date) {
    final month = date.month;
    final day = date.day;

    num numberOfDays = 0;
    for (var i = 0; i < month - 1; i++) {
      numberOfDays += dayOfMonth[i];
    }

    numberOfDays += day;

    return (numberOfDays / 7).ceil();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        headerTitle: 'Log',
        navButton: IconButton(
          // TODO: Nav back one page
          onPressed: () => print('going back'),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
        ),
        actions: [
          IconButton(
            // TODO: Nav to stats page
            onPressed: () => print('stats'),
            icon: const Icon(
              Icons.bar_chart,
            ),
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
          StreamBuilder<List<ConsumedMeal>>(
            stream: repo.getLog(uid),
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
                return const Text("You have no meals logged");
              }

              // Group items by date
              final List<List<ConsumedMeal>> groupedMeals = _groupMeals(
                snapshot.data!,
                activeNavItem,
              );

              return Expanded(
                child: ListView(
                  children: <Widget>[
                    ...groupedMeals.map((cardItem) => StatCard(
                        date: _getCardDate(cardItem[0].time),
                        calories: cardItem
                            .map((consumedMeal) => consumedMeal.calories)
                            .reduce((value, element) => value + element),
                        proteins: cardItem
                            .map((consumedMeal) => consumedMeal.proteins)
                            .reduce((value, element) => value + element),
                        fat: cardItem
                            .map((consumedMeal) => consumedMeal.fat)
                            .reduce((value, element) => value + element),
                        carbs: cardItem
                            .map((consumedMeal) => consumedMeal.carbs)
                            .reduce((value, element) => value + element),
                        onPress: () => print(
                            'Pressed card with date: ${cardItem[0].time}')))
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  /// Returns a nav widget
  Widget _buildNav() {
    return Material(
      color: Colors.white,
      elevation: 1.5,
      borderRadius: const BorderRadius.all(Radius.circular(5.0)),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _navItem(
              'Daily',
              () => _handleNavSelect(NavItem.daily),
              activeNavItem == NavItem.daily,
            ),
            _navItem(
              'Weekly',
              () => _handleNavSelect(NavItem.weekly),
              activeNavItem == NavItem.weekly,
            ),
            _navItem(
              'Monthly',
              () => _handleNavSelect(NavItem.monthly),
              activeNavItem == NavItem.monthly,
            ),
            _navItem(
              'Yearly',
              () => _handleNavSelect(NavItem.yearly),
              activeNavItem == NavItem.yearly,
            ),
          ],
        ),
      ),
    );
  }

  /// Returns a nav item
  ///
  /// [label] the label displayed in the item
  /// [callback] the callback function called when the item is pressed
  /// [active] a boolean describing if the item is currently active or
  /// not. Active items has a change in style
  Widget _navItem(String label, VoidCallback callback, bool active) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: active ? Palette.accent[400] : Colors.transparent,
      ),
      child: SizedBox(
        height: 40.0,
        child: TextButton(
          onPressed: callback,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              label,
              style: TextStyle(
                color: active ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
