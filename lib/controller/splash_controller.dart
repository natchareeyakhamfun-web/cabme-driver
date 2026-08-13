import 'dart:async';
import 'dart:ui';

import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/model/settings_model.dart';
import 'package:cabme_driver/model/user_model.dart';
import 'package:cabme_driver/on_boarding_screen.dart';
import 'package:cabme_driver/page/auth_screens/login_screen.dart';
import 'package:cabme_driver/page/dashboard_screen.dart';
import 'package:cabme_driver/page/localization_screens/localization_screen.dart';
import 'package:cabme_driver/page/location_permission_screen/location_permission_screen.dart';
import 'package:cabme_driver/page/maintenance_mode_screen/maintenance_mode_screen.dart';
import 'package:cabme_driver/page/owner_dashboard_screen.dart';
import 'package:cabme_driver/page/subscription_plan_screen/subscription_plan_screen.dart';
import 'package:cabme_driver/service/api.dart';
import 'package:cabme_driver/service/pusher_service.dart';
import 'package:cabme_driver/themes/app_them_data.dart';
import 'package:cabme_driver/utils/Preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SplashController extends GetxController {
  @override
  void onInit() {
    Timer(const Duration(seconds: 3), () => redirectScreen());
    super.onInit();
  }

  Future<void> redirectScreen() async {
    String? isMaintenanceMode = await getSettingsData();
    if (isMaintenanceMode == 'true') {
      Get.offAll(() => MaintenanceModeScreen());
      return;
    } else {
      bool isLocationPermission = await _checkLocationPermission();
      if (isLocationPermission) {
        if (Preferences.getString(Preferences.languageCodeKey).toString().isEmpty) {
          Get.offAll(LocalizationScreens(intentType: "main"));
        } else {
          if (Preferences.getBoolean(Preferences.isFinishOnBoardingKey)) {
            if (Preferences.getBoolean(Preferences.isLogin) == false) {
              Get.offAll(() => LoginScreen());
            } else {
              UserModel value = Constant.getUserData();
              UserData? userData = value.userData;
              await Preferences.setInt(Preferences.userId, int.parse(userData!.id.toString()));
              bool isPlanExpired = false;

              /// Case 1: Admin Commission is 'no' and Subscription model is disabled
              if (Constant.adminCommission?.statut == "no" && Constant.subscriptionModel == false) {
                if (userData.isOwner == "true") {
                  Get.offAll(() => OwnerDashboardScreen(), transition: Transition.rightToLeft);
                } else {
                  Get.offAll(() => DashboardScreen(), transition: Transition.rightToLeft);
                }
                return;
              }

              /// ✅ Updated: User is a driver *under an owner*
              bool isOwnerDriver = userData.isOwner == "false" && userData.ownerId != null && userData.ownerId!.isNotEmpty;

              if (isOwnerDriver) {
                Get.offAll(() => DashboardScreen(), transition: Transition.rightToLeft);
                return;
              }

              /// Owner user - check for subscription
              if (userData.subscriptionPlanId != null) {
                if (userData.subscriptionExpiryDate == null) {
                  isPlanExpired = userData.subscriptionPlan?.expiryDay != '-1';
                } else {
                  final expiryDate = DateTime.tryParse(userData.subscriptionExpiryDate!);
                  isPlanExpired = expiryDate != null && expiryDate.isBefore(DateTime.now());
                }
              } else {
                isPlanExpired = true;
              }

              if (userData.subscriptionPlanId == null || isPlanExpired) {
                Get.to(() => SubscriptionPlanScreen(), arguments: {'isSplashScreen': true});
              } else {
                if (userData.isOwner == "true") {
                  Get.offAll(() => OwnerDashboardScreen(), transition: Transition.rightToLeft);
                } else {
                  Get.offAll(() => DashboardScreen(), transition: Transition.rightToLeft);
                }
              }
            }
          } else {
            Get.offAll(() => OnBoardingScreen());
          }
        }
      } else {
        Get.offAll(const LocationPermissionScreen());
      }
    }
  }

  Future<String?> getSettingsData() async {
    String? isDriverMaintenanceMode = 'false';
    await API.handleApiRequest(request: () => http.get(Uri.parse(API.settings), headers: API.authheader), showLoader: false).then(
      (value) async {
        if (value != null) {
          if (value['success'] == "success" || value['success'] == "Success") {
            SettingsModel model = SettingsModel.fromJson(value);
            Constant.adminCommission = model.data!.adminCommission!;
            Constant.subscriptionModel = bool.parse(model.data!.subscriptionModel!);
            Constant.liveTrackingMapType = model.data?.mapType ?? '';
            Constant.selectedMapType = model.data?.mapForApplication != null ? '${model.data?.mapForApplication?.toLowerCase()}' : '';
            Constant.activeServices = model.data!.activeServices!;
            AppThemeData.primaryDefault = Color(int.parse(model.data!.driverappColor!.replaceFirst("#", "0xff")));
            Constant.distanceUnit = model.data!.deliveryDistance!;
            Constant.appVersion = model.data!.appVersion.toString();
            Constant.decimal = model.data!.decimalDigit!;

            Constant.currency = model.data!.currency!;
            Constant.symbolAtRight = model.data!.symbolAtRight! == 'true' ? true : false;
            Constant.kGoogleApiKey = model.data!.googleMapApiKey!;
            Constant.contactUsEmail = model.data!.contactUsEmail!;
            Constant.contactUsAddress = model.data!.contactUsAddress!;
            Constant.minimumWalletBalance = model.data!.minimumDepositAmount!;
            Constant.contactUsPhone = model.data!.contactUsPhone!;
            Constant.rideOtp = model.data!.showRideOtp!;
            Constant.driverLocationUpdateUnit = model.data!.driverLocationUpdate!;
            Constant.minimumWithdrawalAmount = model.data!.minimumWithdrawalAmount!;
            // Constant.deliveryChargeParcel = model.data!.deliveryChargeParcel!;

            // Constant.parcelPerWeightCharge = model.data!.parcelPerWeightCharge!;
            Constant.senderId = model.data!.senderId!;
            Constant.jsonNotificationFileURL = model.data!.serviceJson!;
            Constant.ownerDocVerification = model.data!.ownerDocVerification!;
            Constant.driverDocVerification = model.data!.driverDocVerification!;

            Constant.pusherApiKey = model.data!.pusherSettings!.pusherKey;
            Constant.cluster = model.data!.pusherSettings!.pusherCluster;

            Constant.defaultCountryCode = model.data!.defaultCountryCode;
            isDriverMaintenanceMode = model.data!.isDriverMaintenanceMode;

            await PusherService().init(
              apiKey: Constant.pusherApiKey!,
              cluster: Constant.cluster!,
            );
            return isDriverMaintenanceMode;
          } else {
            ShowToastDialog.showToast(value['error'] ?? "Something went wrong");
          }
        }
      },
    );
    return isDriverMaintenanceMode;
  }

  Future<bool> _checkLocationPermission() async {
    bool isLocationEnable;
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (isLocationServiceEnabled == false) {
      isLocationEnable = false;
    } else {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
        isLocationEnable = true;
      } else {
        isLocationEnable = false;
      }
    }

    return isLocationEnable;
  }
}
