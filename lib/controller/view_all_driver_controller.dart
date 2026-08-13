import 'dart:convert';

import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/model/user_model.dart';
import 'package:cabme_driver/service/api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../constant/constant.dart';

class ViewAllDriverController extends GetxController {
  Rx<UserModel> userModel = UserModel().obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    userModel.value = Constant.getUserData();
    await getDriverList();
    isLoading.value = false;
  }

  RxList<UserData> driverList = <UserData>[].obs;

  Future<void> getDriverList() async {
    Map<String, String> bodyParams = {
      'owner_id': userModel.value.userData!.id.toString(),
    };
    await API.handleApiRequest(request: () => http.post(Uri.parse(API.getOwnerDriver), body: jsonEncode(bodyParams), headers: API.headers), showLoader: false).then(
      (value) {
        if (value != null) {
          if (value['success'] == "failed" || value['success'] == "Failed") {
            driverList.clear();
            ShowToastDialog.showToast(value['message']);
            return null;
          } else {
            driverList.value = (value['data'] as List).map((e) => UserData.fromJson(e)).toList();
          }
        }
      },
    );
  }

  Future<void> deleteDriver(String driverId) async {
    Map<String, String> bodyParams = {
      'id_driver': driverId,
    };
    await API.handleApiRequest(request: () => http.post(Uri.parse(API.deleteOwnerDriver), body: jsonEncode(bodyParams), headers: API.headers), showLoader: false).then(
      (value) async {
        if (value != null) {
          if (value['success'] == "failed" || value['success'] == "Failed") {
            ShowToastDialog.showToast(value['message']);
            return null;
          } else {
            await getDriverList();
            ShowToastDialog.showToast(value['message']);
          }
        }
      },
    );
  }
}
