import 'package:flutter/material.dart';

Widget buttonNavigation(BuildContext context, int position,Function() ontap, String text, double fontSize, hieght,
    wiedth, backgroundColor, textColor) {

      BorderRadiusGeometry left = const BorderRadius.only(
              topLeft: Radius.circular(8), bottomLeft: Radius.circular(8));
      BorderRadiusGeometry right = const BorderRadius.only(
              topRight: Radius.circular(8), bottomRight: Radius.circular(8));


  return GestureDetector(
    onTap: ontap,
    child: Container(
      height: hieght,
      width: wiedth,
      decoration: BoxDecoration(
          borderRadius:position==1
          ?left
          :position==2
          ?right
          :const BorderRadius.all(Radius.circular(8)),
          color: backgroundColor),
      child: Center(
          child: Text(
        text,
        style: TextStyle(
            fontFamily: "inter",
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: textColor),
      )),
    ),
  );
}


Widget buttonNavigation2(BuildContext context, int position, bool loading, Function() ontap, String text, double fontSize, hieght,
    wiedth, backgroundColor, textColor) {

      BorderRadiusGeometry left = const BorderRadius.only(
              topLeft: Radius.circular(8), bottomLeft: Radius.circular(8));
      BorderRadiusGeometry right = const BorderRadius.only(
              topRight: Radius.circular(8), bottomRight: Radius.circular(8));


  return GestureDetector(
    onTap: ontap,
    child: Container(
      height: hieght,
      width: wiedth,
      decoration: BoxDecoration(
          borderRadius:position==1
          ?left
          :position==2
          ?right
          :const BorderRadius.all(Radius.circular(8)),
          color: backgroundColor),
      child: Center(
          child: 
          loading
          ?CircularProgressIndicator(color: Colors.white,)
          :Text(
        text,
        style: TextStyle(
            fontFamily: "inter",
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: textColor),
      )),
    ),
  );
}
