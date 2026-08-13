import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/model/user_model.dart';
import 'package:cabme_driver/service/api.dart';
import 'package:cabme_driver/utils/Preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../constant/show_toast_dialog.dart';

class EditProfileController extends GetxController {
  Rx<TextEditingController> firstNameController = TextEditingController().obs;
  Rx<TextEditingController> lastNameController = TextEditingController().obs;
  Rx<TextEditingController> phoneNumber = TextEditingController().obs;
  Rx<TextEditingController> countryCodeController = TextEditingController(text: Constant.defaultCountryCode).obs;
  Rx<TextEditingController> countryISOCodeController = TextEditingController(text: Constant.defaultCountryCode).obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;

  Rx<UserModel> userModel = UserModel().obs;

  @override
  void onInit() {
    super.onInit();
    userModel.value = Constant.getUserData();
    setData();
  }

  void setData() {
    // Set initial values from userModel
    firstNameController.value.text = userModel.value.userData!.prenom ?? '';
    lastNameController.value.text = userModel.value.userData!.nom ?? '';
    emailController.value.text = userModel.value.userData!.email ?? '';
    phoneNumber.value.text = userModel.value.userData!.phone ?? '';
    countryCodeController.value.text = userModel.value.userData!.countryCode ?? '';
    countryISOCodeController.value.text = userModel.value.userData!.countryISOCode ?? '';
    profileImage.value = userModel.value.userData!.photoPath ?? '';
  }

  Future updateUser({String? image, required String name, required String lname, required String phoneNum, required String email, String? password}) async {
    try {
      ShowToastDialog.showLoader("Please wait");

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(API.editProfile),
      );
      request.headers.addAll(API.headers);
      request.fields['nom'] = lname;
      request.fields['prenom'] = name;
      request.fields['id_user'] = Preferences.getInt(Preferences.userId).toString();
      if (Constant().hasValidUrl(profileImage.value) == false && profileImage.value.isNotEmpty) {
        request.files.add(http.MultipartFile.fromBytes('image', File(image.toString()).readAsBytesSync(), filename: File(image.toString()).path.split('/').last));
      }
      request.fields['email'] = email;
      request.fields['phone'] = phoneNum;
      request.fields['country_code'] = countryCodeController.value.text;
      request.fields['country_iso_code'] = countryISOCodeController.value.text;
      request.fields['user_type'] = "driver";
      if (password?.isNotEmpty == true && password != '') {
        request.fields['mdp'] = password!;
      }
      var res = await request.send();

      var responseData = await res.stream.toBytes();
      Map<String, dynamic> response = jsonDecode(String.fromCharCodes(responseData));

      if (res.statusCode == 200) {
        log(response.toString());
        UserModel userModelNew = UserModel.fromJson(response);
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast("Profile update successfully!");
        Preferences.setString(Preferences.user, jsonEncode(userModelNew));
        userModel.value = userModelNew;
        Get.back(result: true);
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast('Something want wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
  }

  final ImagePicker _imagePicker = ImagePicker();
  RxString profileImage = "".obs;

  Future pickFile({required ImageSource source}) async {
    try {
      XFile? image = await _imagePicker.pickImage(source: source);
      if (image == null) return;
      Get.back();
      profileImage.value = image.path;
    } on PlatformException catch (e) {
      ShowToastDialog.showToast("${"failed_to_pick".tr} : \n $e");
    }
  }

  @override
  void onClose() {
    // Dispose controllers to free up resources
    firstNameController.value.dispose();
    lastNameController.value.dispose();
    emailController.value.dispose();
    phoneNumber.value.dispose();
    countryCodeController.value.dispose();
    countryISOCodeController.value.dispose();
    super.onClose();
  }
}
