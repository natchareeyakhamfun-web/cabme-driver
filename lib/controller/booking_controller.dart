import 'dart:convert';
import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/ride_satatus.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/model/booking_mode.dart';
import 'package:cabme_driver/model/parcel_bokking_model.dart';
import 'package:cabme_driver/model/rental_booking_model.dart';
import 'package:cabme_driver/model/user_model.dart';
import 'package:cabme_driver/service/api.dart';
import 'package:cabme_driver/utils/Preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class BookingController extends GetxController {
  RxBool isLoading = true.obs;
  RxString bookingType = "Ride Booking".obs;
  final LayerLink layerLink = LayerLink();
  GlobalKey overlayKey = GlobalKey();

  Rx<TextEditingController> currentKilometerController = TextEditingController().obs;
  Rx<TextEditingController> completeKilometerController = TextEditingController().obs;

   RxList<String> types = <String>[].obs;

   Rx<UserModel> userModel = UserModel().obs;
  @override
  void onInit() {
    // TODO: implement onInit
    userModel.value = Constant.getUserData();
    getBookingList();
    types.value = [
      if(userModel.value.userData!.serviceType!.contains("ride"))'Ride Booking',
      if(userModel.value.userData!.serviceType!.contains("parcel"))'Parcel Delivery',
      if(userModel.value.userData!.serviceType!.contains("rental"))'Rental Cars',
    ];
    isLoading.value = false;
    super.onInit();
  }

  Rx<TextEditingController> otpController = TextEditingController().obs;

  RxList<BookingData> newList = <BookingData>[].obs;
  RxList<BookingData> onGoingList = <BookingData>[].obs;
  RxList<BookingData> completedList = <BookingData>[].obs;
  RxList<BookingData> cancelledList = <BookingData>[].obs;

  RxList<ParcelBookingData> newParcelList = <ParcelBookingData>[].obs;
  RxList<ParcelBookingData> onGoingParcelList = <ParcelBookingData>[].obs;
  RxList<ParcelBookingData> completedParcelList = <ParcelBookingData>[].obs;
  RxList<ParcelBookingData> cancelledParcelList = <ParcelBookingData>[].obs;


  RxList<RentalBookingData> newRentalList = <RentalBookingData>[].obs;
  RxList<RentalBookingData> onGoingRentalList = <RentalBookingData>[].obs;
  RxList<RentalBookingData> completedRentalList = <RentalBookingData>[].obs;
  RxList<RentalBookingData> cancelledRentalList = <RentalBookingData>[].obs;

  Future<void> getBookingList() async {
    Map<String, dynamic> bodyParams = {
      'user_type': "driver",
      'user_id': Preferences.getInt(Preferences.userId).toString(),
      'booking_type': bookingType.value == "Ride Booking"
          ? 'ride'
          : bookingType.value == "Parcel Delivery"
              ? "parcel"
              : 'rental',
    };
    print("Booking : $bodyParams");
    await API.handleApiRequest(request: () => http.post(Uri.parse(API.getBookingList), headers: API.headers, body: jsonEncode(bodyParams)), showLoader: false).then(
      (value) {
        if (value != null) {
          if (value['success'] == "Failed" || value['success'] == "failed") {
            return null;
          } else {
            if (bookingType.value == "Ride Booking") {
              newList.value = (value['data'] as List)
                  .map((e) => BookingData.fromJson(e))
                  .toList()
                  .where((element) => element.statut == RideStatus.newRide || element.statut == RideStatus.confirmed)
                  .toList();
              onGoingList.value = (value['data'] as List)
                  .map((e) => BookingData.fromJson(e))
                  .toList()
                  .where((element) => element.statut == RideStatus.onRide)
                  .toList();
              completedList.value = (value['data'] as List)
                  .map((e) => BookingData.fromJson(e))
                  .toList()
                  .where((element) => element.statut == RideStatus.completed)
                  .toList();
              cancelledList.value = (value['data'] as List)
                  .map((e) => BookingData.fromJson(e))
                  .toList()
                  .where((element) => element.statut == RideStatus.rejected || element.statut == RideStatus.canceled)
                  .toList();
            }
            else if (bookingType.value == "Parcel Delivery") {
              newParcelList.value = (value['data'] as List)
                  .map((e) => ParcelBookingData.fromJson(e))
                  .toList()
                  .where((element) => element.status == RideStatus.newRide || element.status == RideStatus.confirmed)
                  .toList();
              onGoingParcelList.value = (value['data'] as List)
                  .map((e) => ParcelBookingData.fromJson(e))
                  .toList()
                  .where((element) => element.status == RideStatus.onRide)
                  .toList();
              completedParcelList.value = (value['data'] as List)
                  .map((e) => ParcelBookingData.fromJson(e))
                  .toList()
                  .where((element) => element.status == RideStatus.completed)
                  .toList();
              cancelledParcelList.value = (value['data'] as List)
                  .map((e) => ParcelBookingData.fromJson(e))
                  .toList()
                  .where((element) => element.status == RideStatus.rejected || element.status == RideStatus.canceled)
                  .toList();
            }
            else if (bookingType.value == "Rental Cars") {
              newRentalList.value = (value['data'] as List)
                  .map((e) => RentalBookingData.fromJson(e))
                  .toList()
                  .where((element) => element.status == RideStatus.newRide || element.status == RideStatus.confirmed)
                  .toList();
              onGoingRentalList.value = (value['data'] as List)
                  .map((e) => RentalBookingData.fromJson(e))
                  .toList()
                  .where((element) => element.status == RideStatus.onRide)
                  .toList();
              completedRentalList.value = (value['data'] as List)
                  .map((e) => RentalBookingData.fromJson(e))
                  .toList()
                  .where((element) => element.status == RideStatus.completed)
                  .toList();
              cancelledRentalList.value = (value['data'] as List)
                  .map((e) => RentalBookingData.fromJson(e))
                  .toList()
                  .where((element) => element.status == RideStatus.rejected || element.status == RideStatus.canceled)
                  .toList();
            }

          }
          Get.back();
        }
      },
    );

    isLoading.value = false;
  }

  void selectType(String type) {
    bookingType.value = type;
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


  Future<void> onRideStatusRental(String bookingId) async {
    Map<String, dynamic> bodyParams = {
      'id_driver': Preferences.getInt(Preferences.userId),
      'id_rental': bookingId,
      'otp': otpController.value.text.trim(),
      'current_km': currentKilometerController.value.text.trim(),
    };

    await API.handleApiRequest(request: () => http.post(Uri.parse(API.rentalOnRide), headers: API.headers, body: jsonEncode(bodyParams)), showLoader: true).then(
          (value) async {
        if (value != null) {
          if (value['success'] == "Failed" || value['success'] == "failed") {
            ShowToastDialog.showToast(value['message']);
            return null;
          } else {
            await getBookingList();
            ShowToastDialog.showToast("Ride accepted successfully");
            Get.back();
          }
        }
      },
    );
  }

  Future<void> setFinalKilometerOfRental(String bookingId) async {
    Map<String, dynamic> bodyParams = {
      'id_rental': bookingId,
      'complete_km': completeKilometerController.value.text.trim(),
    };

    await API.handleApiRequest(request: () => http.post(Uri.parse(API.rentalSetFinalKm), headers: API.headers, body: jsonEncode(bodyParams)), showLoader: true).then(
          (value) async {
        if (value != null) {
          if (value['success'] == "Failed" || value['success'] == "failed") {
            ShowToastDialog.showToast(value['message']);
            return null;
          } else {
            await getBookingList();
            ShowToastDialog.showToast("Kilometer updated successfully");
            Get.back();
          }
        }
      },
    );
  }


  Future<void> acceptBooking(String rideId) async {
    Map<String, dynamic> bodyParams = {
      'id_driver': Preferences.getInt(Preferences.userId),
      'id_ride': rideId,
    };

    await API.handleApiRequest(request: () => http.post(Uri.parse(API.conformRide), headers: API.headers, body: jsonEncode(bodyParams)), showLoader: true).then(
      (value) async {
        if (value != null) {
          if (value['success'] == "Failed" || value['success'] == "failed") {
            ShowToastDialog.showToast(value['error']);
            return null;
          } else {
            await getBookingList();
            ShowToastDialog.showToast("Ride accepted successfully");
          }
        }
      },
    );
  }

  Future<void> rejectBooking(String rideId) async {
    Map<String, dynamic> bodyParams = {
      'id_driver': Preferences.getInt(Preferences.userId),
      'id_ride': rideId,
      'reason': "Driver rejected the ride",
    };

    await API.handleApiRequest(request: () => http.post(Uri.parse(API.rejectRide), headers: API.headers, body: jsonEncode(bodyParams)), showLoader: true).then(
      (value) async {
        if (value != null) {
          if (value['success'] == "Failed" || value['success'] == "failed") {
            ShowToastDialog.showToast(value['error']);
            return null;
          } else {
            await getBookingList();
            ShowToastDialog.showToast("Ride rejected successfully");
          }
        }
      },
    );
  }

  Future<void> onRideStatus(BookingData bookingData) async {
    Map<String, dynamic> bodyParams = {
      'id_driver': Preferences.getInt(Preferences.userId),
      'id_ride': bookingData.id,
      'otp': otpController.value.text.trim(),
    };

    await API.handleApiRequest(request: () => http.post(Uri.parse(API.onRideRequest), headers: API.headers, body: jsonEncode(bodyParams)), showLoader: true).then(
      (value) async {
        if (value != null) {
          if (value['success'] == "Failed" || value['success'] == "failed") {
            ShowToastDialog.showToast(value['message']);
            return null;
          } else {
            await getBookingList();
            ShowToastDialog.showToast("Ride accepted successfully");
            Get.back();
          }
        }
      },
    );
  }

  Future<void> completeBooking(BookingData bookingData) async {
    Map<String, dynamic> requestBody = {
      "id_ride": bookingData.id,
      "id_user": bookingData.user!.id,
      "id_driver": bookingData.driver!.id,
      "id_payment": bookingData.idPaymentMethod,
      "transaction_id": DateTime.now().microsecondsSinceEpoch.toString(),
      "discount": "0",
      "tip": "0",
    };

    await API.handleApiRequest(request: () => http.post(Uri.parse(API.completeRequest), headers: API.headers, body: jsonEncode(requestBody)), showLoader: false).then(
      (value) async {
        if (value != null) {
          if (value['success'] == "Failed" || value['success'] == "ailed") {
            ShowToastDialog.showToast(value['error']);
            return null;
          } else {
            Get.back();
            await getBookingList();
            ShowToastDialog.showToast("Payment Successful!!");
          }
        }
      },
    );
  }

  Future<void> pickUpParcelBooking(ParcelBookingData parcelBookingData) async {
    Map<String, dynamic> bodyParams = {
      'id_driver': Preferences.getInt(Preferences.userId),
      'id_parcel': parcelBookingData.id,
    };

    await API.handleApiRequest(request: () => http.post(Uri.parse(API.parcelOnride), headers: API.headers, body: jsonEncode(bodyParams)), showLoader: true).then(
      (value) async {
        if (value != null) {
          if (value['success'] == "Failed" || value['success'] == "failed") {
            ShowToastDialog.showToast(value['error']);
            return null;
          } else {
            await getBookingList();
            ShowToastDialog.showToast("Parcel picked up successfully");
          }
        }
      },
    );
  }

  Future<void> completeParcelBooking(ParcelBookingData parcelBookingData) async {
    Map<String, dynamic> bodyParams = {
      'id_driver': Preferences.getInt(Preferences.userId),
      'id_parcel': parcelBookingData.id,
    };

    await API.handleApiRequest(request: () => http.post(Uri.parse(API.parcelComplete), headers: API.headers, body: jsonEncode(bodyParams)), showLoader: true).then(
      (value) async {
        if (value != null) {
          if (value['success'] == "Failed" || value['success'] == "failed") {
            ShowToastDialog.showToast(value['error']);
            return null;
          } else {
            await getBookingList();
            ShowToastDialog.showToast("Parcel picked up successfully");
          }
        }
      },
    );
  }
}
