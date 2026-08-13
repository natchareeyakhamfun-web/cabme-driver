import 'dart:convert';

import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/model/bank_details_model.dart';
import 'package:cabme_driver/model/user_model.dart';
import 'package:cabme_driver/service/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class BankDetailsAddController extends GetxController{
  Rx<TextEditingController> bankNameController = TextEditingController().obs;
  Rx<TextEditingController> branchController = TextEditingController().obs;
  Rx<TextEditingController> holderNameController = TextEditingController().obs;
  Rx<TextEditingController> accountNumberController = TextEditingController().obs;
  Rx<TextEditingController> ifcsCodeController = TextEditingController().obs;
  Rx<TextEditingController> informationController = TextEditingController().obs;
  Rx<UserModel> userModel = UserModel().obs;


  Rx<BankDetailsModel> bankDetailsModel = BankDetailsModel().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getBankDetails();
    super.onInit();
  }

  Future<void> getBankDetails() async {
    userModel.value = Constant.getUserData();
    Map<String, String> bodyParams = {
      'id_driver': userModel.value.userData!.id.toString(),
    };
    await API
        .handleApiRequest(
        request: () => http.post(Uri.parse(API.bankDetails), headers: API.headers, body: jsonEncode(bodyParams)), showLoader: false)
        .then(
          (value) {
        if (value != null) {
          if (value['success'] == "success" || value['success'] == "Success") {
            bankDetailsModel.value = BankDetailsModel.fromJson(value);
            if (bankDetailsModel.value.data != null) {
              bankNameController.value.text = bankDetailsModel.value.data!.bankName ?? '';
              branchController.value.text = bankDetailsModel.value.data!.branchName ?? '';
              holderNameController.value.text = bankDetailsModel.value.data!.holderName ?? '';
              accountNumberController.value.text = bankDetailsModel.value.data!.accountNo ?? '';
              informationController.value.text = bankDetailsModel.value.data!.otherInfo ?? '';
              ifcsCodeController.value.text = bankDetailsModel.value.data!.ifscCode ?? '';
            }
          }
        }
      },
    );
  }


  Future<void> submitBankDetails() async {
    userModel.value = Constant.getUserData();
    Map<String, String> bodyParams = {
      'id_driver': userModel.value.userData!.id.toString(),
      'bank_name': bankNameController.value.text,
      'branch_name': branchController.value.text,
      'holder_name': holderNameController.value.text,
      'account_no': accountNumberController.value.text,
      'information': informationController.value.text,
      'ifsc_code': ifcsCodeController.value.text,
    };
    await API
        .handleApiRequest(
        request: () => http.post(Uri.parse(API.addBankDetails), headers: API.headers, body: jsonEncode(bodyParams)), showLoader: false)
        .then(
          (value) async {
        if (value != null) {
          if (value['success'] == "success" || value['success'] == "Success") {
            await getBankDetails();
            ShowToastDialog.showToast("Bank Details added successfully");
            Get.back();
          } else {
            ShowToastDialog.showToast(value['message'] ?? "Something went wrong");
          }
        }
      },
    );
  }


}