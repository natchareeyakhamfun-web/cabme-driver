import 'dart:async';
import 'dart:convert';

import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/model/user_model.dart';
import 'package:cabme_driver/service/api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class OTPController extends GetxController {
  RxString phoneNumber = "".obs;
  RxString countryCode = "".obs;
  RxString countryISOCode = "".obs;

  Rx<TextEditingController> otpController = TextEditingController().obs;
  RxString verificationId = ''.obs;
  RxInt resendToken = 0.obs;

  @override
  void onInit() {
    super.onInit();
    otpController.value.clear();
    getArgument();
  }

  Future<void> getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      phoneNumber.value = argumentData['phoneNumber'];
      countryCode.value = argumentData['countryCode'];
      countryISOCode.value = argumentData['countryISOCode'];
      verificationId.value = argumentData['verificationId'];
      resendToken.value = argumentData['resendTokenData'];
    }
  }

  Future<void> resendOTP() async {
    await sendOTP();
    otpController.value = TextEditingController();
  }

  Future<bool> sendOTP() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: countryCode.value + phoneNumber.value,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId0, int? resendToken0) async {
        verificationId.value = verificationId0;
        resendToken.value = resendToken0!;
        ShowToastDialog.showToast("OTP sent");
      },
      timeout: const Duration(seconds: 25),
      forceResendingToken: resendToken.value,
      codeAutoRetrievalTimeout: (String verificationId0) {
        verificationId0 = verificationId.value;
      },
    );
    return true;
  }

  Future<bool?> phoneNumberIsExit(Map<String, String> bodyParams) async {
    bool? isExits;
    await API.handleApiRequest(request: () => http.post(Uri.parse(API.getExistingUserOrNot), headers: API.authheader, body: jsonEncode(bodyParams)), showLoader: true).then(
      (value) {
        if (value != null) {
          if (value['success'] == "Failed" || value['success'] == "failed") {
            ShowToastDialog.showToast(value['error']);
            return null;
          } else {
            if (value['data'] == true) {
              isExits = true;
            } else {
              isExits = false;
            }
          }
        }
      },
    );
    return isExits;
  }

  Future<UserModel?> getDataByPhoneNumber(Map<String, String> bodyParams) async {
    UserModel? userModel;
    await API.handleApiRequest(request: () => http.post(Uri.parse(API.getProfileByPhone), headers: API.headers, body: jsonEncode(bodyParams)), showLoader: true).then(
      (value) {
        if (value != null) {
          userModel = UserModel.fromJson(value);
        }
      },
    );
    return userModel;
  }
}
