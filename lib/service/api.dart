import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/page/auth_screens/login_screen.dart';
import 'package:cabme_driver/utils/Preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../constant/logdata.dart';

class API {
  static const baseUrl = "https://your-base-url.com/api/v1/"; // live
  static const apiKey = "your-api-key";


  static Map<String, String> authheader = {
    HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
    'apikey': apiKey,
  };

  static Map<String, String> get headers {
    return {
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      'apikey': apiKey,
      'accesstoken': Preferences.getString(Preferences.accesstoken),
    };
  }

  static const userSignUP = "${baseUrl}user";
  static const userLogin = "${baseUrl}user-login";
  static const getProfileByPhone = "${baseUrl}profilebyphone";
  static const getExistingUserOrNot = "${baseUrl}existing-user";
  static const sendResetPasswordOtp = "${baseUrl}reset-password-otp";
  static const editProfile = "${baseUrl}update-user-profile";
  static const getOwnerDashboard = "${baseUrl}get-owner-dashboard";

  static const resetPasswordOtp = "${baseUrl}reset-password";

  static const onBoarding = "${baseUrl}on-boarding?type=Driver";

  static const updateLocation = "${baseUrl}update-position";
  static const contactUs = "${baseUrl}contact-us";
  static const changeStatus = "${baseUrl}change-status";
  static const updateToken = "${baseUrl}update-fcm";
  static const getFcmToken = "${baseUrl}fcm-token";
  static const getRideReview = "${baseUrl}get-ride-review";
  static const getWalletHistory = "${baseUrl}get-wallet-history";

  static const getDriverUploadedDocument = "${baseUrl}driver-documents";
  static const driverDocumentUpdate = "${baseUrl}driver-documents-update";

  static const driverRecentRide = "${baseUrl}driver-recent-ride";
  static const conformRide = "${baseUrl}confirm-requete";
  static const rejectRide = "${baseUrl}set-rejected-requete";
  static const onRideRequest = "${baseUrl}onride-requete";

  static const changePassword = "${baseUrl}update-user-mdp";

  static const getVehicleData = "${baseUrl}vehicle-driver?id_driver=";

  static const vehicleRegister = "${baseUrl}vehicle";
  static const ownerVehicleRegister = "${baseUrl}owner-vehicle-register";
  static const getOwnerVehicle = "${baseUrl}get-owner-vehicle";
  static const removeDriverVehicle = "${baseUrl}remove-driver-vehicle";
  static const vehicleCategory = "${baseUrl}vehicle-category";
  static const getBookingList = "${baseUrl}get-booking-list";

  static const brand = "${baseUrl}brand";
  static const model = "${baseUrl}model";
  static const getZone = "${baseUrl}zone";
  static const bankDetails = "${baseUrl}bank-details";
  static const addBankDetails = "${baseUrl}add-bank-details";
  static const withdrawalsRequest = "${baseUrl}withdrawals";
  static const withdrawalsList = "${baseUrl}withdrawals-list";

  static const addComplaint = "${baseUrl}complaints";
  static const getComplaint = "${baseUrl}complaintsList";

  static const getLanguage = "${baseUrl}language";
  static const deleteUser = "${baseUrl}user-delete";
  static const deleteOwnerDriver = "${baseUrl}delete-owner-driver";
  static const settings = "${baseUrl}settings";
  static const privacyPolicy = "${baseUrl}privacy-policy";
  static const termsOfCondition = "${baseUrl}terms-of-condition";

  static const rideDetails = "${baseUrl}ridedetails";
  static const amount = "${baseUrl}amount";
  static const paymentSetting = "${baseUrl}payment-settings";
  static const getBookingDetails = "${baseUrl}get-booking-details";

  //Parcel Service
  static const getDriverParcelOrders = "${baseUrl}get-driver-parcel-orders";
  static const parcelContirm = "${baseUrl}parcel-confirm";
  static const parcelOnride = "${baseUrl}parcel-onride";
  static const parcelComplete = "${baseUrl}parcel-complete";

  static const parcelSearch = "${baseUrl}search-driver-parcel-order";
  static const getParcelDetail = "${baseUrl}get-parcel-detail";

  //SubscriptionAPI
  static const getSubscriptionPlans = "${baseUrl}get-subscription-plans";
  static const getSubscriptionHistory = "${baseUrl}get-subscription-history";
  static const setSubscription = "${baseUrl}set-subscription";

  static const completeRequest = "${baseUrl}complete-requete";
  static const submitReview = "${baseUrl}submit-review";
  static const getReview = "${baseUrl}get-review";

  //Owner Driver API
  static const getOwnerDriver = "${baseUrl}get-owner-driver";
  static const createOwnerDriver = "${baseUrl}add-owner-driver";

  //rental
  static const getRecentDriverRentalOrder = "${baseUrl}get-recent-driver-rental-order";
  static const searchDriverRentalOrder = "${baseUrl}search-driver-rental-order";
  static const rentalConfirm = "${baseUrl}rental-confirm";
  static const rentalOnRide = "${baseUrl}rental-onride";
  static const rentalRejected = "${baseUrl}rental-rejected";
  static const rentalSetFinalKm = "${baseUrl}rental-setfinalkm";
  static const rentalComplete = "${baseUrl}rental-complete";
  static const getRentalBookingDetails = "${baseUrl}get-rental-booking-details";
  static const getDriverDetails = "${baseUrl}get-driver-details";

  static const logout = "${baseUrl}logout";
  static const getServiceJson = "${baseUrl}get-service-json";

  static bool _isRedirectingToLogin = false; // Prevent multiple redirects

  static Future<dynamic> handleApiRequest({required Future<http.Response> Function() request, bool showLoader = true}) async {
    try {
      if (showLoader) {
        ShowToastDialog.showLoader("Please wait");
      }

      final response = await request().timeout(const Duration(seconds: 30));

      showLog("✅ API :: URL :: ${response.request?.url}");
      showLog("✅ API :: Response Status :: ${response.statusCode}");
      showLog("✅ API :: Response Body :: ${response.body}");

      final decodedResponse = jsonDecode(response.body);

      if (showLoader) ShowToastDialog.closeLoader();

      if (response.statusCode == 401 && !_isRedirectingToLogin) {
        _isRedirectingToLogin = true; // Lock redirect
        Preferences.clearKeyData(Preferences.accesstoken);
        Preferences.clearKeyData(Preferences.isLogin);
        Preferences.clearKeyData(Preferences.user);
        Preferences.clearKeyData(Preferences.userId);
        Get.offAll(const LoginScreen());
        return null;
      }

      if (response.statusCode == 200) {
        return decodedResponse;
      } else if (response.statusCode == 401 && !_isRedirectingToLogin) {
        _isRedirectingToLogin = true; // Lock redirect
        Preferences.clearKeyData(Preferences.accesstoken);
        Preferences.clearKeyData(Preferences.isLogin);
        Preferences.clearKeyData(Preferences.user);
        Preferences.clearKeyData(Preferences.userId);
        Get.offAll(const LoginScreen());
        return null;
      } else {
        CustomDialog.showErrorDialog("Server Error", "Status Code: ${response.statusCode}");
        return null;
      }
    } on TimeoutException {
      showLog("⏰ Timeout Exception");
      CustomDialog.showErrorDialog("Server Timeout", "The server took too long to respond.");
    } on SocketException {
      showLog("🌐 No Internet / DNS Fail");
      CustomDialog.showErrorDialog("No Internet", "Please check your connection.");
    } on FormatException {
      showLog("📦 JSON Decode Error");
      ShowToastDialog.showToast("Invalid response format.");
    } catch (e) {
      showLog("🔥 Unexpected Error: $e");
      CustomDialog.showErrorDialog("Unexpected Error", "$e");
    } finally {
      if (showLoader) ShowToastDialog.closeLoader();
    }

    return null;
  }

  static Future<dynamic> handleMultipartRequest(
      {required String url, required Map<String, String> headers, required Map<String, String> fields, List<http.MultipartFile>? files, bool showLoader = true}) async {
    try {
      if (showLoader) {
        ShowToastDialog.showLoader("Please wait");
      }

      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll(headers);
      request.fields.addAll(fields);

      if (files != null) {
        request.files.addAll(files);
      }

      var streamedResponse = await request.send();
      var responseBytes = await streamedResponse.stream.toBytes();
      var response = http.Response.bytes(
        responseBytes,
        streamedResponse.statusCode,
        headers: streamedResponse.headers,
        request: streamedResponse.request,
      );

      showLog("API :: URL :: ${response.request?.url}");
      showLog("API :: Response Status :: ${response.statusCode}");
      showLog("API :: Response Body :: ${response.body}");

      final decodedResponse = jsonDecode(response.body);

      if (showLoader) {
        ShowToastDialog.closeLoader();
      }

      if (response.statusCode == 200 && (decodedResponse['success'] == 'success' || decodedResponse['success'] == 'Success')) {
        return decodedResponse;
      } else if (response.statusCode == 200 && (decodedResponse['success'] == 'Failed' || decodedResponse['success'] == 'failed')) {
        return decodedResponse;
      } else {
        ShowToastDialog.showToast(decodedResponse['error'] ?? "Something went wrong");
        return null;
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.showToast("Timeout: ${e.message}");
    } on SocketException catch (e) {
      ShowToastDialog.showToast("Connection Error: ${e.message}");
    } on Error catch (e) {
      ShowToastDialog.showToast("Error: $e");
    } catch (e) {
      ShowToastDialog.showToast("Unexpected Error: $e");
    } finally {
      if (showLoader) {
        ShowToastDialog.closeLoader();
      }
    }
    return null;
  }
}

class CustomDialog {
  static bool _isDialogVisible = false;

  static void showErrorDialog(String title, String message) {
    if (_isDialogVisible) return;

    _isDialogVisible = true;

    Get.defaultDialog(
      title: title,
      content: Text(message),
      textConfirm: "OK",
      barrierDismissible: false,
      onConfirm: () {
        _isDialogVisible = false;
        Get.back();
      },
      onWillPop: () async {
        _isDialogVisible = false;
        return true;
      },
    );
  }
}
