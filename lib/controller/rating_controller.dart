import 'dart:convert';

import 'package:cabme_driver/constant/logdata.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/model/booking_mode.dart';
import 'package:cabme_driver/model/parcel_bokking_model.dart';
import 'package:cabme_driver/model/rental_booking_model.dart';
import 'package:cabme_driver/model/review_list_model.dart';
import 'package:cabme_driver/service/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RatingController extends GetxController {
  RxBool isLoading = true.obs;

  Rx<TextEditingController> ratingController = TextEditingController().obs;
  Rx<BookingData> bookingModel = BookingData().obs;
  Rx<ParcelBookingData> parcelBookingModel = ParcelBookingData().obs;
  Rx<RentalBookingData> rentalBookingModel = RentalBookingData().obs;

  RxDouble rating = 1.0.obs;
  RxString bookingType = "ride".obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getArgument();

    super.onInit();
  }

  Future<void> getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      bookingType.value = argumentData['bookingType'];
      if (bookingType.value == "ride") {
        bookingModel.value = argumentData['bookingModel'];
      } else if (bookingType.value == "rental") {
        rentalBookingModel.value = argumentData['rentalBookingModel'];
      } else {
        parcelBookingModel.value = argumentData['parcelBookingModel'];
        showLog(parcelBookingModel.value.toJson().toString());
      }
    }
    await getReview();
    isLoading.value = false;
    update();
  }

  Future<void> getReview() async {
    Map<String, String> bodyParams = {
      'booking_id': bookingType.value == "ride"
          ? bookingModel.value.id.toString()
          : bookingType.value == "rental"
              ? rentalBookingModel.value.id.toString()
              : parcelBookingModel.value.id.toString(),
      'booking_type': bookingType.value,
      'review_from': "driver",
    };
    await API
        .handleApiRequest(
            request: () => http.post(Uri.parse(API.getReview), headers: API.headers, body: jsonEncode(bodyParams)), showLoader: true)
        .then(
      (value) {
        if (value != null) {
          ReviewListModel model = ReviewListModel.fromJson(value);
          if (model.success == "success" || model.success == "Success") {
            if (model.data!.where((element) => element.reviewTo == "customer").isNotEmpty) {
              ReviewListData reviewListData = model.data!.where((element) => element.reviewTo == "customer").first;
              rating.value = double.parse(reviewListData.rating.toString());
              ratingController.value.text = reviewListData.comment.toString();
            }
          }
        }
      },
    );
  }

  Future<void> submitReview() async {
    Map<String, String> bodyParams = {
      'booking_id': bookingType.value == "ride"
          ? bookingModel.value.id.toString()
          : bookingType.value == "rental"
              ? rentalBookingModel.value.id.toString()
              : parcelBookingModel.value.id.toString(),
      'booking_type': bookingType.value,
      'user_id': bookingType.value == "ride"
          ? bookingModel.value.user!.id.toString()
          : bookingType.value == "rental"
              ? rentalBookingModel.value.user!.id.toString()
              : parcelBookingModel.value.user!.id.toString(),
      'driver_id': bookingType.value == "ride"
          ? bookingModel.value.driver!.id.toString()
          : bookingType.value == "rental"
              ? rentalBookingModel.value.driver!.id.toString()
              : parcelBookingModel.value.driver!.id.toString(),
      'review_from': "driver",
      'review_to': "customer",
      'rating': rating.toString(),
      'comment': ratingController.value.text.toString(),
    };
    await API
        .handleApiRequest(
            request: () => http.post(Uri.parse(API.submitReview), headers: API.headers, body: jsonEncode(bodyParams)), showLoader: true)
        .then(
      (value) {
        if (value != null) {
          if (value['success'] == "Failed" || value['success'] == "failed") {
            ShowToastDialog.showToast(value['message']);
            return null;
          } else {
            Get.back(result: true);
            ShowToastDialog.showToast("Rating submitted successfully");
          }
        }
      },
    );
  }
}
