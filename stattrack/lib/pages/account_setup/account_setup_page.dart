import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stattrack/components/app/custom_app_bar.dart';
import 'package:stattrack/components/forms/account_setup_general_info.dart';
import 'package:stattrack/components/forms/account_setup_noob_activity.dart';
import 'package:stattrack/components/forms/account_setup_noob_estimate.dart';
import 'package:stattrack/components/forms/account_setup_noob_goal.dart';
import 'package:stattrack/components/forms/account_setup_noob_vs_pro.dart';
import 'package:stattrack/components/forms/account_setup_pro.dart';
import 'package:stattrack/models/user.dart';
import 'package:stattrack/models/weight.dart';
import 'package:stattrack/providers/auth_provider.dart';
import 'package:stattrack/providers/repository_provider.dart';
import 'package:stattrack/services/api_paths.dart';
import 'package:stattrack/services/auth.dart';
import 'package:stattrack/services/repository.dart';
import 'package:stattrack/styles/palette.dart';
import 'package:intl/intl.dart';

enum SubPages {
  generalInfo,
  proVsNoob,
  pro,
  noobActivity,
  noobGoal,
  noobEstimate,
}

class AccountSetupPage extends ConsumerStatefulWidget {
  const AccountSetupPage({Key? key}) : super(key: key);

  @override
  _AccountSetupPageState createState() => _AccountSetupPageState();
}

class _AccountSetupPageState extends ConsumerState<AccountSetupPage> {
  SubPages _activePage = SubPages.generalInfo;

  String? _name;
  DateTime? _birth;
  num? _height;
  num? _weight = 83;
  File? _profileImg;

  int? _activityLevel;
  String? _weightDirection; // Either 'lose', 'gain' or 'stay'

  num? _calories;
  num? _proteins;
  num? _carbs;
  num? _fat;

  void _signOut() {
    final AuthBase auth = ref.read(authProvider);
    auth.signOut();
  }

  void _handleNavigation() {
    switch (_activePage) {
      case SubPages.generalInfo:
        _signOut();
        break;
      case SubPages.proVsNoob:
        setState(() {
          _activePage = SubPages.generalInfo;
        });
        break;
      case SubPages.pro:
        setState(() {
          _activePage = SubPages.proVsNoob;
        });
        break;
      case SubPages.noobActivity:
        setState(() {
          _activePage = SubPages.proVsNoob;
        });
        break;
      case SubPages.noobGoal:
        setState(() {
          _activePage = SubPages.noobActivity;
        });
        break;
      case SubPages.noobEstimate:
        setState(() {
          _activePage = SubPages.noobGoal;
        });
        break;
    }
  }

  Future<void> _submit() async {
    final String uid = ref.read(authProvider).currentUser!.uid;
    final Repository repo = ref.read(repositoryProvider);

    // Convert datetime to timestamp
    final parsedBirthday = Timestamp.fromDate(_birth!);

    // Upload profile picture
    String? imageUrl;
    if (_profileImg != null) {
      imageUrl =
          await repo.uploadImage(_profileImg!, ApiPaths.profilePicture(uid));
    }

    repo.addUser(
      User(
        name: _name!,
        profilePictureUrl: imageUrl ?? '',
        birthday: parsedBirthday,
        height: _height!,
        dailyCalories: _calories!,
        dailyProteins: _proteins!,
        dailyCarbs: _carbs!,
        dailyFat: _fat!,
      ),
      Weight(
        value: _weight!,
        time: Timestamp.now(),
      ),
      uid,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        headerTitle: 'Account Setup',
        navButton: IconButton(
          onPressed: _handleNavigation,
          icon: const Icon(
            Icons.navigate_before,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: _signOut,
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Palette.accent[400],
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(31.0),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    switch (_activePage) {
      case SubPages.generalInfo:
        return AccountSetupGeneralInfo(
          onComplete: (name, birth, height, weight, image) => setState(() {
            _name = name;
            _birth = birth;
            _height = height;
            _weight = weight;
            _profileImg = image;
            _activePage = SubPages.proVsNoob;
          }),
        );
      case SubPages.proVsNoob:
        return AccountSetupNoobVsPro(
          toPro: () => setState(() {
            _activePage = SubPages.pro;
          }),
          toNoob: () => setState(() {
            _activePage = SubPages.noobActivity;
          }),
        );
      case SubPages.pro:
        return AccountSetupPro(
          onComplete: (calories, proteins, carbs, fat) async {
            setState(() {
              _calories = calories;
              _proteins = proteins;
              _carbs = carbs;
              _fat = fat;
            });
            await _submit();
          },
        );
      case SubPages.noobActivity:
        return AccountSetupNoobActivity(
          onComplete: (value) => setState(() {
            _activityLevel = value;
            _activePage = SubPages.noobGoal;
          }),
        );
      case SubPages.noobGoal:
        return AccountSetupNoobGoal(
          onComplete: (goal) => setState(() {
            _weightDirection = goal;
            _activePage = SubPages.noobEstimate;
          }),
        );
      case SubPages.noobEstimate:
        return AccountSetupNoobEstimate(
          weight: _weight!,
          activityLevel: _activityLevel!,
          weightDirection: _weightDirection!,
          onComplete: (calories, proteins, carbs, fat) async {
            setState(() {
              _calories = calories;
              _proteins = proteins;
              _carbs = carbs;
              _fat = fat;
            });
            await _submit();
          },
        );
    }
  }
}
