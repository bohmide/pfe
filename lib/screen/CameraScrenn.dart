import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:hand_tracking/contant/MyColors.dart';
import 'package:hand_tracking/controller/CameraControler.dart';
import 'package:hand_tracking/utils/Size.dart';
import 'package:hand_tracking/widgets/camera_screen/AvatarSpace.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver{
  bool _isTheRearCameraSelected = true;
  bool _isFlashOn = false;
  bool _isLive = false;
  late CameraControler cameraController;


  List<String> listObject = [""];
  List<String> messages = [
    "O",
    "V",
    "I",
    "C",
    "B",
    "Space",
    "A"

  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      cameraController.initCamera(_isTheRearCameraSelected ? 0 : 1);

    }

  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(
      children: [
        SizedBox(
          width: getWidth(context),
          height: getHeight(context),
          child: GetBuilder<CameraControler>(
            init: CameraControler(),
            builder: (controller) {
              cameraController = controller;
              log(("size : ${controller.thelist.length}"));
              
              return controller.isCameraInitialized.value
                  ? Stack(
                      children: [
                        SizedBox(
            
                          child: CameraPreview(controller.cameraController)),
                        translateSpace(controller.thelist)
                      ],
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    );
            },
          ),
        ),
        itemOnPage(context)
      ],
    ));
  }

  Widget itemOnPage(context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
      child: Stack(
        children: [optionSpace(), const AvatarSpace()],
      ),
    );
  }

  Widget optionSpace() {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        decoration: BoxDecoration(
            color: MyColors.spacesBackground,
            borderRadius: const BorderRadius.all(Radius.circular(25))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /*GestureDetector(
                onTap: () {
                  setState(() {
                    _isLive = !_isLive;
                    cameraController.islive = _isLive;
                  });
                },
                child: Container(
                  height: 32,
                  width: 32,
                  child:_isLive
                  ? Image.asset("assets/images/live.png", color: Colors.white,)
                  : Image.asset("assets/images/no_live.png", color: Colors.white,)
                  ),  
              ),*/

            IconButton(
                color: MyColors.primaryIconColor,
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  setState(() {
                    _isTheRearCameraSelected = !_isTheRearCameraSelected;
                    cameraController
                        .initCamera(_isTheRearCameraSelected ? 0 : 1);
                  });
                },
                icon: const Icon(Icons.replay)),
            if (_isTheRearCameraSelected)
              IconButton(
                  color: MyColors.primaryIconColor,
                  padding: const EdgeInsets.all(0),
                  onPressed: () {
                    _isFlashOn = !_isFlashOn;
                    cameraController.cameraController
                        .setFlashMode(_isFlashOn? FlashMode.torch: FlashMode.off);
                  },
                  icon: const Icon(Icons.flash_on)),
          ],
        ),
      ),
    );
  }

  Widget translateSpace(List<String> pridections) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
          constraints: BoxConstraints(maxHeight: getHeight(context) * 0.3),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          width: getWidth(context),
          decoration: BoxDecoration(
              color: MyColors.spacesBackground,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25)
              )),
          child: SingleChildScrollView(
            child:Column(
              verticalDirection: VerticalDirection.up,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                messages.length,
                (index) {
                  return textSpace(context, messages[index]);
                },
              ),
              )
          )),
    );
  }

  Widget textSpace(context, String message) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      margin: const EdgeInsets.all(8),
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
        ],
      ),
    );
  }
}
