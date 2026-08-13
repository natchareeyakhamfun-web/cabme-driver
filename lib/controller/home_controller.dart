import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/ride_satatus.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/model/booking_mode.dart';
import 'package:cabme_driver/model/parcel_bokking_model.dart';
import 'package:cabme_driver/model/rental_booking_model.dart';
import 'package:cabme_driver/model/user_model.dart';
import 'package:cabme_driver/page/auth_screens/login_screen.dart';
import 'package:cabme_driver/service/api.dart';
import 'package:cabme_driver/service/pusher_service.dart';
import 'package:cabme_driver/utils/Preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class HomeController extends GetxController {
  RxBool isLoading = true.obs;
  RxBool status = true.obs;
  RxList<ParcelBookingData> parcelList = <ParcelBookingData>[].obs;

  Rx<UserModel> userModel = UserModel().obs;
  Rx<TextEditingController> otpController = TextEditingController().obs;
  Rx<TextEditingController> currentKilometerController = TextEditingController().obs;
  Rx<TextEditingController> completeKilometerController = TextEditingController().obs;
  final RxString selectedTabType = ''.obs;

  @override
  void onInit() {
    getData();
    update();
    super.onInit();
  }

  void setAvailableTabs(List<String> tabs) {
    if (tabs.isNotEmpty && selectedTabType.value.isEmpty) {
      selectedTabType.value = tabs.first;
    }
  }

  Future<void> getData() async {
    userModel.value = Constant.getUserData();
    await getUserData();
    await getBookingData();
    status.value = userModel.value.userData?.online == "yes";
    if (status.value == true) {
      await updateCurrentLocation();
      await getBooking();
      await getParcelList();
      await getRentalSearchBooking();
    }

    isLoading.value = false;
  }

  void updateTabType(String type) {
    selectedTabType.value = type;
  }

  Rx<BookingModel> bookingModel = BookingModel().obs;
  RxList<Stops> locationData = <Stops>[].obs;

  Future<void> getBookingData() async {
    PusherService().subscribeDriverRecentRide<BookingModel>(
      driverId: Preferences.getInt(Preferences.userId).toString(),
      event: 'updated',
      fromJson: BookingModel.fromJson,
      onData: (ride) {
        log("Ride updated: ${ride.toJson().toString()}");
        setBookingData(ride);
      },
    );
    update();
  }

  RxString subTotal = "0.0".obs;
  RxString discount = "0.0".obs;
  RxString taxAmount = "0.0".obs;
  RxString totalAmount = "0.0".obs;

  void calculateTotalAmount() {
    taxAmount = "0.0".obs;
    subTotal.value = bookingModel.value.data!.montant.toString();
    for (var element in bookingModel.value.data!.tax ?? []) {
      taxAmount.value = (double.parse(taxAmount.value) + Constant().calculateTax(amount: ((double.parse(subTotal.value)) - (double.parse(discount.value))).toString(), taxModel: element))
          .toStringAsFixed(int.tryParse(Constant.decimal.toString()) ?? 2);
    }
    if (bookingModel.value.data!.discountType != null) {
      discount.value = Constant.calculateDiscountOrder(amount: subTotal.value, offerModel: bookingModel.value.data!.discountType).toString();
    }
    totalAmount.value = ((double.parse(subTotal.value) - (double.parse(discount.value))) + double.parse(taxAmount.value)).toStringAsFixed(int.tryParse(Constant.decimal.toString()) ?? 2);
    update();
  }

  void setBookingData(BookingModel booking) {
    bookingModel.value = booking;
    if (booking.data != null) {
      if (booking.data!.statut == RideStatus.newRide || booking.data!.statut == RideStatus.confirmed || booking.data!.statut == RideStatus.onRide) {
        locationData.clear();
        locationData.add(Stops(location: booking.data!.departName, latitude: booking.data!.latitudeDepart, longitude: booking.data!.longitudeDepart));
        if (booking.data!.stops != null) {
          locationData.addAll(booking.data!.stops!.map((e) => Stops(location: e.location, latitude: e.latitude, longitude: e.longitude)));
        }
        locationData.add(Stops(location: booking.data!.destinationName, latitude: booking.data!.latitudeArrivee, longitude: booking.data!.longitudeArrivee));
        calculateTotalAmount();
      } else if (booking.data!.statut == RideStatus.canceled || booking.data!.statut == RideStatus.completed || booking.data!.statut == RideStatus.rejected) {
        bookingModel.value = BookingModel();
        update();
        // PusherService().unsubscribeDriverOrder(booking.data!.id.toString());
      }
    }
    update();
  }

  Future<void> getBooking() async {
    Map<String, dynamic> bodyParams = {
      'id_driver': Preferences.getInt(Preferences.userId),
    };

    await API.handleApiRequest(request: () => http.post(Uri.parse(API.driverRecentRide), headers: API.headers, body: jsonEncode(bodyParams)), showLoader: false).then(
      (value) async {
        if (value != null) {
          if (value['success'] == "Failed" || value['success'] == "failed") {
            bookingModel.value = BookingModel();
            return null;
          } else {
            BookingModel booking = BookingModel.fromJson(value);
            setBookingData(booking);
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
            await getBooking();
            ShowToastDialog.showToast("Ride accepted successfully");
          }
        }
      },
    );
  }

  Future<void> onRideStatus() async {
    Map<String, dynamic> bodyParams = {
      'id_driver': Preferences.getInt(Preferences.userId),
      'id_ride': bookingModel.value.data!.id,
      'otp': otpController.value.text.trim(),
    };

    await API.handleApiRequest(request: () => http.post(Uri.parse(API.onRideRequest), headers: API.headers, body: jsonEncode(bodyParams)), showLoader: true).then(
      (value) async {
        if (value != null) {
          if (value['success'] == "Failed" || value['success'] == "failed") {
            ShowToastDialog.showToast(value['message']);
            return null;
          } else {
            await getBooking();
            otpController.value.clear();
            ShowToastDialog.showToast("Ride accepted successfully");
            Get.back();
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

  Future<void> completeBooking() async {
    Map<String, dynamic> requestBody = {
      "id_ride": bookingModel.value.data!.id,
      "id_user": bookingModel.value.data!.user!.id,
      "id_driver": bookingModel.value.data!.driver!.id,
      "id_payment": bookingModel.value.data!.idPaymentMethod,
      "transaction_id": DateTime.now().microsecondsSinceEpoch.toString(),
      "discount": "0",
      "tip": "0",
    };

    await API.handleApiRequest(request: () => http.post(Uri.parse(API.completeRequest), headers: API.headers, body: jsonEncode(requestBody)), showLoader: true).then(
      (value) async {
        if (value != null) {
          if (value['success'] == "Failed" || value['success'] == "ailed") {
            ShowToastDialog.showToast(value['error']);
            return null;
          } else {
            Get.back();
            await getBooking();
            ShowToastDialog.showToast("Payment received successfully !!");
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
            await getBooking();
            ShowToastDialog.showToast("Ride rejected successfully");
          }
        }
      },
    );
  }

  Future<void> changeStatus(bool value) async {
    status.value = value;
    Map<String, dynamic> bodyParams = {
      'id_driver': Preferences.getInt(Preferences.userId),
      'online': status.value ? 'yes' : 'no',
    };

    await API.handleApiRequest(request: () => http.post(Uri.parse(API.changeStatus), headers: API.headers, body: jsonEncode(bodyParams)), showLoader: true).then(
      (value) async {
        if (value != null) {
          if (value['success'] == "Failed" || value['success'] == "failed") {
            ShowToastDialog.showToast(value['error']);
            return null;
          } else {
            await getData();
            ShowToastDialog.showToast(status.value ? "You are online now" : "You are offline now");
            updateCurrentLocation();
          }
        }
      },
    );
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
            Preferences.clearKeyData(Preferences.isLogin);
            Preferences.clearKeyData(Preferences.user);
            Preferences.clearKeyData(Preferences.userId);
            Preferences.clearKeyData(Preferences.accesstoken);
            Get.offAll(const LoginScreen());
            return null;
          } else {
            userModel.value = UserModel.fromJson(value);
            Preferences.setString(Preferences.user, jsonEncode(value));
          }
        }
      },
    );
  }

  Location location = Location();
  late StreamSubscription<LocationData> locationSubscription;

  Future<void> updateCurrentLocation() async {
    PermissionStatus permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.granted) {
      location.changeSettings(accuracy: LocationAccuracy.high, distanceFilter: double.parse(Constant.driverLocationUpdateUnit.toString()));
      locationSubscription = location.onLocationChanged.listen((locationData) {
        LocationData currentLocation = locationData;
        setDriverLocationUpdate(currentLocation.latitude.toString(), currentLocation.longitude.toString());
      });
    } else {
      location.requestPermission().then((permissionStatus) {
        if (permissionStatus == PermissionStatus.granted) {
          location.changeSettings(accuracy: LocationAccuracy.high, distanceFilter: double.parse(Constant.driverLocationUpdateUnit.toString()));
          locationSubscription = location.onLocationChanged.listen((locationData) {
            LocationData currentLocation = locationData;
            setDriverLocationUpdate(currentLocation.latitude.toString(), currentLocation.longitude.toString());
          });
        }
      });
    }
  }

  Future<void> setDriverLocationUpdate(String latitude, String longitude) async {
    Map<String, dynamic> bodyParams = {'id_user': Preferences.getInt(Preferences.userId), 'user_cat': userModel.value.userData!.userCat.toString(), 'latitude': latitude, 'longitude': longitude};
    await API.handleApiRequest(request: () => http.post(Uri.parse(API.updateLocation), headers: API.headers, body: jsonEncode(bodyParams)), showLoader: false);
  }

  var selectedIndex = 0.obs;

  void updateIndex(int index) {
    selectedIndex.value = index;
  }

  Future<void> getParcelList() async {
    Map<String, dynamic> bodyParams = {
      'id_driver': Preferences.getInt(Preferences.userId),
    };

    await API.handleApiRequest(request: () => http.post(Uri.parse(API.getDriverParcelOrders), headers: API.headers, body: jsonEncode(bodyParams)), showLoader: false).then(
      (value) async {
        if (value != null) {
          if (value['success'] == "Failed" || value['success'] == "failed") {
            parcelList.clear();
            return null;
          } else {
            parcelList.value = (value['data'] as List).map((e) => ParcelBookingData.fromJson(e)).toList();
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
            return null;
          } else {
            await getParcelList();
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
            await getParcelList();
            ShowToastDialog.showToast("Parcel delivered successfully");
          }
        }
      },
    );
  }

  RxList<RentalBookingData> rentalBookingData = <RentalBookingData>[].obs;

  Future<void> getRentalSearchBooking() async {
    Map<String, dynamic> bodyParams = {
      'driver_id': Preferences.getInt(Preferences.userId).toString(),
    };
    await API.handleApiRequest(request: () => http.post(Uri.parse(API.getRecentDriverRentalOrder), headers: API.headers, body: jsonEncode(bodyParams)), showLoader: false).then(
      (value) async {
        if (value != null) {
          RentalBookingModel model = RentalBookingModel.fromJson(value);
          if (model.success == "Failed" || model.success == "failed") {
            rentalBookingData.clear();
            return null;
          } else {
            rentalBookingData.value = (value['data'] as List).map((e) => RentalBookingData.fromJson(e)).toList();
          }
        }
      },
    );
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
            await getRentalSearchBooking();
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
            await getRentalSearchBooking();
            ShowToastDialog.showToast("Kilometer updated successfully");
            Get.back();
          }
        }
      },
    );
  }
}
