import 'dart:convert';

import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/model/brand_model.dart';
import 'package:cabme_driver/model/get_vehicle_data_model.dart';
import 'package:cabme_driver/model/get_vehicle_getegory.dart';
import 'package:cabme_driver/model/model.dart';
import 'package:cabme_driver/model/user_model.dart';
import 'package:cabme_driver/model/zone_model.dart';
import 'package:cabme_driver/service/api.dart';
import 'package:cabme_driver/utils/Preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class VehicleInfoController extends GetxController {
  Rx<TextEditingController> colorController = TextEditingController().obs;
  Rx<TextEditingController> carMakeController = TextEditingController().obs;
  Rx<TextEditingController> millageController = TextEditingController().obs;
  Rx<TextEditingController> kmDrivenController = TextEditingController().obs;
  Rx<TextEditingController> numberPlateController = TextEditingController().obs;
  Rx<TextEditingController> zoneNameController = TextEditingController().obs;

  Rx<UserModel> userModel = UserModel().obs;

  RxList selectedZone = <int>[].obs;
  RxList<ZoneData> zoneList = <ZoneData>[].obs;
  final RxInt passenger = 1.obs; // location,preferences,payment,conformRide

  @override
  void onInit() {
    getUserdata();
    // getVehicleDataAPI();
    super.onInit();
  }

  RxBool isLoading = true.obs;

  Future<void> getUserdata() async {
    userModel.value = Constant.getUserData();
    await getVehicleCategory();
    isLoading.value = false;
  }

  Rx<VehicleData> vehicleData = VehicleData().obs;
  RxList<VehicleCategoryData> vehicleCategoryList = <VehicleCategoryData>[].obs;
  Rx<VehicleCategoryData> selectedVehicleCategory = VehicleCategoryData().obs;

  RxList<BrandData> brandList = <BrandData>[].obs;
  Rx<BrandData> selectedBrand = BrandData().obs;

  RxList<ModelData> modelList = <ModelData>[].obs;
  Rx<ModelData> selectedModel = ModelData().obs;

  Future<void> getVehicleCategory() async {
    await API
        .handleApiRequest(
            request: () => http.get(Uri.parse("${API.getVehicleData}${Preferences.getInt(Preferences.userId)}"), headers: API.headers),
            showLoader: false)
        .then(
      (value) {
        if (value != null) {
          if (value['success'] == "failed" || value['success'] == "Failed") {
            return null;
          } else {
            GetVehicleDataModel vehicleCategoryModel = GetVehicleDataModel.fromJson(value);
            vehicleData.value = vehicleCategoryModel.vehicleData!;
          }
        }
      },
    );

    await API.handleApiRequest(request: () => http.get(Uri.parse(API.vehicleCategory), headers: API.headers), showLoader: false).then(
      (value) {
        if (value != null) {
          if (value['success'] == "failed" || value['success'] == "Failed") {
            ShowToastDialog.showToast(value['message']);
            return null;
          } else {
            VehicleCategoryModel vehicleCategoryModel = VehicleCategoryModel.fromJson(value);
            vehicleCategoryList.value = vehicleCategoryModel.data ?? [];
          }
        }
      },
    );

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

    await API.handleApiRequest(request: () => http.get(Uri.parse(API.brand), headers: API.headers), showLoader: false).then(
      (value) {
        if (value != null) {
          if (value['success'] == "failed" || value['success'] == "Failed") {
            ShowToastDialog.showToast(value['message']);
            return null;
          } else {
            BrandModel brandModel = BrandModel.fromJson(value);
            brandList.value = brandModel.data ?? [];
          }
        }
      },
    );

    if (vehicleData.value.id != null) {
      selectedVehicleCategory.value = vehicleCategoryList.firstWhere((p0) => p0.id == vehicleData.value.idTypeVehicule);
      selectedBrand.value = brandList.firstWhere((p0) => p0.id == vehicleData.value.brand);
      await getModel();
      selectedModel.value = modelList.firstWhere((p0) => p0.id == vehicleData.value.model);

      colorController.value.text = vehicleData.value.color!;
      carMakeController.value.text = vehicleData.value.carMake!;
      numberPlateController.value.text = vehicleData.value.numberplate!;
      passenger.value = vehicleData.value.passenger!.isEmpty ? 1 : int.parse(vehicleData.value.passenger.toString());
      kmDrivenController.value.text = vehicleData.value.km!;
      millageController.value.text = vehicleData.value.milage!;

      for (var element in vehicleData.value.zone_id!) {
        selectedZone.add(int.parse(element.toString()));
      }
      for (var element in selectedZone) {
        if(zoneList.where((p0) => p0.id == element).isNotEmpty){
          zoneNameController.value.text =
          "${zoneNameController.value.text}${zoneNameController.value.text.isEmpty ? "" : ","} ${zoneList.where((p0) => p0.id == element).first.name}";
        }
      }
    }
  }

  Future<void> getModel() async {
    selectedModel.value = ModelData();
    Map<String, String> bodyParams = {
      'brand': selectedBrand.value.name.toString(),
      'vehicle_type': selectedVehicleCategory.value.id.toString(),
    };
    await API
        .handleApiRequest(
            request: () => http.post(Uri.parse(API.model), headers: API.headers, body: jsonEncode(bodyParams)), showLoader: true)
        .then(
      (value) {
        if (value != null) {
          if (value['success'] == "failed" || value['success'] == "Failed") {
            ShowToastDialog.showToast(value['error']);
            return null;
          } else {
            Model brandModel = Model.fromJson(value);
            modelList.value = brandModel.data ?? [];
          }
        }
      },
    );
  }

  Future<void> saveVehicle() async {
    Map<String, dynamic> bodyParams = {
      'id_driver': userModel.value.userData?.id ?? '',
      'id_categorie_vehicle': selectedVehicleCategory.value.id.toString(),
      'brand': selectedBrand.value.id.toString(),
      'model': selectedModel.value.id.toString(),
      'color': colorController.value.text,
      'carregistration': numberPlateController.value.text,
      'car_make': carMakeController.value.text,
      'milage': millageController.value.text,
      'km_driven': kmDrivenController.value.text,
      'passenger': passenger.value.toString(),
      "zone_id": selectedZone.join(",")
    };
    await API
        .handleApiRequest(
            request: () => http.post(Uri.parse(API.vehicleRegister), headers: API.headers, body: jsonEncode(bodyParams)), showLoader: true)
        .then(
      (value) {
        if (value != null) {
          if (value['success'] == "failed" || value['success'] == "Failed") {
            ShowToastDialog.showToast(value['error']);
            return null;
          } else {
            ShowToastDialog.showToast(value['message']);
            Get.back(result: true);
          }
        }
      },
    );
  }
}
