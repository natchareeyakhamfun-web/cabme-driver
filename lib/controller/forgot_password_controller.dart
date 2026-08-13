import 'dart:async';
import 'dart:convert';

import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/service/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordController extends GetxController {
  Rx<TextEditingController> emailTextEditController = TextEditingController().obs;

  Rx<TextEditingController> otpEditingController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  Rx<TextEditingController> conformPasswordController = TextEditingController().obs;

  RxBool isPasswordShow = true.obs;
  RxBool isConformPasswordShow = true.obs;

  Future<bool?> sendEmail(Map<String, String> bodyParams) async {
    bool? isSuccess = false;
    await API.handleApiRequest(request: () => http.post(Uri.parse(API.sendResetPasswordOtp), headers: API.authheader, body: jsonEncode(bodyParams)), showLoader: true).then(
      (value) {
        if (value != null) {
          ShowToastDialog.closeLoader();
          if (value['success'] == "success") {
            ShowToastDialog.closeLoader();
            isSuccess = true;
          }
        }
      },
    );
    return isSuccess;
  }

  Future<bool?> resetPassword(Map<String, String> bodyParams) async {
    print(bodyParams);
    bool? isSuccess = false;
    ShowToastDialog.showLoader("Please wait");
    await API.handleApiRequest(request: () => http.post(Uri.parse(API.resetPasswordOtp), headers: API.authheader, body: jsonEncode(bodyParams)), showLoader: true).then(
      (value) {
        if (value != null) {
          ShowToastDialog.closeLoader();
          if (value['success'] == "success") {
            ShowToastDialog.closeLoader();
            isSuccess = true;
          }
        }
      },
    );
    return isSuccess;
  }
}
