import 'dart:convert';

import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/model/user_model.dart';
import 'package:cabme_driver/page/auth_screens/login_screen.dart';
import 'package:cabme_driver/service/api.dart';
import 'package:cabme_driver/utils/Preferences.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_review/in_app_review.dart';

class ProfileController extends GetxController {
  RxBool isLoading = true.obs;
  Rx<UserModel> userModel = UserModel().obs;

  InAppReview inAppReview = InAppReview.instance;

  @override
  void onInit() {
    super.onInit();
    getUserData();
  }

  void getUserData() {
    isLoading.value = true;
    userModel.value = Constant.getUserData();
    getUserDataAPI();
    isLoading.value = false;
  }

  Future<void> getUserDataAPI() async {
    Map<String, String> bodyParams = {
      'phone': userModel.value.userData!.phone.toString(),
      'country_code': userModel.value.userData!.countryCode.toString(),
      'country_iso_code': userModel.value.userData!.countryISOCode.toString(),
      'user_cat': "driver",
      'email': userModel.value.userData!.email.toString(),
      'login_type': userModel.value.userData!.loginType.toString(),
    };
    await API.handleApiRequest(request: () => http.post(Uri.parse(API.getProfileByPhone), headers: API.headers, body: jsonEncode(bodyParams)), showLoader: false).then(
      (value) {
        if (value != null) {
          if (value['success'] == "Failed" || value['success'] == "failed") {
            ShowToastDialog.showToast(value['error']);
            Preferences.clearKeyData(Preferences.isLogin);
            Preferences.clearKeyData(Preferences.user);
            Preferences.clearKeyData(Preferences.userId);
            Preferences.clearKeyData(Preferences.accesstoken);
            Get.offAll(const LoginScreen());
            return null;
          } else {
            userModel.value = UserModel.fromJson(value);
            Preferences.setString(Preferences.user, jsonEncode(value));
          }
        }
      },
    );
  }

  Future<void> deleteDriver() async {
    Map<String, String> bodyParams = {
      'user_id': userModel.value.userData!.id.toString(),
      'user_cat': "driver",
    };

    print("===>$bodyParams");
    await API.handleApiRequest(request: () => http.post(Uri.parse(API.deleteUser), body: jsonEncode(bodyParams), headers: API.headers), showLoader: true).then(
      (value) async {
        if (value != null) {
          if (value['success'] == "failed" || value['success'] == "Failed") {
            return null;
          } else {
            Preferences.clearKeyData(Preferences.isLogin);
            Preferences.clearKeyData(Preferences.user);
            Preferences.clearKeyData(Preferences.userId);
            Preferences.clearKeyData(Preferences.accesstoken);
            Get.offAll(const LoginScreen());
            ShowToastDialog.showToast(value['message']);
          }
        }
      },
    );
  }

  Future<void> logout() async {
    Map<String, String> bodyParams = {
      'user_id': userModel.value.userData!.id.toString(),
      'user_cat': "driver",
    };
    await API.handleApiRequest(request: () => http.post(Uri.parse(API.logout), headers: API.headers, body: jsonEncode(bodyParams)), showLoader: true).then(
      (value) {
        if (value != null) {
          if (value['success'] == "Success" || value['success'] == "success") {
            Preferences.clearKeyData(Preferences.accesstoken);
            Preferences.clearKeyData(Preferences.isLogin);
            Preferences.clearKeyData(Preferences.user);
            Preferences.clearKeyData(Preferences.userId);
            Get.offAll(const LoginScreen());
            ShowToastDialog.showToast("Logout Successfully".tr);
          }
        }
      },
    );
  }
}
