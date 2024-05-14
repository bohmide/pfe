import 'package:flutter/material.dart';
import 'package:hand_tracking/screen/SettingScreen.dart';
import 'package:hand_tracking/contant/MyColors.dart';

class AvatarSpace extends StatelessWidget {
  const AvatarSpace({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        height: 42,
        width: 42,
        decoration: BoxDecoration(
            color: MyColors.spacesBackground,
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: IconButton(
            color: MyColors.primaryIconColor,
            padding: const EdgeInsets.all(0),
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) => const SettingsScreen())),
           
            icon: const Icon(Icons.account_circle)),
      ),
    );
  }
}
