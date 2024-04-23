// ignore_for_file: file_names

import 'package:flutter/material.dart';

import 'package:hand_tracking/contant/MyColors.dart';
import 'package:hand_tracking/screen/SignInScreen.dart';
import 'package:hand_tracking/screen/SignUpScreen.dart';
import 'package:hand_tracking/utils/Size.dart';
import 'package:hand_tracking/widgets/comun/Button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            box(context),
            const SizedBox(height: 128),
            welcomText(context),
            const SizedBox(height: 64),
            buttonNavig(context)
          ],
        ),
      ),
    ));
  }

  Widget box(context) {
    return Container(
      height: getHeight(context) * 0.4,
      width: double.infinity,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          color: MyColors.primaryColor),
      child: Image.asset("assets/avatar/peace.png"),
    );
  }

  Widget welcomText(constext) {
    return const Text(
      "Welcome to our App",
      style: TextStyle(
          fontFamily: "inter",
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: MyColors.primarytextColor),
    );
  }

  Widget buttonNavig(context) {
    double hieghtButton = getHeight(context) / 15;
    double wiedthButton = getWidth(context) / 3;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buttonNavigation(context, 1, () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SignUpScreen()));
        }, 'SIGN UP', 14, hieghtButton, wiedthButton, MyColors.primaryColor,
            MyColors.secondarytextColor),
        buttonNavigation(context, 2, () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SignInScreen()));
        },
            'LOGIN',
            14,
            hieghtButton,
            wiedthButton,
            const Color.fromARGB(255, 230, 230, 230),
            MyColors.primarytextColor),
      ],
    );
  }
}
