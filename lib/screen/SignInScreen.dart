// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hand_tracking/screen/ResetPswdScreen.dart';
import 'package:hand_tracking/contant/MyColors.dart';
import 'package:hand_tracking/screen/CameraScrenn.dart';
import 'package:hand_tracking/screen/SignUpScreen.dart';
import 'package:hand_tracking/services/backend.dart';
import 'package:hand_tracking/utils/Size.dart';
import 'package:hand_tracking/widgets/comun/Button.dart';
import 'package:hand_tracking/widgets/comun/MyTextField.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  bool _emailError = false;
  bool _pwdError = false;

  String _emailErrorText = 'email error';
  String _pwdErrorText = 'password error';

  bool _isloadin = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            logo(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 44),
              child: Column(
                children: [
                  MyTextField("email", 0, "email",
                      textEditingController: _controllerEmail),
                  if (_emailError) textErrorWidget(_emailErrorText),
                  const SizedBox(
                    height: 14,
                  ),
                  MyTextField("password", 1, "pwd",
                      textEditingController: _controllerPassword),
                  if (_pwdError) textErrorWidget(_pwdErrorText),
                  forgotPswdText(),
                  /*const SizedBox(
                    height: 14,
                  ),*/
                  signInButton(),
                ],
              ),
            ),
            const SizedBox(
              height: 64,
            ),
            /*otherMethodeText(),
            const SizedBox(
              height: 32,
            ),
            otherMethodeButton(),*/
            const SizedBox(
              height: 64,
            ),
            signUpText(),
            SizedBox(
              height: getHeight(context) / 5,
            ),
          ],
        ),
      ),
    ));
  }

  Widget logo() {
    return SizedBox(
      height: getHeight(context) * 0.3,
      width: double.infinity,
      child: const Center(
        child: Text(
          "LOGO",
          style: TextStyle(
              fontFamily: "inter",
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: MyColors.primarytextColor),
        ),
      ),
    );
  }

  bool verif() {
    setState(() {
      if (_controllerEmail.text.isEmpty) {
        _emailError = true;
        _emailErrorText = " email empty";
      } else {
        _emailError = false;
        _emailErrorText = "";
      }

      if (_controllerPassword.text.isEmpty) {
        _pwdError = true;
        _pwdErrorText = " password empty";
      } else {
        _pwdError = false;
        _pwdErrorText = "";
      }
    });
    return _pwdError && _emailError;
  }

  Widget signInButton() {
    return buttonNavigation2(context, 0, _isloadin, () async {
      setState(() {
        _isloadin = true;
      });

      int serverStat = await checkSever();

      if (serverStat == 1) {
        setState(() {
          _isloadin = false;
        });
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: const Text("Check Server"),
                actions: [
                  buttonNavigation2(
                      context,
                      0,
                      false,
                      () => Navigator.pop(context),
                      "ok",
                      16.0,
                      32.0,
                      64.0,
                      MyColors.primaryColor,
                      Colors.white)
                ],
              );
            });
      } else {
        if (!verif()) {
          http.Response response = await loginRequest(
              _controllerEmail.text, _controllerPassword.text);

          final body = jsonDecode(response.body);

          if (response.statusCode == 200) {
            await availableCameras().then((value) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const CameraScreen()),
                  (route) => false);
            });

            setState(() {
              _isloadin = false;
            });
          } else if (response.body.contains("email")) {
            setState(() {
              _isloadin = false;
            });
            _emailErrorText = body["detail"].toString();
            _emailError = true;
          } else if (response.body.contains("password")) {
            setState(() {
              _isloadin = false;
            });
            _pwdErrorText = body["detail"].toString();
            _pwdError = true;
          } else {
            log(jsonDecode(response.body));
            setState(() {
              _isloadin = false;
            });
          }
        }else{
          setState(() {
        _isloadin = false;
      });
        }
      }
    }, "Sign In", 14, getHeight(context) / 15, null, MyColors.primaryColor,
        MyColors.secondarytextColor);
  }

  Widget otherMethodeText() {
    return const Text(
      "-Or Sign Up with-",
      style: TextStyle(color: MyColors.thirdtextColor),
    );
  }

  Widget otherMethodeButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 32,
          width: 32,
          child: SvgPicture.asset("assets/logos/Google-g_logo.svg"),
        ),
        SizedBox(width: getWidth(context) / 25),
        SizedBox(
          height: 44,
          width: 44,
          child: SvgPicture.asset("assets/logos/Facebook-f_Logo_Blue.svg"),
        ),
      ],
    );
  }

  Widget signUpText() {
    return RichText(
      text: TextSpan(style: const TextStyle(fontSize: 16), children: [
        const TextSpan(
            text: "Don't have account? ",
            style: TextStyle(color: MyColors.primarytextColor)),
        TextSpan(
          text: "create a new account",
          style: const TextStyle(color: MyColors.primaryColor),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SignUpScreen()));
            },
        ),
      ]),
    );
  }

  Widget forgotPswdText() {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 15, right: 0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ResetPswdScreen()));
          },
          child: const Text(
            "Forgot Password?",
            style: TextStyle(color: MyColors.primaryColor, fontSize: 14),
          ),
        ),
      ),
    );
  }
}
