import 'dart:convert';
import 'dart:io';

import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/controller/login_conroller.dart';
import 'package:cabme_driver/model/user_model.dart';
import 'package:cabme_driver/page/auth_screens/forgot_password.dart';
import 'package:cabme_driver/page/auth_screens/mobile_number_screen.dart';
import 'package:cabme_driver/page/dashboard_screen.dart';
import 'package:cabme_driver/page/owner_dashboard_screen.dart';
import 'package:cabme_driver/service/api.dart';
import 'package:cabme_driver/utils/Preferences.dart';
import 'package:cabme_driver/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../themes/app_them_data.dart';
import '../../themes/round_button_fill.dart';
import '../../themes/text_field_widget.dart';
import '../subscription_plan_screen/subscription_plan_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: LoginController(),
        builder: (controller) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Image.asset(
                      themeChange.getThem() ? "assets/images/login_image_2.png" : "assets/images/login_image.png",
                      height: 220,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          'Let’s get you started'.tr,
                          textAlign: TextAlign.center,
                          style: AppThemeData.boldTextStyle(fontSize: 22, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Use phone or social account'.tr,
                          textAlign: TextAlign.center,
                          style: AppThemeData.mediumTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark500 : AppThemeData.neutral500),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFieldWidget(
                          controller: controller.emailController.value,
                          hintText: 'Enter Email Address',
                          title: 'Email Address',
                          prefix: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: SvgPicture.asset("assets/icons/ic_email_login.svg"),
                          ),
                        ),
                        TextFieldWidget(
                          controller: controller.passwordController.value,
                          hintText: 'Enter Password',
                          title: 'Password',
                          obscureText: controller.isPasswordShow.value,
                          prefix: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: SvgPicture.asset("assets/icons/ic_lock_login.svg"),
                          ),
                          suffix: InkWell(
                            onTap: () {
                              if (controller.isPasswordShow.value) {
                                controller.isPasswordShow.value = false;
                              } else {
                                controller.isPasswordShow.value = true;
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18),
                              child: Obx(
                                () => controller.isPasswordShow.value ? SvgPicture.asset("assets/icons/ic_hide.svg") : SvgPicture.asset("assets/icons/ic_show.svg"),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              Get.to(() => ForgotPasswordScreen());
                            },
                            child: Text(
                              'Forgot Password'.tr,
                              textAlign: TextAlign.center,
                              style: AppThemeData.semiBoldTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.infoDarkDefault : AppThemeData.infoDefault),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        RoundedButtonFill(
                          title: "Log in".tr,
                          height: 5.5,
                          color: AppThemeData.primaryDefault,
                          textColor: AppThemeData.neutral50,
                          onPress: () async {
                            FocusScope.of(context).unfocus();
                            if (controller.emailController.value.text.isEmpty) {
                              ShowToastDialog.showToast('Please enter the email address');
                            } else if (controller.passwordController.value.text.isEmpty) {
                              ShowToastDialog.showToast('Please enter the password');
                            } else {
                              FocusScope.of(context).unfocus();
                              Map<String, String> bodyParams = {
                                'email': controller.emailController.value.text.trim(),
                                'password': controller.passwordController.value.text,
                                'user_cat': "driver",
                              };
                              await controller.loginAPI(bodyParams).then((value) async {
                                if (value != null) {
                                  await Preferences.setString(Preferences.user, jsonEncode(value));
                                  await Preferences.setBoolean(Preferences.isLogin, true);
                                  Preferences.setString(Preferences.accesstoken, value.userData!.accesstoken.toString());
                                  API.headers['accesstoken'] = value.userData!.accesstoken.toString();
                                  UserData? userData = value.userData;
                                  await Preferences.setInt(Preferences.userId, int.parse(userData!.id.toString()));
                                  bool isPlanExpired = false;

                                  /// Case 1: Admin Commission = 'no' and Subscription model = false
                                  if (Constant.adminCommission?.statut == "no" && Constant.subscriptionModel == false) {
                                    if (userData.isOwner == "true") {
                                      Get.offAll(() => OwnerDashboardScreen(), transition: Transition.rightToLeft);
                                    } else {
                                      Get.offAll(() => DashboardScreen(), transition: Transition.rightToLeft);
                                    }
                                    return;
                                  }

                                  /// Case 3: Owner’s Driver (driver under an owner)
                                  bool isOwnerDriver = userData.isOwner == "false" && userData.ownerId != null && userData.ownerId!.isNotEmpty;
                                  if (isOwnerDriver) {
                                    Get.offAll(() => DashboardScreen(), transition: Transition.rightToLeft);
                                    return;
                                  }

                                  /// Case 2: Individual Driver (no ownerId) → Check subscription
                                  bool isIndividualDriver = userData.isOwner == "false" && (userData.ownerId == null || userData.ownerId!.isEmpty);

                                  if (isIndividualDriver || userData.isOwner == "true") {
                                    // Check subscription for Owner OR Individual Driver
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
                                }
                              });
                            }
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Divider(
                                color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300,
                              )),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'OR CONTINUE WITH'.tr,
                                  textAlign: TextAlign.center,
                                  style: AppThemeData.mediumTextStyle(fontSize: 12, color: themeChange.getThem() ? AppThemeData.neutralDark500 : AppThemeData.neutral500),
                                ),
                              ),
                              Expanded(
                                  child: Divider(
                                color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300,
                              )),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Get.to(() => MobileNumberScreen());
                              },
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(color: themeChange.getThem() ? AppThemeData.neutralDark200 : AppThemeData.neutral200, borderRadius: BorderRadius.circular(60)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(18),
                                      child: SvgPicture.asset("assets/icons/ic_phone_login.svg"),
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Text(
                                    'Phone Number'.tr,
                                    textAlign: TextAlign.center,
                                    style: AppThemeData.semiBoldTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 40,
                            ),
                            InkWell(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                controller.loginWithGoogle();
                              },
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(color: themeChange.getThem() ? AppThemeData.neutralDark200 : AppThemeData.neutral200, borderRadius: BorderRadius.circular(60)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(18),
                                      child: SvgPicture.asset("assets/icons/ic_google.svg"),
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Text(
                                    'Google'.tr,
                                    textAlign: TextAlign.center,
                                    style: AppThemeData.semiBoldTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                  ),
                                ],
                              ),
                            ),
                            Platform.isIOS
                                ? Row(
                                    children: [
                                      SizedBox(
                                        width: 40,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                          controller.loginWithApple();
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(color: themeChange.getThem() ? AppThemeData.neutralDark200 : AppThemeData.neutral200, borderRadius: BorderRadius.circular(60)),
                                              child: Padding(
                                                padding: const EdgeInsets.all(18),
                                                child: SvgPicture.asset("assets/icons/ic_apple.svg"),
                                              ),
                                            ),
                                            SizedBox(height: 5,),
                                            Text(
                                              'Google'.tr,
                                              textAlign: TextAlign.center,
                                              style: AppThemeData.semiBoldTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox(),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
