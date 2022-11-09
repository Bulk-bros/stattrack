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
  /// month or year based on the active nav item.
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
              final Map<DateTime, List<ConsumedMeal>> groupedMeals =
                  _groupMeals(
                snapshot.data!,
                activeNavItem,
              );

              return Expanded(
                child: ListView(
                  children: <Widget>[
                    ...groupedMeals.values.map((cardItem) => StatCard(
                        date: cardItem[0].time,
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
