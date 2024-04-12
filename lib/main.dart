import 'package:flutter/material.dart';

import 'package:hand_tracking/screen/WelcomeScreen.dart';
import 'package:hand_tracking/contant/MyColors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Start());
}

class Start extends StatelessWidget {
  const Start({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: MyColors.backgroundColor),
      home: const WelcomeScreen(),
    );
  }
}
