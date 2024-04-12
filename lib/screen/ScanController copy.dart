import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'dart:developer';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

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
    initTFLite();
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
              objectDetector(image);
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

  // Modify objectDetector method to resize the input image to 100x100
  void objectDetector(CameraImage cameraImage) async {
    if (!_isProces) {
      _isProces = true;

      // Convert YUV420 image to RGB
      img.Image convertedImage = convertCameraImage(cameraImage);

      // Resize the image to 100x100
      img.Image resizedImage =
          img.copyResize(convertedImage, width: 100, height: 100);

      // Convert the resized image to bytes
      Uint8List resizedBytes = resizedImage.getBytes();

      // Run model on resized image
      var object = await Tflite.runModelOnBinary(
        binary: resizedBytes,
        asynch: true,
        numResults: 1,
        threshold: 0.4,
      ).onError((error, stackTrace) {
        log(error.toString());
        return null;
      });

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

// Helper method to convert CameraImage to RGB Image
  img.Image convertCameraImage(CameraImage cameraImage) {
    img.Image convertedImage = img.Image(cameraImage.width, cameraImage.height);

    for (int x = 0; x < cameraImage.width; x++) {
      for (int y = 0; y < cameraImage.height; y++) {
        int pixelIndex = y * cameraImage.width + x;
        int yValue = cameraImage.planes[0].bytes[pixelIndex];
        int uValue = cameraImage.planes[1].bytes[pixelIndex];
        int vValue = cameraImage.planes[2].bytes[pixelIndex];

        int r = (yValue + 1.402 * (vValue - 128)).round().clamp(0, 255);
        int g = (yValue - 0.344136 * (uValue - 128) - 0.714136 * (vValue - 128))
            .round()
            .clamp(0, 255);
        int b = (yValue + 1.772 * (uValue - 128)).round().clamp(0, 255);

        convertedImage.setPixel(x, y, img.getColor(r, g, b));
      }
    }

    return convertedImage;
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}
