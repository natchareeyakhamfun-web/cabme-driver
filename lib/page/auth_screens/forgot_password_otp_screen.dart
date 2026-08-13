import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/controller/forgot_password_controller.dart';
import 'package:cabme_driver/page/auth_screens/login_screen.dart';
import 'package:cabme_driver/themes/app_them_data.dart';
import 'package:cabme_driver/themes/text_field_widget.dart';
import 'package:cabme_driver/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../widget/round_button_fill.dart';

class ForgotPasswordOtpScreen extends StatelessWidget {
  final String? email;

  const ForgotPasswordOtpScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: ForgotPasswordController(),
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
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Create New Password'.tr,
                      textAlign: TextAlign.start,
                      style: AppThemeData.boldTextStyle(
                          fontSize: 22, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Set a strong password to secure your account and get back on track.'.tr,
                      textAlign: TextAlign.start,
                      style: AppThemeData.mediumTextStyle(
                          fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark500 : AppThemeData.neutral500),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      'Enter OTP'.tr,
                      textAlign: TextAlign.center,
                      style: AppThemeData.semiBoldTextStyle(
                        fontSize: 14,
                        color: themeChange.getThem() ? AppThemeData.neutralDark700 : AppThemeData.neutral700,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Pinput(
                      scrollPadding: EdgeInsets.zero,
                      controller: controller.otpEditingController.value,
                      defaultPinTheme: PinTheme(
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        height: 55,
                        width: 55,
                        textStyle: AppThemeData.mediumTextStyle(
                            fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                          color: themeChange.getThem() ? AppThemeData.neutralDark100 : AppThemeData.neutral100,
                          border:
                              Border.all(color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300, width: 0.8),
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      length: 4,
                    ),
                    SizedBox(
                      height: 20,
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
                            () => controller.isPasswordShow.value
                                ? SvgPicture.asset("assets/icons/ic_hide.svg")
                                : SvgPicture.asset("assets/icons/ic_show.svg"),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFieldWidget(
                      controller: controller.conformPasswordController.value,
                      hintText: 'Enter Confirm Password',
                      title: 'Confirm Password',
                      obscureText: controller.isConformPasswordShow.value,
                      prefix: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: SvgPicture.asset("assets/icons/ic_lock_login.svg"),
                      ),
                      suffix: InkWell(
                        onTap: () {
                          if (controller.isConformPasswordShow.value) {
                            controller.isConformPasswordShow.value = false;
                          } else {
                            controller.isConformPasswordShow.value = true;
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Obx(
                            () => controller.isConformPasswordShow.value
                                ? SvgPicture.asset("assets/icons/ic_hide.svg")
                                : SvgPicture.asset("assets/icons/ic_show.svg"),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    RoundedButtonFill(
                      title: "Resent Password".tr,
                      height: 5.5,
                      color: AppThemeData.primaryDefault,
                      textColor: AppThemeData.neutral50,
                      onPress: () async {
                        if (controller.otpEditingController.value.text.trim().isEmpty) {
                          ShowToastDialog.showToast("Please enter OTP");
                        } else if (controller.passwordController.value.text.trim().isEmpty) {
                          ShowToastDialog.showToast("Please enter password");
                        } else if (controller.conformPasswordController.value.text.trim().isEmpty) {
                          ShowToastDialog.showToast("Please enter confirm password");
                        } else if (controller.passwordController.value.text.trim() !=
                            controller.conformPasswordController.value.text.trim()) {
                          ShowToastDialog.showToast("Password and confirm password do not match");
                        } else {
                          Map<String, String> bodyParams = {
                            'email': email.toString(),
                            'otp': controller.otpEditingController.value.text.trim(),
                            'new_password': controller.passwordController.value.text.trim(),
                            'confirm_password': controller.conformPasswordController.value.text.trim(),
                            'user_cat': "driver",
                          };
                          controller.resetPassword(bodyParams).then((value) {
                            if (value != null) {
                              if (value == true) {
                                Get.offAll(const LoginScreen(),
                                    duration: const Duration(milliseconds: 400), //duration of transitions, default 1 sec
                                    transition: Transition.rightToLeft);
                                ShowToastDialog.showToast("Password change successfully!");
                              } else {
                                ShowToastDialog.showToast("Please try again later");
                              }
                            }
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
