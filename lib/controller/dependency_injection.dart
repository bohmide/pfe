import 'package:get/get.dart';
import 'package:hand_tracking/controller/NetworkController.dart';

class DependencyInjection{
  static void init(){
    Get.put<NetworkControler>(NetworkControler(), permanent: true);
  }
}