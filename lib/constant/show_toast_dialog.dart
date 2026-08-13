import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ShowToastDialog {
  static void showToast(String? message, {EasyLoadingToastPosition position = EasyLoadingToastPosition.top}) {
    EasyLoading.showToast(message!.tr, toastPosition: position);
  }

  static void showLoader(String message) {
    EasyLoading.show(
      status: message.tr,
      dismissOnTap: false,
      maskType: EasyLoadingMaskType.clear,
    );
  }

  static void showBlackLoader(String message) {
    EasyLoading.show(
      status: message.tr,
      maskType: EasyLoadingMaskType.black,
    );
  }

  static void closeLoader() {
    EasyLoading.dismiss();
  }
}
