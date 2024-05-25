import 'package:flutter/material.dart';
import 'package:hand_tracking/screen/SettingScreen.dart';
import 'package:hand_tracking/contant/MyColors.dart';

class AvatarSpace extends StatelessWidget {
  const AvatarSpace({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: GestureDetector(
        onTap: () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const SettingsScreen())),
        child: CircleAvatar(
            radius: 25,
            backgroundColor: MyColors.spacesBackground,
            child: ClipOval(
              child: SizedBox.fromSize(
                child: Image.asset("assets/avatar/man_3.png"),
              ),
            )
            /*IconButton(
              color: MyColors.primaryIconColor,
              padding: const EdgeInsets.all(0),
              onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) => const SettingsScreen())),
             
              icon: const Icon(Icons.account_circle)),
              
               height: 50,
          width: 50,
          decoration: BoxDecoration(
              color: MyColors.spacesBackground,
              borderRadius: const BorderRadius.all(Radius.circular(10))),
              
              */
            ),
      ),
    );
  }
}
