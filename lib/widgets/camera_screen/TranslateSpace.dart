// ignore_for_file: file_names

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_tts/flutter_tts.dart';
import 'package:hand_tracking/contant/MyColors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hand_tracking/utils/Size.dart';

class TranslateSpace extends StatefulWidget {
  const TranslateSpace({super.key});

  @override
  State<TranslateSpace> createState() => _TranslateSpaceState();
}

class _TranslateSpaceState extends State<TranslateSpace> {
  List<String> messages = [
    "Ahmed",
    "Bousnina",
    "Ahmedbousnina",
    "Ahmedbousnina",
    "Ahmedbousnina",
    "Ahmedbousnina",
    ""
  ];

  /*Future<void> _speak(String text) async {
  try {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  } catch (e) {
    log("Error while speaking: $e");
  }
}*/

  /*FlutterTts _flutterTts = FlutterTts();

  List<Map> _voices = [];
  Map? _currentVoice;

  int? _currentWordStart, _currentWordEnd;

  @override
  void initState() {
    super.initState();
    initTTS();
  }

  void initTTS() {
    _flutterTts.setProgressHandler((text, start, end, word) {
      setState(() {
        _currentWordStart = start;
        _currentWordEnd = end;
      });
    });
    _flutterTts.getVoices.then((data) {
      try {
        List<Map> voices = List<Map>.from(data);
        setState(() {
          _voices =
              voices.where((voice) => voice["name"].contains("en")).toList();
          _currentVoice = _voices.first;
          setVoice(_currentVoice!);
        });
      } catch (e) {
        log(e);
      }
    });
  }

  void setVoice(Map voice) {
    _flutterTts.setVoice({"name": voice["name"], "locale": voice["locale"]});
  }
*/

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
          constraints: BoxConstraints(maxHeight: getHeight(context) * 0.3),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          width: getWidth(context),
          decoration: BoxDecoration(
              color: MyColors.spacesBackground,
              borderRadius: const BorderRadius.all(Radius.circular(8))),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                messages.length * 2 - 1,
                (index) {
                  if (index.isEven) {
                    return textSpace(context, messages[index ~/ 2]);
                  } else {
                    return const SizedBox(
                      height: 8,
                    );
                  }
                },
              ),
            ),
          )),
    );
  }

  Widget textSpace(context, String message) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: MyColors.secondaryColor.withOpacity(0.8),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            message,
            style: const TextStyle(
                fontFamily: "inter",
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontSize: 14,
                decoration: TextDecoration.none),
            overflow: TextOverflow.clip,
          ),
          /*Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(0.0),
                  width: 30,
                  height: 30,
                  child: PopupMenuButton(
                    padding: EdgeInsets.zero,
                    itemBuilder: (ctx) => [
                      _buildPopupMenuItem(
                          'Search', CupertinoIcons.search, message),
                      _buildPopupMenuItem('traduit', Icons.translate, message),
                      _buildPopupMenuItem('Copy', Icons.copy, message),
                    ],
                  ),
                ),
                Container(
                    padding: const EdgeInsets.all(0.0),
                    width: 30,
                    height: 30,
                    child: IconButton(
                        color: Colors.black,
                        padding: EdgeInsets.zero,
                        onPressed: () async {
                        },
                        icon: const Icon(Icons.volume_up))),
              ],
            ),
          )*/
        ],
      ),
    );
  }

  void _launchGoogleSearch() async {
    String query = 'facebook';
    String url = 'https://www.google.com/search?q=$query';

    log("lunch ...");
    // Check if the Google app is installed, if not, launch the browser
    if (await canLaunchUrl(Uri.parse('google://'))) {
      await launch('google://www.google.com/search?q=$query');
    } else if (await canLaunchUrl(Uri.parse(url))) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  PopupMenuItem _buildPopupMenuItem(
      String title, IconData iconData, String message) {
    return PopupMenuItem(
      child: Row(
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () async {
              _launchGoogleSearch();
            },
            icon: Icon(iconData),
            color: Colors.black,
          ),
          Text(title),
        ],
      ),
    );
  }
}
