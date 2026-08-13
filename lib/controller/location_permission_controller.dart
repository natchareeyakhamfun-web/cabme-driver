import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/model/user_model.dart';
import 'package:cabme_driver/on_boarding_screen.dart';
import 'package:cabme_driver/page/dashboard_screen.dart';
import 'package:cabme_driver/page/owner_dashboard_screen.dart';
import 'package:cabme_driver/page/subscription_plan_screen/subscription_plan_screen.dart';
import 'package:cabme_driver/utils/Preferences.dart';
import 'package:cabme_driver/utils/utils.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../constant/show_toast_dialog.dart';
import '../page/auth_screens/login_screen.dart';
import '../page/localization_screens/localization_screen.dart';
import '../themes/app_them_data.dart';
import '../widget/round_button_fill.dart';

class LocationPermissionController extends GetxController {
  Future<void> requestPermission() async {
    ShowToastDialog.showLoader("Please wait");
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationServiceEnabled) {
      ShowToastDialog.closeLoader();
      _showEnableGPSDialog();
      return;
    } else {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
        Constant.currentLocation = await Utils.getCurrentLocation();
        ShowToastDialog.closeLoader();
        if (Preferences.getString(Preferences.languageCodeKey).toString().isEmpty) {
          Get.offAll(LocalizationScreens(intentType: "main"));
        } else {
          if (Preferences.getBoolean(Preferences.isFinishOnBoardingKey)) {
            if (Preferences.getBoolean(Preferences.isLogin) == false) {
              Get.offAll(LoginScreen());
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
            Get.offAll(OnBoardingScreen());
          }
        }
      } else {
        ShowToastDialog.closeLoader();
        _showPermissionDeniedDialog();
      }
    }
  }

  /// Show Permission Denied Dialog
  void _showPermissionDeniedDialog() {
    Get.defaultDialog(
      title: "Permission Required",
      middleText: "We need your location to show nearby businesses and ensure accurate results. Please allow access when prompted.",
      barrierDismissible: false,
      confirm: RoundedButtonFill(
        onPress: () async {
          Get.back(); // Close dialog
          await Geolocator.openAppSettings();
          Future.delayed(Duration(seconds: 3), () async {
            await requestPermission(); // Recheck when returning from settings
          });
        },
        title: 'Allow Location',
        width: 40,
        height: 5,
        color: AppThemeData.primaryDefault,
      ),
    );
  }

  /// Show Dialog to Enable GPS
  void _showEnableGPSDialog() {
    Get.defaultDialog(
      title: "Enable GPS",
      middleText: "GPS is required for this app. Please enable location services.",
      barrierDismissible: false,
      confirm: RoundedButtonFill(
        onPress: () async {
          Get.back(); // Close dialog
          await Geolocator.openLocationSettings();
          Future.delayed(Duration(seconds: 3), () {
            requestPermission(); // Recheck when returning from settings
          });
        },
        title: 'Enable GPS',
        width: 40,
        height: 5,
        color: AppThemeData.primaryDefault,
      ),
    );
  }
}
