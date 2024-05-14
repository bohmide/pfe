import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:hand_tracking/model/User.dart';
import 'package:hand_tracking/screen/AboutUsScreen.dart';
import 'package:hand_tracking/screen/CameraScrenn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:hand_tracking/screen/WelcomeScreen.dart';
import 'package:hand_tracking/contant/MyColors.dart';
import 'package:hand_tracking/services/backend.dart';
import 'package:hand_tracking/utils/Size.dart';
import 'package:hand_tracking/widgets/comun/Button.dart';
import 'package:hand_tracking/widgets/comun/MyTextField.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool personalButton = false;
  bool pswdButton = false;
  bool notifButton = false;
  bool themeButton = false;

  bool _firstNameError = false;
  bool _lastNameError = false;
  bool _pwdError = false;
  bool _newPwdError = false;

  String _firstNameText = "first name error";
  String _lastNameText = "last name error";
  String _pwdText = "pwd error";
  String _newPwdText = "new pwd error";

  final TextEditingController _controllerFirstName = TextEditingController();
  final TextEditingController _controllerLastName = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerNewPassword = TextEditingController();

  late User user;

  @override
  void initState() {
    super.initState();
    initUser();
  }

  Future<void> initUser() async {
    
    User? fetchedUser = await getUser();
    if(fetchedUser == null){
      log("user null");
    }else{
      setState(() {
        user = fetchedUser;
      });
    }

  }

  Future<User?> getUser() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? dataUser = pref.getString("user");

    if(dataUser == null){
      return null;
    }else{
      return User.fromJson(jsonDecode(dataUser));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            topAppbar(context),
            avaterPec(),
            const SizedBox(
              height: 32,
            ),
            space(personalInfo(), password()),
            /*const SizedBox(
              height: 14,
            ),
            space(notifcationWidget(), themeWidget()),*/
            const SizedBox(
              height: 14,
            ),
            space(aboutus(), lougoutItem()),
          ]),
        ),
      ),
    ));
  }

  Widget topAppbar(context) {
    return SizedBox(
      height: 64,
      width: getWidth(context),
      child: Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
              onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => const 
              CameraScreen()))),
              icon: const Icon(Icons.arrow_back_ios))),
    );
  }


  Widget avaterPec() {
    return ClipOval(
      child: SizedBox.fromSize(
        size: const Size.fromRadius(80),
        child: Image.asset("assets/avatar/man_3.png"),
      ),
    );
  }

  Widget space(Widget first, Widget seconde) {
    return Container(
        padding: const EdgeInsets.only(left: 8, top: 8, bottom: 16),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Colors.white,
        ),
        child: Column(
          children: [
            first,
            seconde,
          ],
        ));
  }

  Widget iconImage(IconData? icon) {
    return Container(
      margin: const EdgeInsets.all(8),
      height: 32,
      width: 32,
      child: Icon(icon),
    );
  }

  // Personal info

  Widget personalInfo() {
    return GestureDetector(
      onTap: () {
        initUser();
        log("${user.firstName}");
        setState(() {
          personalButton = !personalButton;
          if (personalButton) {
            notifButton = false;
            pswdButton = false;
            themeButton = false;
            _controllerFirstName.text = '';
            _firstNameError = true;
            _controllerLastName.text = '';
            _lastNameError = true;
          }
        });
      },
      child: Column(
        children: [
          Row(
            children: [
              iconImage(CupertinoIcons.person),
              const Expanded(flex: 6, child: Text("Personal info")),
              Expanded(
                  flex: 1,
                  child: Icon(
                       (personalButton
                          ?  CupertinoIcons.arrow_up_circle
                          :  CupertinoIcons.arrow_down_circle)))
            ],
          ),
          if (personalButton) modifyName(),
          const Padding(
            padding: EdgeInsets.only(left: 42),
            child: Divider(
              color: MyColors.secondaryColor,
              height: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget modifyName() {
    return Padding(
      padding: const EdgeInsets.only(right: 32, left: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 32, left: 32),
            child: Column(
              children: [
                Column(
                  children: [
                    SizedBox(
                        height: 32,
                        width: getWidth(context),
                        child: MyTextField(user.firstName, 0, null,
                            textEditingController: _controllerFirstName)),
                    if (!_firstNameError) textErrorWidget(_firstNameText)
                  ],
                ),
                const SizedBox(
                  height: 14,
                ),
                Column(
                  children: [
                    SizedBox(
                        height: 32,
                        width: getWidth(context),
                        child: MyTextField(user.lastName, 1, null,
                            textEditingController: _controllerLastName)),
                    if (!_lastNameError) textErrorWidget(_lastNameText)
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 14,
          ),
          Align(
              alignment: Alignment.centerRight,
              child: buttonSubmit("OK", () async {
                if (verifName()) {
                  viewRequest();
                  int statueRequest = await changeNameRequest(
                      _controllerFirstName.text, _controllerLastName.text);
                   if(statueRequest == 0){
                    SharedPreferences pref = await SharedPreferences.getInstance();
                    String? dataUser = pref.getString('user');
                    if(dataUser == null){
                      log("User Not Found");
                    }else{
                              initUser();

                    }
                   }
                }
              }))
        ],
      ),
    );
  }

  bool verifName() {
    setState(() {
      if (_controllerFirstName.text.isEmpty) {
        _firstNameError = false;
        _firstNameText = "first name is empty";
      } else {
        _firstNameError = true;
      }
      if (_controllerLastName.text.isEmpty) {
        _lastNameError = false;
        _lastNameText = "last name is empty";
      } else {
        _lastNameError = true;
      }
    });
    return _firstNameError && _lastNameError;
  }

  // password

  bool verifPwd() {
    setState(() {
      if (_controllerPassword.text.isEmpty) {
        _pwdError = false;
        _pwdText = "password is empty";
      } else if (_controllerPassword.text.length < 8) {
        _pwdText = "password must be >8";
        _pwdError = false;
      } else {
        _pwdError = true;
      }
      if (_controllerNewPassword.text.isEmpty) {
        _newPwdError = false;
        _newPwdText = "new password is empty";
      } else if (_controllerNewPassword.text.length < 8) {
        _newPwdText = "password must be >8";
        _newPwdError = false;
      } else {
        _newPwdError = true;
      }
    });
    return _pwdError && _newPwdError;
  }

  Widget password() {
    return GestureDetector(
      onTap: () {
        setState(() {
          pswdButton = !pswdButton;
          if (pswdButton) {
            personalButton = false;
            notifButton = false;
            themeButton = false;
            _controllerPassword.text = '';
            _pwdError = true;
            _controllerNewPassword.text = '';
            _newPwdError = true;
          }
        });
      },
      child: Column(
        children: [
          Row(
            children: [
              iconImage(CupertinoIcons.lock),
              const Expanded(flex: 6, child: Text("Password")),
              Expanded(
                  flex: 1,
                  child: Icon(
                       (pswdButton
                          ?  CupertinoIcons.arrow_up_circle
                          :  CupertinoIcons.arrow_down_circle)))
            ],
          ),
          if (pswdButton) modifyPswd()
        ],
      ),
    );
  }

  Widget modifyPswd() {
    return Padding(
      padding: const EdgeInsets.only(right: 32, left: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 32, left: 32),
            child: Column(
              children: [
                Column(
                  children: [
                    SizedBox(
                        height: 32,
                        width: getWidth(context),
                        child: MyTextField("Old Password", 0, "pwd",
                            textEditingController: _controllerPassword)),
                    if (!_pwdError) textErrorWidget(_pwdText)
                  ],
                ),
                const SizedBox(
                  height: 14,
                ),
                Column(
                  children: [
                    SizedBox(
                        height: 32,
                        width: getWidth(context),
                        child: MyTextField("New Password", 1, "pwd",
                            textEditingController: _controllerNewPassword)),
                    if (!_newPwdError) textErrorWidget(_newPwdText)
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 14,
          ),
          Align(
              alignment: Alignment.centerRight,
              child: buttonSubmit("OK", () async {
                if (verifPwd()) {
                  int statueRequest =
                      await changePwdRequest(_controllerPassword.text, _controllerNewPassword.text);
                  log("with statue: ${statueRequest.toString()}");
                }
              }))
        ],
      ),
    );
  }

  // notification

  Widget notifcationWidget() {
    return GestureDetector(
      onTap: () {
        setState(() {
          notifButton = !notifButton;
          if (notifButton) {
            personalButton = false;
            pswdButton = false;
            themeButton = false;
          }
        });
      },
      child: Column(
        children: [
          Row(
            children: [
              iconImage(CupertinoIcons.bell),
              const Expanded(flex: 6, child: Text("Notiffication")),
              Expanded(
                  flex: 1,
                  child: Icon(
                       (notifButton
                          ?  CupertinoIcons.arrow_up_circle
                          :  CupertinoIcons.arrow_down_circle)))
            ],
          ),
          if (notifButton) notifParameter(),
          const Padding(
            padding: EdgeInsets.only(left: 42),
            child: Divider(
              color: MyColors.secondaryColor,
              height: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget notifParameter() {
    bool value = false;
    return Padding(
      padding: const EdgeInsets.only(left: 64, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Text("ON/OFF"),
          AdvancedSwitch(
            initialValue: value,
            onChanged: (value) => setState(() {
              value = !value;
              log(value);
            }),
          )
        ],
      ),
    );
  }

  // theme

  Widget themeWidget() {
    return GestureDetector(
      onTap: () {
        setState(() {
          themeButton = !themeButton;
          if (themeButton) {
            pswdButton = false;
            notifButton = false;
            personalButton = false;
          }
        });
      },
      child: Column(
        children: [
          Row(
            children: [
              iconImage(Icons.theater_comedy_outlined),
              const Expanded(flex: 6, child: Text("Theme")),
              Expanded(
                  flex: 1,
                  child: Icon(
                       (themeButton
                          ?  CupertinoIcons.arrow_up_circle
                          :  CupertinoIcons.arrow_down_circle)))
            ],
          ),
          if (themeButton) themeDataParameter()
        ],
      ),
    );
  }

  Widget themeDataParameter() {
    bool value = false;
    return Padding(
      padding: const EdgeInsets.only(left: 64, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Text("Mode Somber"),
          AdvancedSwitch(
            initialValue: value,
            onChanged: (value) => setState(() {
              value = !value;
              log(value);
            }),
          )
        ],
      ),
    );
  }

  // about us

  Widget aboutus() {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) =>const AboutUsScreen()));
      },
      child: Column(
        children: [
          Row(children: [
            iconImage(CupertinoIcons.info),
            const Expanded(
                flex: 6,
                child: Text(
                  "About US",
                )),
            Expanded(
                flex: 1,
                child: IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title: const Text("about us"),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("OK"))
                                ],
                              ));
                    },
                    icon: const Icon(
                      Icons.open_in_new,
                    )))
          ]),
        ],
      ),
    );
  }

  // logout

  Widget lougoutItem() {
    return GestureDetector(
      onTap: () async {
        final SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString('user', '');

        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const WelcomeScreen()),
            (route) => false);
      },
      child: Column(
        children: [
          Row(children: [
            iconImage(null),
            const Expanded(
                flex: 6,
                child: Text(
                  "Logout",
                  style: TextStyle(color: Colors.red),
                )),
            Expanded(
                flex: 1,
                child: IconButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WelcomeScreen()),
                          (route) => false);
                    },
                    icon: const Icon(
                      Icons.logout_outlined,
                      color: Colors.red,
                    )))
          ]),
        ],
      ),
    );
  }

  Widget buttonSubmit(String name, Function() actions) {
    return buttonNavigation(context, 0, actions, name, 14, 32.0, 80.0,
        MyColors.primaryColor, MyColors.secondarytextColor);
  }
}
