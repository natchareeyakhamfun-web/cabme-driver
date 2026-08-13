import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/controller/forgot_password_controller.dart';
import 'package:cabme_driver/page/auth_screens/forgot_password_otp_screen.dart';
import 'package:cabme_driver/themes/app_them_data.dart';
import 'package:cabme_driver/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../themes/text_field_widget.dart';
import '../../widget/round_button_fill.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Forgot Your Password?'.tr,
                      textAlign: TextAlign.start,
                      style: AppThemeData.boldTextStyle(
                          fontSize: 22, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Don’t worry! Enter your email address. we’ll help you reset your password.'.tr,
                      textAlign: TextAlign.start,
                      style: AppThemeData.mediumTextStyle(
                          fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark500 : AppThemeData.neutral500),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    TextFieldWidget(
                      controller: controller.emailTextEditController.value,
                      hintText: 'Enter Email Address',
                      title: 'Email Address',
                      prefix: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: SvgPicture.asset("assets/icons/ic_email_login.svg"),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RoundedButtonFill(
                      title: "Send Otp".tr,
                      height: 5.5,
                      color: AppThemeData.primaryDefault,
                      textColor: AppThemeData.neutral50,
                      onPress: () async {
                        if (controller.emailTextEditController.value.text.isEmpty) {
                          ShowToastDialog.showToast("Please enter email");
                        } else {
                          Map<String, String> bodyParams = {
                            'email': controller.emailTextEditController.value.text.trim(),
                            'user_cat': "driver",
                          };
                          controller.sendEmail(bodyParams).then((value) {
                            if (value != null) {
                              if (value == true) {
                                Get.to(() => ForgotPasswordOtpScreen(email: controller.emailTextEditController.value.text.trim()),
                                    duration: const Duration(milliseconds: 400), transition: Transition.rightToLeft);
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
