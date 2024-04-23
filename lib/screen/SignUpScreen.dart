// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hand_tracking/screen/CameraScrenn.dart';
import 'package:hand_tracking/contant/MyColors.dart';
import 'package:hand_tracking/screen/SignInScreen.dart';
import 'package:hand_tracking/services/backend.dart';
import 'package:hand_tracking/utils/Size.dart';
import 'package:hand_tracking/widgets/comun/Button.dart';
import 'package:hand_tracking/widgets/comun/MyTextField.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _controllerFirstName = TextEditingController();
  final TextEditingController _controllerLastName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerVerifPassword =
      TextEditingController();

  bool _isloading = false;

  bool _firstNameError = false;
  bool _lastNameError = false;
  bool _emailError = false;
  bool _pwdError = false;
  bool _verifPwdError = false;

  String _firsNameErrorText = "firsName Error";
  String _lasNameErrorText = "_lasName Error";
  String _emailErrorText = "Email Error";
  String _pwdErrorText = "Password Error";
  String _verifPwdErrorText = "verif Password Error";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              logo(),
              const SizedBox(
                height: 32,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 44),
                child: Column(
                  children: [
                    //first name
                    MyTextField("first name", 0, null,
                        textEditingController: _controllerFirstName),
                    if (_firstNameError) textErrorWidget(_firsNameErrorText),
                    const SizedBox(
                      height: 14,
                    ),
                    //last name
                    MyTextField("last name", 0, null,
                        textEditingController: _controllerLastName),
                    if (_lastNameError) textErrorWidget(_lasNameErrorText),
                    const SizedBox(
                      height: 14,
                    ),
                    //email
                    MyTextField("email", 0, "email",
                        textEditingController: _controllerEmail),
                    if (_emailError) textErrorWidget(_emailErrorText),
                    const SizedBox(
                      height: 14,
                    ),
                    //password
                    MyTextField("password", 0, "pwd",
                        textEditingController: _controllerPassword),
                    if (_pwdError) textErrorWidget(_pwdErrorText),
                    const SizedBox(
                      height: 14,
                    ),
                    MyTextField("verif password", 1, "pwd",
                        textEditingController: _controllerVerifPassword),
                    if (_verifPwdError) textErrorWidget(_verifPwdErrorText),
                    const SizedBox(
                      height: 14,
                    ),
                    signUpButton(),
                  ],
                ),
              ),
              const SizedBox(
                height: 64,
              ),
              signInText(),
              SizedBox(
                height: getHeight(context) / 5,
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget logo() {
    return SizedBox(
      width: getWidth(context)/1.5,
      child: Padding(
        padding: const EdgeInsets.only(top:32),
        child: Center(
          child:
            SvgPicture.asset('assets/logos/logo2.svg')
        
        ),
      ),
    );
  }

  Widget signUpButton() {
    return buttonNavigation2(context, 0, _isloading, () async {

      setState(() {
        _isloading = true;
      });
      int serverStat = await checkSever();

      log("server stat : $serverStat");

      if (serverStat == 1) {

        setState(() {
        _isloading = false;
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
        if (!verifEmpty()) {
          await registerRequest(
                  _controllerFirstName.text,
                  _controllerLastName.text,
                  _controllerEmail.text,
                  _controllerPassword.text)
              .then((value) {
            if (value.statusCode == 200) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const CameraScreen()),
                  (route) => false);
            } else {
              var body = jsonDecode(value.body);
              if (body.toString().contains('email')) {
                setState(() {
                  _emailError = true;
                  _emailErrorText = body["email"]
                      .toString()
                      .substring(1, body["email"].toString().length - 2);
                });
              }
            }
          }).onError((error, stackTrace) {
            log(('Error: ${error.toString()}'));
          });
        }
      }
    }, 'Sign Up', 14, getHeight(context) / 15, null, MyColors.primaryColor,
        MyColors.secondarytextColor);
  }

  void verifpwd() {
    if (_controllerPassword.text.length < 8) {
      setState(() {
        _pwdErrorText = "password must be 8>";
        _pwdError = true;
      });
    }
  }

  void verif2pwd() {
    if (_controllerVerifPassword.text != _controllerPassword.text) {
      setState(() {
        _verifPwdErrorText = "password incorrect";
        _verifPwdError = true;
      });
    }
  }

  void verifEmail() {
    final RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!regex.hasMatch(_controllerEmail.text)) {
      setState(() {
        _emailErrorText = "bad format";
        _emailError = true;
      });
    }
  }

  bool verifEmpty() {
    setState(() {
      if (_controllerEmail.text.isEmpty) {
        _emailErrorText = "email empty";
        _emailError = true;
      } else {
        _emailErrorText = "";
        _emailError = false;
        verifEmail();
      }

      if (_controllerFirstName.text.isEmpty) {
        _firsNameErrorText = "first name empty";
        _firstNameError = true;
      } else {
        _firsNameErrorText = "";
        _firstNameError = false;
      }

      if (_controllerLastName.text.isEmpty) {
        _lasNameErrorText = "last name empty";
        _lastNameError = true;
      } else {
        _lasNameErrorText = "";
        _lastNameError = false;
      }

      if (_controllerPassword.text.isEmpty) {
        _pwdErrorText = "password empty";
        _pwdError = true;
      } else {
        _pwdErrorText = "";

        _pwdError = false;
        verifpwd();
      }

      if (_controllerVerifPassword.text.isEmpty) {
        _verifPwdErrorText = "verif password empty";
        _verifPwdError = true;
      } else {
        _verifPwdErrorText = "";
        _verifPwdError = false;
        verif2pwd();
      }
    });

    return _emailError ||
        _firstNameError ||
        _lastNameError ||
        _pwdError ||
        _verifPwdError;
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

  Widget signInText() {
    return RichText(
      text: TextSpan(style: const TextStyle(fontSize: 16), children: [
        const TextSpan(
            text: "You have an account? ",
            style: TextStyle(color: MyColors.primarytextColor)),
        TextSpan(
          text: "Sign In",
          style: const TextStyle(color: MyColors.primaryColor),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SignInScreen()));
            },
        ),
      ]),
    );
  }
}
