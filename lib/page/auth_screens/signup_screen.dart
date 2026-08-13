// ignore_for_file: must_be_immutable

import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/controller/sign_up_controller.dart';
import 'package:cabme_driver/page/auth_screens/login_screen.dart';
import 'package:cabme_driver/themes/app_them_data.dart';
import 'package:cabme_driver/utils/dark_theme_provider.dart';
import 'package:cabme_driver/widget/multi_select_dropdown.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../themes/text_field_widget.dart';
import '../../widget/round_button_fill.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<SignUpController>(
        init: SignUpController(),
        builder: (controller) {
          return Scaffold(
            resizeToAvoidBottomInset: true, // <-- IMPORTANT
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
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
                      'Start booking your rides in just a few taps.'.tr,
                      textAlign: TextAlign.center,
                      style: AppThemeData.mediumTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark500 : AppThemeData.neutral500),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Continue as a.'.tr,
                          textAlign: TextAlign.center,
                          style: AppThemeData.mediumTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark700 : AppThemeData.neutral700),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile<String>(
                                title: Text('Individual'.tr),
                                value: 'Individual',
                                groupValue: controller.selectedValue.value,
                                onChanged: (value) {
                                  controller.selectedValue.value = value!;
                                },
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<String>(
                                title: Text('Company'.tr),
                                value: 'Company',
                                groupValue: controller.selectedValue.value,
                                onChanged: (value) {
                                  controller.selectedValue.value = value!;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Service',
                          style: AppThemeData.semiBoldTextStyle(
                            fontSize: 14,
                            color: themeChange.getThem() ? AppThemeData.neutralDark700 : AppThemeData.neutral700,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        MultiSelectDropdown<dynamic>(
                          items: Constant.activeServices,
                          selectedItems: controller.selectedService,
                          hintText: "Select Service Types",
                          dialogTitle: 'Select Service Types',
                          initialSelectedItems: controller.selectedService,
                          labelSelector: (item) => item.toString().capitalizeString(),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFieldWidget(
                          controller: controller.firstNameController.value,
                          hintText: 'Enter First Name',
                          title: 'First Name',
                          prefix: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: SvgPicture.asset("assets/icons/ic_user.svg"),
                          ),
                        ),
                        TextFieldWidget(
                          controller: controller.lastNameController.value,
                          hintText: 'Enter Last Name',
                          title: 'Last Name',
                          prefix: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: SvgPicture.asset("assets/icons/ic_user.svg"),
                          ),
                        ),
                        TextFieldWidget(
                          controller: controller.emailController.value,
                          hintText: 'Enter Email Address',
                          title: 'Email Address',
                          enable: controller.loginType.value == "phoneNumber" ? true : false,
                          prefix: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: SvgPicture.asset("assets/icons/ic_email_login.svg"),
                          ),
                        ),
                        TextFieldWidget(
                          controller: controller.phoneNumber.value,
                          hintText: 'Enter Mobile Number',
                          title: 'Mobile Number',
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          ],
                          enable: controller.loginType.value == "phoneNumber" ? false : true,
                          prefix: CountryCodePicker(
                            onInit: (value) {
                              controller.countryCodeController.value.text = value?.dialCode ?? Constant.defaultCountryCode ?? '';
                              controller.countryISOCodeController.value.text = value?.code ?? Constant.defaultCountryCode ?? '';
                            },
                            onChanged: (value) {
                              controller.countryCodeController.value.text = value.dialCode.toString();
                              controller.countryISOCodeController.value.text = value.code ?? Constant.defaultCountryCode ?? '';
                            },
                            dialogTextStyle: TextStyle(
                              color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                              fontWeight: FontWeight.w500,
                              fontFamily: AppThemeData.medium,
                            ),
                            dialogBackgroundColor: themeChange.getThem() ? AppThemeData.neutralDark50 : AppThemeData.neutral50,
                            initialSelection: controller.countryISOCodeController.value.text,
                            comparator: (a, b) => b.name!.compareTo(a.name.toString()),
                            flagDecoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(2)),
                            ),
                            textStyle: TextStyle(
                              color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                              fontWeight: FontWeight.w500,
                              fontFamily: AppThemeData.medium,
                            ),
                            searchDecoration: InputDecoration(
                              iconColor: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                            ),
                            searchStyle: TextStyle(
                              color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                              fontWeight: FontWeight.w500,
                              fontFamily: AppThemeData.medium,
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
                      ],
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: RoundedButtonFill(
                title: "Create Account".tr,
                height: 5.5,
                color: AppThemeData.primaryDefault,
                textColor: AppThemeData.neutral50,
                onPress: () async {
                  FocusScope.of(context).unfocus();
                  if (controller.selectedService.isEmpty) {
                    ShowToastDialog.showToast("Please select the service type");
                  } else if (controller.firstNameController.value.text.isEmpty) {
                    ShowToastDialog.showToast("Please enter a first name");
                  } else if (controller.lastNameController.value.text.isEmpty) {
                    ShowToastDialog.showToast("Please enter a last name");
                  } else if (controller.emailController.value.text.isEmpty) {
                    ShowToastDialog.showToast("Please enter a email");
                  } else if (controller.phoneNumber.value.text.isEmpty) {
                    ShowToastDialog.showToast("Please enter a phone number");
                  } else if (controller.passwordController.value.text.isEmpty) {
                    ShowToastDialog.showToast("Please enter a password");
                  } else if (controller.passwordController.value.text.trim() != controller.conformPasswordController.value.text.trim()) {
                    ShowToastDialog.showToast("Password and conform password not match");
                  } else {
                    Map<String, String> bodyParams = {
                      'firstname': controller.firstNameController.value.text.trim().toString(),
                      'lastname': controller.lastNameController.value.text.trim().toString(),
                      'phone': controller.phoneNumber.value.text.trim(),
                      'country_code': controller.countryCodeController.value.text,
                      'country_iso_code': controller.countryISOCodeController.value.text,
                      'email': controller.emailController.value.text.trim(),
                      'password': controller.passwordController.value.text,
                      'login_type': controller.loginType.value,
                      'tonotify': 'yes',
                      'account_type': controller.selectedValue.value == "Company" ? "owner" : 'driver', // driver or customer or owner
                      'service_type': controller.selectedService.join(","), // driver or customer or owner
                    };
                    await controller.signUp(bodyParams).then((value) {
                      if (value != null) {
                        if (value.success == "success") {
                          ShowToastDialog.showToast("Account created successfully");
                          Get.offAll(LoginScreen());
                        } else {
                          ShowToastDialog.showToast(value.message);
                        }
                      }
                    });
                  }
                },
              ),
            ),
          );
        });
  }
}
