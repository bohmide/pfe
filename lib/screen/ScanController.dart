import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'dart:developer';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

class ScanController extends GetxController {
  //camera
  late CameraController cameraController;
  late List<CameraDescription> cameras;

  bool _isProces = false;
  var isCameraInitialized = false.obs;

  int cameraCount = 0;

  String label = "";

  @override
  void onInit() {
    super.onInit();
    initCamera();
    //initTFLite();
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

  Future initCamera() async {
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras();
      cameraController = CameraController(cameras[0], ResolutionPreset.max);
      try {
        await cameraController.initialize().then((value) {
          cameraController.startImageStream((image) {
            cameraCount++;
            if (cameraCount % 10 == 0) {
              cameraCount = 0;
              //log("object...");
              //objectDetector(image);
              //log("object detected.");
            }
            update();
          });
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
    //log("process:  $_isProces");
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
