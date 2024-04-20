import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_tracking/contant/MyColors.dart';


class NetworkControler extends GetxController{

  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();

    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus (ConnectivityResult connectivityResult){

    if(connectivityResult == ConnectivityResult.none){
      Get.rawSnackbar(
        messageText: const Text("Please check your Network", style: TextStyle(fontSize: 14),),
        isDismissible: false,
        duration: const Duration(days: 1),
        backgroundColor: Colors.red,
        icon: const Icon(CupertinoIcons.wifi_slash),
        margin: EdgeInsets.zero,
        snackStyle: SnackStyle.GROUNDED
      );
    }else if(connectivityResult != ConnectivityResult.none){
      if(Get.isSnackbarOpen){
        Get.closeCurrentSnackbar();
        Get.rawSnackbar(
        messageText: const Text("you are connected", style: TextStyle(fontSize: 14),),
        isDismissible: false,
        duration: const Duration(seconds: 2),
        backgroundColor: MyColors.primaryColor,
        icon: const Icon(CupertinoIcons.wifi),
        margin: EdgeInsets.zero,
        snackStyle: SnackStyle.GROUNDED
        );
      }
    }
  }
}