import 'dart:convert';

import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/model/get_vehicle_data_model.dart';
import 'package:cabme_driver/model/user_model.dart';
import 'package:cabme_driver/model/zone_model.dart';
import 'package:cabme_driver/service/api.dart';
import 'package:cabme_driver/utils/Preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AddDriverController extends GetxController {
  RxBool isLoading = true.obs;

  Rx<TextEditingController> firstNameController = TextEditingController().obs;
  Rx<TextEditingController> lastNameController = TextEditingController().obs;
  Rx<TextEditingController> phoneNumber = TextEditingController().obs;
  Rx<TextEditingController> countryCodeController = TextEditingController(text: Constant.defaultCountryCode).obs;
  Rx<TextEditingController> countryISOCodeController = TextEditingController(text: Constant.defaultCountryCode).obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  Rx<TextEditingController> conformPasswordController = TextEditingController().obs;
  Rx<TextEditingController> zoneNameController = TextEditingController().obs;
  RxList<ZoneData> selectedZone = <ZoneData>[].obs;
  RxList<ZoneData> zoneList = <ZoneData>[].obs;
  RxList<dynamic> selectedService = <dynamic>[].obs;
  RxBool isPasswordShow = true.obs;
  RxBool isConformPasswordShow = true.obs;
  RxList<VehicleData> vehicleList = <VehicleData>[].obs;
  Rx<VehicleData> selectedVehicle = VehicleData().obs;

  @override
  void onInit() {
    getArguments();
    // TODO: implement onInit
    super.onInit();
  }

  Rx<UserData> driverModel = UserData().obs;
  Rx<UserModel> ownerModel = UserModel().obs;

  Future<void> getArguments() async {
    ownerModel.value = Constant.getUserData();
    await getZoneList();
    var args = Get.arguments;
    if (args != null) {
      driverModel.value = args["driverModel"];
      firstNameController.value.text = driverModel.value.prenom ?? "";
      lastNameController.value.text = driverModel.value.nom ?? "";
      phoneNumber.value.text = driverModel.value.phone ?? "";
      emailController.value.text = driverModel.value.email ?? "";
      countryCodeController.value.text = driverModel.value.countryCode ?? "";
      countryISOCodeController.value.text = driverModel.value.countryISOCode ?? "";
      selectedZone.value = zoneList.where((zone) => driverModel.value.zoneId!.contains(zone.id.toString())).toList();
      selectedService.value = ownerModel.value.userData!.serviceType!.where((service) => driverModel.value.serviceType!.contains(service.toString())).toList();

      if (driverModel.value.vehicleId != null) {
        selectedVehicle.value =
            vehicleList.where((service) => driverModel.value.vehicleId! == service.id).isNotEmpty ? vehicleList.firstWhere((service) => driverModel.value.vehicleId! == service.id) : VehicleData();
      }
    }
    isLoading.value = false;
  }

  Future<void> saveDetails() async {
    Map<String, String> bodyParams = {
      'id_driver': Get.arguments == null ? "" : driverModel.value.id.toString(),
      'firstname': firstNameController.value.text.trim().toString(),
      'lastname': lastNameController.value.text.trim().toString(),
      'phone': phoneNumber.value.text.trim(),
      'country_code': countryCodeController.value.text.trim(),
      'country_iso_code': countryISOCodeController.value.text.trim(),
      'email': emailController.value.text.trim(),
      'password': passwordController.value.text,
      'owner_id': Preferences.getInt(Preferences.userId).toString(),
      'zoneIds': selectedZone.map((zone) => zone.id.toString()).join(','),
      'service_type': selectedService.join(","), // driver or customer or owner
      'vehicleId': selectedVehicle.value.id == null ? '' : selectedVehicle.value.id.toString(),
    };

    print("Body Params: $bodyParams");

    await API.handleApiRequest(request: () => http.post(Uri.parse(API.createOwnerDriver), body: jsonEncode(bodyParams), headers: API.headers), showLoader: true).then(
      (value) {
        if (value != null) {
          if (value['success'] == "failed" || value['success'] == "Failed") {
            ShowToastDialog.showToast(value['message']);
            return null;
          } else {
            Get.back(result: true);
            ShowToastDialog.showToast(driverModel.value.id == null ? "Driver information added successfully" : "Driver information updated successfully");
          }
        }
      },
    );
  }

  Future<void> getZoneList() async {
    await API.handleApiRequest(request: () => http.get(Uri.parse(API.getZone), headers: API.headers), showLoader: false).then(
      (value) {
        if (value != null) {
          if (value['success'] == "failed" || value['success'] == "Failed") {
            ShowToastDialog.showToast(value['message']);
            return null;
          } else {
            ZoneModel zoneModel = ZoneModel.fromJson(value);
            zoneList.value = zoneModel.data ?? [];
          }
        }
      },
    );

    Map<String, String> bodyParams = {
      'owner_id': ownerModel.value.userData!.id.toString(),
    };

    await API.handleApiRequest(request: () => http.post(Uri.parse(API.getOwnerVehicle), body: jsonEncode(bodyParams), headers: API.headers), showLoader: false).then(
      (value) {
        if (value != null) {
          if (value['success'] == "failed" || value['success'] == "Failed") {
            return null;
          } else {
            vehicleList.value = (value['data'] as List).map((e) => VehicleData.fromJson(e)).toList();
          }
        }
      },
    );
  }
}
