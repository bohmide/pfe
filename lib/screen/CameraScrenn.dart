import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:hand_tracking/contant/MyColors.dart';
import 'package:hand_tracking/screen/ScanController.dart';
import 'package:hand_tracking/utils/Size.dart';
import 'package:hand_tracking/widgets/camera_screen/AvatarSpace.dart';
import 'package:hand_tracking/widgets/camera_screen/TranslateSpace.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool _isTheRearCameraSelected = true;
  bool _isFlashOn = false;

  List<String> listObject = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(
      children: [
        SizedBox(
          width: getWidth(context),
          height: getHeight(context),
          child: GetBuilder<ScanController>(
            init: ScanController(),
            builder: (controller) {
              if (listObject.isEmpty) {
                listObject.add(controller.label);
                log(controller.label);
              } else if (listObject[listObject.length-1] != controller.label) {
                listObject.add(controller.label);
                log("${controller.label} \n ${listObject.length}");

              }
              return controller.isCameraInitialized.value
                  ? Stack(
                      children: [
                        CameraPreview(controller.cameraController),
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
        children: [optionSpace(), const AvatarSpace(), const TranslateSpace()],
      ),
    );
  }

  Widget optionSpace() {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        decoration: BoxDecoration(
            color: MyColors.spacesBackground,
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                color: MyColors.primaryIconColor,
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  setState(() {
                    _isTheRearCameraSelected = !_isTheRearCameraSelected;
                  });
                },
                icon: const Icon(Icons.replay)),
            if (_isTheRearCameraSelected)
              IconButton(
                  color: MyColors.primaryIconColor,
                  padding: const EdgeInsets.all(0),
                  onPressed: () {
                    _isFlashOn = !_isFlashOn;
                  },
                  icon: const Icon(Icons.flash_on)),
          ],
        ),
      ),
    );
  }
}
