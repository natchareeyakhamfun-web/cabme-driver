import 'dart:convert';

import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/model/get_vehicle_data_model.dart';
import 'package:cabme_driver/model/user_model.dart';
import 'package:cabme_driver/service/api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ViewAllVehicleController extends GetxController{

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


  RxBool isLoading = true.obs;
  Rx<UserModel> userModel = UserModel().obs;
  RxList<VehicleData> vehicleList = <VehicleData>[].obs;

  Future<void> getDriverList() async {
    Map<String, String> bodyParams = {
      'owner_id': userModel.value.userData!.id.toString(),
    };

    await API.handleApiRequest(request: () => http.post(Uri.parse(API.getOwnerVehicle), body: jsonEncode(bodyParams), headers: API.headers), showLoader: false).then(
          (value) {
        if (value != null) {
          if (value['success'] == "failed" || value['success'] == "Failed") {
            vehicleList.clear();
            ShowToastDialog.showToast(value['message']);
            return null;
          } else {
            vehicleList.value = (value['data'] as List).map((e) => VehicleData.fromJson(e)).toList();
          }
        }
      },
    );
  }

  Future<void> removeVehicle(String vehicleId) async {
    Map<String, String> bodyParams = {
      'vehicleId': vehicleId,
    };
    await API.handleApiRequest(request: () => http.post(Uri.parse(API.removeDriverVehicle), body: jsonEncode(bodyParams), headers: API.headers), showLoader: false).then(
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