// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/controller/otp_controller.dart';
import 'package:cabme_driver/model/user_model.dart';
import 'package:cabme_driver/page/dashboard_screen.dart';
import 'package:cabme_driver/page/owner_dashboard_screen.dart';
import 'package:cabme_driver/page/subscription_plan_screen/subscription_plan_screen.dart';
import 'package:cabme_driver/service/api.dart';
import 'package:cabme_driver/utils/Preferences.dart';
import 'package:cabme_driver/utils/dark_theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../themes/app_them_data.dart';
import '../../widget/round_button_fill.dart';
import 'signup_screen.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<OTPController>(
        init: OTPController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              leading: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(Icons.arrow_back)),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Verify your number'.tr,
                      textAlign: TextAlign.start,
                      style: AppThemeData.boldTextStyle(fontSize: 22, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Enter the 6-digit code'.tr,
                      textAlign: TextAlign.start,
                      style: AppThemeData.mediumTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark500 : AppThemeData.neutral500),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Pinput(
                      scrollPadding: EdgeInsets.zero,
                      controller: controller.otpController.value,
                      defaultPinTheme: PinTheme(
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        height: 55,
                        width: 55,
                        textStyle: AppThemeData.mediumTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(50),
                          color: themeChange.getThem() ? AppThemeData.neutralDark100 : AppThemeData.neutral100,
                          border: Border.all(color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300, width: 0.8),
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      length: 6,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50),
                      child: RoundedButtonFill(
                        title: "Verify".tr,
                        height: 5.5,
                        color: AppThemeData.primaryDefault,
                        textColor: AppThemeData.neutral50,
                        onPress: () async {
                          FocusScope.of(context).unfocus();

                          if (controller.otpController.value.text.length == 6) {
                            ShowToastDialog.showLoader("Verify OTP".tr);
                            PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: controller.verificationId.toString(), smsCode: controller.otpController.value.text);
                            await FirebaseAuth.instance.signInWithCredential(credential).then((value) async {
                              Map<String, String> bodyParams = {
                                'phone': controller.phoneNumber.value,
                                'country_code': controller.countryCode.value,
                                'country_iso_code': controller.countryISOCode.value,
                                'user_cat': "driver",
                                'login_type': "phoneNumber",
                              };
                              await controller.phoneNumberIsExit(bodyParams).then((value) async {
                                if (value != null) {
                                  if (value == true) {
                                    Map<String, String> bodyParams = {
                                      'phone': controller.phoneNumber.value,
                                      'country_code': controller.countryCode.value,
                                      'country_iso_code': controller.countryISOCode.value,
                                      'user_cat': "driver",
                                      'login_type': "phoneNumber",
                                    };
                                    await controller.getDataByPhoneNumber(bodyParams).then((value) {
                                      if (value != null) {
                                        UserModel userModel = value;
                                        if (userModel.success == "Failed" || userModel.success == "failed") {
                                          ShowToastDialog.closeLoader();
                                          ShowToastDialog.showToast(userModel.error ?? "Something went wrong, please try again later");
                                          return;
                                        } else {
                                          Preferences.setInt(Preferences.userId, int.parse(value.userData!.id.toString()));
                                          Preferences.setString(Preferences.user, jsonEncode(value));
                                          Preferences.setString(Preferences.accesstoken, value.userData!.accesstoken.toString());
                                          API.headers['accesstoken'] = value.userData!.accesstoken.toString();

                                          Preferences.setBoolean(Preferences.isLogin, true);

                                          bool isPlanExpired = false;
                                          UserData userData = userModel.userData!;

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
                                        ShowToastDialog.showToast("Something went wrong, please try again later");
                                      }
                                    });
                                  } else if (value == false) {
                                    ShowToastDialog.closeLoader();
                                    Get.to(() => SignupScreen(), arguments: {
                                      'phoneNumber': controller.phoneNumber.value,
                                      'countryCode': controller.countryCode.value,
                                      'countryISOCode': controller.countryISOCode.value,
                                      'login_type': "phoneNumber",
                                    });
                                  }
                                }
                              });
                            }).catchError((error) {
                              ShowToastDialog.closeLoader();
                              ShowToastDialog.showToast("Code is Invalid");
                            });
                          } else {
                            ShowToastDialog.showToast("Please Enter OTP");
                          }
                        },
                      ),
                    ),
                    Center(
                      child: Text.rich(
                        textAlign: TextAlign.center,
                        TextSpan(
                          text: 'Didn’t Received OTP '.tr,
                          style: AppThemeData.mediumTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark500 : AppThemeData.neutral500),
                          children: <TextSpan>[
                            TextSpan(
                              recognizer: TapGestureRecognizer()..onTap = () => controller.resendOTP(),
                              text: 'Send Again'.tr,
                              style: AppThemeData.mediumTextStyle(
                                fontSize: 14,
                                color: themeChange.getThem() ? AppThemeData.infoDarkDefault : AppThemeData.infoDefault,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
