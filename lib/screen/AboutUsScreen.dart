import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hand_tracking/contant/MyColors.dart';
import 'package:hand_tracking/utils/Size.dart';
import 'package:hand_tracking/widgets/comun/topAppBar.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore_for_file: prefer_const_constructors
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //boxAnime(context)
            topAppbar(context),
            par()
          ],
        ),
      ),
    ));
  }

  Widget title() {
    return const Text(
      "About us",
      style: TextStyle(
          fontFamily: "inter", fontSize: 32, fontWeight: FontWeight.normal),
    );
  }

  Widget boxAnime(context) {
    return Stack(
      children: [
        Container(
          height: 256,
          width: getWidth(context),
          decoration: BoxDecoration(color: MyColors.primaryColor),
        ),
        Align(alignment: Alignment.topCenter, child: topAppbar(context)),
      ],
    );
  }

  Widget par() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 0.0, right: 16, left: 16),
      child: RichText(
        text: const TextSpan(
          text: 'About Us :\n\n',
          style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold),
          children: <TextSpan>[
            TextSpan(
                text: '   ... !!',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                )),
          ],
        ),
      ),
    );
  }
}
