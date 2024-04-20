import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_tracking/controller/dependency_injection.dart';
import 'package:hand_tracking/model/User.dart';
import 'package:hand_tracking/screen/CameraScrenn.dart';

import 'package:hand_tracking/screen/WelcomeScreen.dart';
import 'package:hand_tracking/contant/MyColors.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  User? user = await getUser();

  if (user == null) {
    runApp(const Start(
      widgetStart: WelcomeScreen(),
    ));
    DependencyInjection.init();
  } else {
    runApp(const Start(
      widgetStart: CameraScreen(),
    ));
    DependencyInjection.init();
  }
}

Future<User?> getUser() async {
  try {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? userDataString = pref.getString('user');
    if (userDataString != null) {
      return User.fromJson(jsonDecode(userDataString));
    }
    return null; // Return null if user data is not found
  } catch (e) {
    // Handle any errors that occur during fetching user data
    print('Error getting user data from SharedPreferences: $e');
    return null; // Return null if an error occurs
  }
}

class Start extends StatelessWidget {
  final Widget widgetStart;
  const Start({required this.widgetStart, super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: MyColors.backgroundColor),
      home: widgetStart,
    );
  }
}
