import 'dart:convert';

import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/model/rental_booking_model.dart';
import 'package:cabme_driver/service/api.dart';
import 'package:cabme_driver/utils/Preferences.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RentalBookingSearchController extends GetxController {
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getRentalSearchBooking();
    super.onInit();
  }

  RxList<RentalBookingData> rentalBookingData = <RentalBookingData>[].obs;

  Future<void> getRentalSearchBooking() async {
    Map<String, dynamic> bodyParams = {
      'driver_id': Preferences.getInt(Preferences.userId).toString(),
    };
    await API
        .handleApiRequest(
            request: () => http.post(Uri.parse(API.searchDriverRentalOrder), headers: API.headers, body: jsonEncode(bodyParams)),
            showLoader: false)
        .then(
      (value) async {
        if (value != null) {
          RentalBookingModel model = RentalBookingModel.fromJson(value);
          if (model.success == "Failed" || model.success == "failed") {
            return null;
          } else {
            rentalBookingData.value = (value['data'] as List).map((e) => RentalBookingData.fromJson(e)).toList();
          }
        }
      },
    );
    isLoading.value = false;
  }

  Future<void> acceptRentalBooking(String rideId) async {
    Map<String, dynamic> bodyParams = {
      'id_driver': Preferences.getInt(Preferences.userId),
      'id_rental': rideId,
    };

    await API
        .handleApiRequest(
            request: () => http.post(Uri.parse(API.rentalConfirm), headers: API.headers, body: jsonEncode(bodyParams)), showLoader: true)
        .then(
      (value) async {
        if (value != null) {
          if (value['success'] == "Failed" || value['success'] == "failed") {
            ShowToastDialog.showToast(value['error']);
            return null;
          } else {
            await getRentalSearchBooking();
            ShowToastDialog.showToast("Ride accepted successfully");
            Get.back(result: true);
          }
        }
      },
    );
  }

  Future<void> rejectedRentalBooking(String rideId) async {
    Map<String, dynamic> bodyParams = {
      'id_driver': Preferences.getInt(Preferences.userId),
      'id_rental': rideId,
    };

    await API
        .handleApiRequest(
            request: () => http.post(Uri.parse(API.rentalRejected), headers: API.headers, body: jsonEncode(bodyParams)), showLoader: true)
        .then(
      (value) async {
        if (value != null) {
          if (value['success'] == "Failed" || value['success'] == "failed") {
            ShowToastDialog.showToast(value['error']);
            return null;
          } else {
            await getRentalSearchBooking();
            ShowToastDialog.showToast("Ride rejected successfully");
            Get.back(result: true);
          }
        }
      },
    );
  }
}
