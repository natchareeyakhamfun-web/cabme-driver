import 'dart:convert';

import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/model/user_model.dart';
import 'package:cabme_driver/service/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ChangePasswordController extends GetxController {
  Rx<TextEditingController> currentPasswordController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  Rx<TextEditingController> conformPasswordController = TextEditingController().obs;

  RxBool isPasswordShow = true.obs;
  RxBool isConformPasswordShow = true.obs;
  RxBool isCurrentPasswordShow = true.obs;
  Rx<UserModel> myProfile = UserModel().obs;

  @override
  void onInit() {
    // TODO: implement onInit

    myProfile.value =Constant.getUserData();
    super.onInit();
  }

  Future changePassword() async {
    Map<String, dynamic> bodyParams = {
      "anc_mdp": currentPasswordController.value.text,
      "new_mdp": passwordController.value.text,
      "user_cat": myProfile.value.userData!.userCat,
      "id_user": myProfile.value.userData!.id.toString(),
    };
    await API.handleApiRequest(request: () => http.post(Uri.parse(API.changePassword), headers: API.headers, body: jsonEncode(bodyParams)), showLoader: true).then(
      (value) {
        if (value != null) {
          if(value['success'] == "success" || value['success'] == "Success" ){
            ShowToastDialog.showToast("Password Updated!!");
          }else{
            ShowToastDialog.showToast(value['error'] ?? "Something want wrong");
          }
        }
      },
    );
  }
}
