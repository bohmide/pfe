import 'package:flutter/material.dart';
import 'package:hand_tracking/utils/Size.dart';

Widget topAppbar(context) {
    return SizedBox(
      height: 64,
      width: getWidth(context),
      child: Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios))),
    );
  }