import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hand_tracking/contant/MyColors.dart';
import 'package:hand_tracking/services/backend.dart';
import 'package:hand_tracking/utils/Size.dart';
import 'package:hand_tracking/widgets/comun/Button.dart';
import 'package:hand_tracking/widgets/comun/MyTextField.dart';
import 'package:hand_tracking/widgets/comun/topAppBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetPswdScreen extends StatefulWidget {
  const ResetPswdScreen({super.key});

  @override
  State<ResetPswdScreen> createState() => _ResetPswdScreenState();
}

class _ResetPswdScreenState extends State<ResetPswdScreen> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerCode = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerRePassword = TextEditingController();

  String emailErrorText = "Email is empty";
  String codeErrorText = "code is empty";
  String paswwordErrorText = "Paswword is empty";
  String rePaswwordErrorText = "rePaswword is empty";

  bool emailError = false;
  bool codeError = false;
  bool isloading = false;
  bool isCodeVisible = false;
  bool isReset = false;
  bool paswwordError = false;
  bool rePaswwordError = false;

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
              topAppbar(context),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 44),
                child: Column(
                  children: [
                    resetPswdText(),
                    const SizedBox(
                      height: 32,
                    ),
                    isReset
                        ? resetPasswordFields()
                        : sendCodeVerification()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));
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
    int response;

    return buttonNavigation2(context, 0, isloading, () async {
      //=> Navigator.pop(context)
      _controllerCode.text = "";

      isCodeVisible = false;
      codeError =false;
      if (verifEmail()) {
        setState(() {
          emailError = true;
        });
      } else {
        setState(() {
          isloading = true;
          emailError = false;
        });
        log(_controllerEmail.text);
        response = await resetSendMailRequest(_controllerEmail.text);
        setState(() {
          isloading = false;
        });
        if (response == 1) {
          setState(() {
            emailErrorText = "user not found";
            emailError = true;
          });
        } else if (response == 0) {
          log("send with success");
          isCodeVisible = true;
        }
      }
    }, "RESET", 14, getHeight(context) / 15, null, MyColors.primaryColor,
        MyColors.secondarytextColor);
  }

  bool verifEmail() {
    // format email

    return _controllerEmail.text.isEmpty;
  }

  Widget verifCodeEmail() {
    return Container(
      width: getWidth(context) * 1.5,
      child: MyTextField(
          "Code", 1, textEditingController: _controllerCode, "code"),
    );
  }

  Widget verifCodeButton() {
    int response;

    return buttonNavigation2(context, 0, false, () async {
      if (_controllerCode.text.isEmpty) {
        setState(() {
          codeError = true;
        });
      } else {
        final SharedPreferences pref = await SharedPreferences.getInstance();

        response = await verifCodeRequest(
            pref.get('token_code'), _controllerCode.text);
        if (response == 0) {
          setState(() {
            codeError = false;
            isReset = true;
          });
          log("message: $response");
        } else {
          setState(() {
            codeErrorText = "code incorrect";
            codeError = true;
          });
          log("message: $response");
        }
      }
    }, "Verif code", 14, getHeight(context) / 15, null, MyColors.primaryColor,
        MyColors.secondarytextColor);
  }

  Widget sendCodeVerification() {
    return Column(
      children: [
        MyTextField(
            "email", 1, textEditingController: _controllerEmail, "email"),
        if (emailError) textErrorWidget(emailErrorText),
        const SizedBox(
          height: 32,
        ),
        if (isCodeVisible) verifCodeEmail(),
        if (isCodeVisible && codeError) textErrorWidget(codeErrorText),
        if (isCodeVisible)
          const SizedBox(
            height: 32,
          ),
        if (isCodeVisible) verifCodeButton(),
        if (isCodeVisible)
          const SizedBox(
            height: 32,
          ),
        resetPswdButton(),
      ],
    );
  }

  Widget resetPasswordFields() {
    return Column(
      children: [
        MyTextField(
            "password", 1, textEditingController: _controllerPassword, "pwd"),
        if (paswwordError) textErrorWidget(paswwordErrorText),
        const SizedBox(
          height: 16,
        ),
        MyTextField(
            "repassword",
            1,
            textEditingController: _controllerRePassword,
            "pwd"),
        if (rePaswwordError) textErrorWidget(rePaswwordErrorText),
        const SizedBox(
          height: 32,
        ),
        resetPasswordButton()
      ],
    );
  }

  Widget resetPasswordButton() {
    return buttonNavigation2(context, 0, false, () async {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      var token = pref.getString('token_code');

      int response = await resetPasswordRequest(
          token, _controllerPassword.text, _controllerRePassword.text);

      if (response == 0) {
        setState(() {
          paswwordError = false;
          rePaswwordError = false;
        });
        Navigator.pop(context);
      } else if (response == 1) {
        setState(() {
          paswwordError = true;
          paswwordErrorText = "password must be >8";
        });
      } else if (response == 2) {
        setState(() {
          paswwordError = false;
          rePaswwordError = true;
          rePaswwordErrorText = "re password incorrect";
        });
      }
    }, 'Reset', 14, getHeight(context) / 15, null, MyColors.primaryColor,
        MyColors.secondarytextColor);
  }
}
