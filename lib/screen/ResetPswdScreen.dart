import 'package:flutter/material.dart';
import 'package:hand_tracking/contant/MyColors.dart';
import 'package:hand_tracking/utils/Size.dart';
import 'package:hand_tracking/widgets/comun/Button.dart';
import 'package:hand_tracking/widgets/comun/MyTextField.dart';

class ResetPswdScreen extends StatefulWidget {
  const ResetPswdScreen({super.key});

  @override
  State<ResetPswdScreen> createState() => _ResetPswdScreenState();
}

class _ResetPswdScreenState extends State<ResetPswdScreen> {
  final TextEditingController _controllerEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: getHeight(context),
          width: getWidth(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              topAppbar(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 44),
                child: Column(
                  children: [
                    resetPswdText(),
                    const SizedBox(
                      height: 32,
                    ),
                    MyTextField(
                        "email",
                        1,
                        textEditingController: _controllerEmail,
                        "email"),
                    const SizedBox(
                      height: 32,
                    ),
                    resetPswdButton(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }

  Widget topAppbar() {
    return SizedBox(
      height: 128,
      width: getWidth(context),
      child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 32, left: 32),
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                padding: const EdgeInsets.all(0),
                icon: const Icon(Icons.arrow_back_ios)),
          )),
    );
  }

  Widget resetPswdText() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Text(
        "Reset Password",
        style: TextStyle(
            fontFamily: "inter", fontSize: 32, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget resetPswdButton() {
    return buttonNavigation(
        context,
        0,
        () => Navigator.pop(context),
        "RESET",
        14,
        getHeight(context) / 15,
        null,
        MyColors.primaryColor,
        MyColors.secondarytextColor);
  }
}
