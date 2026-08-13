import 'dart:convert';
import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/model/parcel_bokking_model.dart';
import 'package:cabme_driver/service/api.dart';
import 'package:cabme_driver/utils/Preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as latlong;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ParcelSearchController extends GetxController {
  RxBool isLoading = true.obs;
  final Rx<TextEditingController> sourceTextEditController = TextEditingController().obs;
  final Rx<TextEditingController> destinationTextEditController = TextEditingController().obs;
  final Rx<TextEditingController> dateTimeTextEditController = TextEditingController().obs;

  // Journey
  final Rx<LatLng?> departureLatLong = Rx<LatLng?>(null);
  final Rx<LatLng?> destinationLatLong = Rx<LatLng?>(null);
  final Rx<latlong.LatLng?> departureLatLongOsm = Rx<latlong.LatLng?>(null);
  final Rx<latlong.LatLng?> destinationLatLongOsm = Rx<latlong.LatLng?>(null);

  @override
  void onInit() {
    isLoading.value = false;
    // TODO: implement onInit
    super.onInit();
  }

  Rx<DateTime> pickUpDateTime = DateTime.now().obs;

  Future<void> pickDateTime() async {
    DateTime? date = await showDatePicker(
      context: Get.context!,
      initialDate: pickUpDateTime.value,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date == null) return;
    pickUpDateTime.value = date;
    dateTimeTextEditController.value.text = DateFormat('dd-MMM-yyyy').format(date);
    update();
  }

  RxList<ParcelBookingData> parcelList = <ParcelBookingData>[].obs;

  Future<dynamic> searchParcel() async {
    if (departureLatLongOsm.value == null && departureLatLong.value == null) {
      ShowToastDialog.showToast("Please select source location");
      return null;
    }
    Map<String, dynamic> bodyParams = {
      'source_lat':
          Constant.selectedMapType == 'osm' ? departureLatLongOsm.value!.latitude.toString() : departureLatLong.value!.latitude.toString(),
      'source_lng': Constant.selectedMapType == 'osm'
          ? departureLatLongOsm.value!.longitude.toString()
          : departureLatLong.value!.longitude.toString(),
      'destination_lat': Constant.selectedMapType == 'osm'
          ? destinationLatLongOsm.value != null
              ? destinationLatLongOsm.value!.latitude.toString()
              : ""
          : destinationLatLong.value != null
              ? destinationLatLong.value!.latitude.toString()
              : "",
      'destination_lng': Constant.selectedMapType == 'osm'
          ? destinationLatLongOsm.value != null
              ? destinationLatLongOsm.value!.longitude.toString()
              : ""
          : destinationLatLong.value != null
              ? destinationLatLong.value!.longitude.toString()
              : "",
      'driver_id': Preferences.getInt(Preferences.userId).toString(),
      'date': dateTimeTextEditController.value.text,
    };

    await API
        .handleApiRequest(
            request: () => http.post(Uri.parse(API.parcelSearch), headers: API.headers, body: jsonEncode(bodyParams)), showLoader: true)
        .then(
      (value) async {
        if (value != null) {
          // ParcelBookingModel model = ParcelBookingModel.fromJson(value);
          if (value['success'] == "Failed" || value['success'] == "failed") {
            ShowToastDialog.showToast(value['error']);
            return null;
          } else {
            parcelList.value = (value['data'] as List).map((e) => ParcelBookingData.fromJson(e)).toList();
          }
        }
      },
    );
  }

  String calculateParcelTotalAmountBooking(ParcelBookingData parcelBookingData) {
    String subTotal = parcelBookingData.amount.toString();
    String discount = "0.0";
    String taxAmount = "0.0";
    if (parcelBookingData.discountType != null) {
      discount = Constant.calculateDiscountOrder(amount: subTotal, offerModel: parcelBookingData.discountType).toString();
    }
    for (var element in parcelBookingData.tax!) {
      taxAmount = (double.parse(taxAmount) + Constant().calculateTax(amount: (double.parse(subTotal) - double.parse(discount)).toString(), taxModel: element))
          .toStringAsFixed(int.tryParse(Constant.decimal.toString()) ?? 2);
    }

    return ((double.parse(subTotal) - (double.parse(discount))) + double.parse(taxAmount)).toStringAsFixed(int.tryParse(Constant.decimal.toString()) ?? 2);
  }



  Future<void> acceptParcelBooking(ParcelBookingData parcelBookingData) async {
    Map<String, dynamic> bodyParams = {
      'id_driver': Preferences.getInt(Preferences.userId),
      'id_parcel': parcelBookingData.id,
    };

    await API
        .handleApiRequest(
            request: () => http.post(Uri.parse(API.parcelContirm), headers: API.headers, body: jsonEncode(bodyParams)), showLoader: true)
        .then(
      (value) async {
        if (value != null) {
          if (value['success'] == "Failed" || value['success'] == "failed") {
            ShowToastDialog.showToast(value['error']);
            return null;
          } else {
            ShowToastDialog.showToast("Parcel Booking Accepted");
            Get.back(result: true);
          }
        }
      },
    );
  }
}
