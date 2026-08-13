import 'dart:convert';

import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/model/get_vehicle_data_model.dart';
import 'package:cabme_driver/model/owner_dashboard_model.dart';
import 'package:cabme_driver/model/user_model.dart';
import 'package:cabme_driver/service/api.dart';
import 'package:cabme_driver/utils/Preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class OwnerHomeController extends GetxController {
  RxBool isLoading = true.obs;

  Rx<UserModel> userModel = UserModel().obs;
  Rx<OwnerDashBoardData> ownerDashBoardData = OwnerDashBoardData().obs;

  final LayerLink layerLink = LayerLink();
  GlobalKey overlayKey = GlobalKey();
  final List<String> types = [
    'Add Driver',
    'Add Vehicle',
  ];

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    userModel.value = Constant.getUserData();
    await getUserData();
    await getDriverList();
    isLoading.value = false;
  }

  Future<void> getUserData() async {
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
            return null;
          } else {
            userModel.value = UserModel.fromJson(value);
            Preferences.setString(Preferences.user, jsonEncode(value));
          }
        }
      },
    );
  }

  RxList<UserData> driverList = <UserData>[].obs;
  RxList<VehicleData> vehicleList = <VehicleData>[].obs;

  Future<void> getDriverList() async {
    Map<String, String> bodyParams = {
      'owner_id': userModel.value.userData!.id.toString(),
    };
    await API.handleApiRequest(request: () => http.post(Uri.parse(API.getOwnerDashboard), body: jsonEncode(bodyParams), headers: API.headers), showLoader: false).then(
      (value) {
        if (value != null) {
          if (value['success'] == "failed" || value['success'] == "Failed") {
            return null;
          } else {
            ownerDashBoardData.value = OwnerDashBoardData.fromJson(value['data']);
          }
        }
      },
    );
    await API.handleApiRequest(request: () => http.post(Uri.parse(API.getOwnerDriver), body: jsonEncode(bodyParams), headers: API.headers), showLoader: false).then(
      (value) {
        if (value != null) {
          if (value['success'] == "failed" || value['success'] == "Failed") {
            driverList.clear();
            return null;
          } else {
            driverList.value = (value['data'] as List).map((e) => UserData.fromJson(e)).toList();
          }
        }
      },
    );

    await API.handleApiRequest(request: () => http.post(Uri.parse(API.getOwnerVehicle), body: jsonEncode(bodyParams), headers: API.headers), showLoader: false).then(
      (value) {
        if (value != null) {
          if (value['success'] == "failed" || value['success'] == "Failed") {
            vehicleList.clear();
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

  Future<void> deleteDriver(String driverId) async {
    Map<String, String> bodyParams = {
      'id_driver': driverId,
    };
    await API.handleApiRequest(request: () => http.post(Uri.parse(API.deleteOwnerDriver), body: jsonEncode(bodyParams), headers: API.headers), showLoader: true).then(
      (value) async {
        if (value != null) {
          if (value['success'] == "failed" || value['success'] == "Failed") {
            driverList.clear();
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
