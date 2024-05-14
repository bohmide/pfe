import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:hand_tracking/services/backend.dart';
import 'dart:developer';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

class CameraControler extends GetxController {
  //camera
  late CameraController cameraController;
  late List<CameraDescription> cameras;

  bool _isProces = false;
  bool islive = false;
  var isCameraInitialized = false.obs;

  int cameraCount = 0;
  String? responce;
  String label = "";

  List<String> thelist = [];

  @override
  void onInit() {
    super.onInit();
    //initTFLite();
    initCamera(0);
  }

  void initTFLite() async {
    log("model loading ....");
    await Tflite.loadModel(
      model: "assets/model_ML/model2.tflite",
      labels: "assets/model_ML/label2.txt",
      isAsset: true,
      numThreads: 1,
      useGpuDelegate: false,
    ).onError((error, stackTrace) {
      log("error : ${error.toString()}");
      return null;
    });
    log("model loaded");
  }

  Future initCamera(index) async {
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras();
      cameraController = CameraController(cameras[index], ResolutionPreset.max);
      try {
        log(islive.toString());
          await cameraController.initialize();
            log("start..");
            Timer.periodic(const Duration(seconds: 1), (timer) async {
            XFile image = await cameraController.takePicture();
            await sendImageToBackend(image.path).then((responce) {
              log("send");
              if(responce != null){
                if(responce == "1"){
                  log('no hand detected');
                }else{
                  thelist.add("predection: $responce");
                  update();
                }
            }else{
              log('user not found');
            }
            } );
            

            File(image.path).delete().then((_)=> log("image deleted"));
          });
          
          isCameraInitialized(true);
          update();
        
      } on CameraException catch (e) {
        log("camera error $e");
      }
    } else {
      log("Permission denief");
    }
  }

  void objectDetector(CameraImage cameraImage) async {
    log("process:  $_isProces");
    if (!_isProces) {
      _isProces = true;
      var object = await Tflite.runModelOnFrame(
              bytesList: cameraImage.planes.map((e) {
                return e.bytes;
              }).toList(),
              asynch: true,
              imageHeight: cameraImage.height,
              imageWidth: cameraImage.width,
              imageMean: 127.5,
              imageStd: 127.5,
              numResults: 1,
              rotation: 90,
              threshold: 0.4)
          .onError((error, stackTrace) {
        log(error.toString());
        return null;
      });
      //log("process 2 :  $_isProces");
      if (object != null) {
        var objectDetected = object.first;
        if (objectDetected["confidence"] * 100 > 45) {
          label = objectDetected["label"];
          log(label);
        } else {
          log(" <45 ");
        }
      } else {
        log("nothing.. ");
      }
    }
    _isProces = false;
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}
