import 'package:flutter/material.dart';
import 'package:stattrack/components/custom_bottom_bar.dart';
import 'package:stattrack/pages/log_page.dart';
import 'package:stattrack/pages/user_profile_page.dart';
import 'package:stattrack/utils/nav_button_options.dart';

class NavWrapper extends StatefulWidget {
  const NavWrapper({super.key});

  @override
  State<NavWrapper> createState() => _NavWrapperState();
}

class _NavWrapperState extends State<NavWrapper> {
  String activePage = NavButtonOptions.profile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: activePage == NavButtonOptions.profile
          ? const UserProfilePage()
          : activePage == NavButtonOptions.log
              ? const LogPage()
              : const Center(
                  child: Text("This page does not exist"),
                ),
      bottomNavigationBar:
          CustomBottomBar(onChange: (button) => _handleNavChange(button)),
    );
  }

  void _handleNavChange(String button) {
    switch (button) {
      case NavButtonOptions.profile:
        setState(() {
          activePage = NavButtonOptions.profile;
        });
        break;
      case NavButtonOptions.log:
        setState(() {
          activePage = NavButtonOptions.log;
        });
        break;
    }
  }
}
