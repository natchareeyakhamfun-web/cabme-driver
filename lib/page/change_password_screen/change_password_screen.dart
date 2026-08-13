
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/controller/change_password_controller.dart';
import 'package:cabme_driver/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../themes/app_them_data.dart';
import '../../themes/text_field_widget.dart';
import '../../widget/round_button_fill.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: ChangePasswordController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Forgot Password'.tr,
                textAlign: TextAlign.center,
                style: AppThemeData.boldTextStyle(fontSize: 18, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
              ),
              titleSpacing: 0,
              centerTitle: false,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                children: [
                  TextFieldWidget(
                    controller: controller.currentPasswordController.value,
                    hintText: 'Enter Current Password',
                    title: 'Current Password',
                    obscureText: controller.isCurrentPasswordShow.value,
                    prefix: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: SvgPicture.asset("assets/icons/ic_lock_login.svg"),
                    ),
                    suffix: InkWell(
                      onTap: () {
                        if (controller.isCurrentPasswordShow.value) {
                          controller.isCurrentPasswordShow.value = false;
                        } else {
                          controller.isCurrentPasswordShow.value = true;
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Obx(
                          () => controller.isCurrentPasswordShow.value ? SvgPicture.asset("assets/icons/ic_hide.svg") : SvgPicture.asset("assets/icons/ic_show.svg"),
                        ),
                      ),
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
                          () => controller.isConformPasswordShow.value ? SvgPicture.asset("assets/icons/ic_hide.svg") : SvgPicture.asset("assets/icons/ic_show.svg"),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40,horizontal: 20),
              child: RoundedButtonFill(
                title: "Save Changes".tr,
                height: 5.5,
                color: AppThemeData.primaryDefault,
                textColor: AppThemeData.neutral50,
                onPress: () async {
                  if (controller.currentPasswordController.value.text.isEmpty) {
                   ShowToastDialog.showToast('Please enter current password'.tr);
                  } else if (controller.passwordController.value.text.isEmpty) {
                    ShowToastDialog.showToast('Please enter new password'.tr);
                  } else if (controller.conformPasswordController.value.text.isEmpty) {
                    ShowToastDialog.showToast('Please enter confirm password'.tr);
                  } else if (controller.passwordController.value.text != controller.conformPasswordController.value.text) {
                    ShowToastDialog.showToast('New password and confirm password do not match'.tr);
                  } else {
                    await controller.changePassword();
                  }
                },
              ),
            ),
          );
        });
  }
}
