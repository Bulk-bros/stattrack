import 'package:flutter/material.dart';
import 'package:stattrack/components/CustomAppBar.dart';
import 'package:stattrack/styles/font_styles.dart';
import 'package:stattrack/styles/palette.dart';

class LogPage extends StatefulWidget {
  const LogPage({Key? key}) : super(key: key);

  @override
  _LogPageState createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  int activeNavItem = 0;

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: _buildBody(),
      ),
    );
  }

  /// Returns the body of the log page
  Widget _buildBody() {
    return Column(
      children: <Widget>[
        _buildNav(),
        const Text('yoyoyo'),
      ],
    );
  }

  /// Returns a nav widget
  Widget _buildNav() {
    return Material(
      color: Colors.white,
      elevation: 1.5,
      borderRadius: const BorderRadius.all(Radius.circular(5.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _navItem(
              'Daily',
              () => setState(() {
                activeNavItem = 0;
              }),
              activeNavItem == 0,
            ),
            _navItem(
              'Weekly',
              () => setState(() {
                activeNavItem = 1;
              }),
              activeNavItem == 1,
            ),
            _navItem(
              'monthly',
              () => setState(() {
                activeNavItem = 2;
              }),
              activeNavItem == 2,
            ),
            _navItem(
              'Yearly',
              () => setState(() {
                activeNavItem = 3;
              }),
              activeNavItem == 3,
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
    return TextButton(
      onPressed: callback,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: active ? Palette.accent[400] : Colors.transparent,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 20.0,
          ),
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
