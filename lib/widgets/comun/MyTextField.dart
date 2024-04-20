// ignore_for_file: must_be_immutable
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hand_tracking/contant/MyColors.dart';

class MyTextField extends StatefulWidget {
  final String? hintText;
  final String? keybordStyle;
  int inputAction = 0;
  final TextEditingController textEditingController;

  MyTextField(this.hintText, this.inputAction, this.keybordStyle,
      {required this.textEditingController, super.key});

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {

  String tt = "pwd";

  BoxDecoration containertextfieldDecoration() {
    return const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
            color: MyColors.secondaryColor,
            offset: Offset(0, 0),
            blurRadius: 10.0,
            spreadRadius: 2.0,
            blurStyle: BlurStyle.inner),
      ],
    );
  }

  InputDecoration textfieldDecoration(context, String hintText) {
    return InputDecoration(
        suffixIcon: widget.hintText!.contains("password")
        ?IconButton(
            onPressed: () {
              setState(() {
                if(tt == widget.keybordStyle){
                  tt = "show_pwd";
                }else{
                  tt = "pwd";
                }
              });
            },
            icon: Icon(
              tt == widget.keybordStyle
              ?CupertinoIcons.eye: 
              tt == "show_pwd"
              ?CupertinoIcons.eye_slash
              :null))
              : null,
        contentPadding: const EdgeInsets.only(top: 12, bottom: 12, left: 14),
        hintText: hintText,
        hintStyle: const TextStyle(fontSize: 14),
        border: InputBorder.none);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: getHeight(context) / 16,
      //width: getWidth(context) / 1.3,
      decoration: containertextfieldDecoration(),
      child: TextField(
        obscureText: tt == widget.keybordStyle,
        textInputAction: widget.inputAction == 0
            ? TextInputAction.next
            : TextInputAction.done,
        keyboardType: widget.keybordStyle == "email"
            ? TextInputType.emailAddress
            : widget.keybordStyle == "pwd"
                ? TextInputType.visiblePassword
                : TextInputType.text,
        controller: widget.textEditingController,
        decoration: textfieldDecoration(context, "${widget.hintText}"),
      ),
    );
  }
}

Widget textErrorWidget(String message) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Padding(
      padding: const EdgeInsets.only(left: 18),
      child: Text(
        message,
        style: const TextStyle(fontSize: 16, color: Colors.red),
      ),
    ),
  );
}
