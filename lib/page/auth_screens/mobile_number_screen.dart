import 'dart:io';

import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/controller/phone_number_controller.dart';
import 'package:cabme_driver/themes/app_them_data.dart';
import 'package:cabme_driver/utils/dark_theme_provider.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../themes/text_field_widget.dart';
import '../../widget/round_button_fill.dart';

class MobileNumberScreen extends StatelessWidget {
  const MobileNumberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: PhoneNumberController(),
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
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Image.asset(
                        themeChange.getThem() ? "assets/images/login_image_2.png" : "assets/images/login_image.png",
                        height: 240,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
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
                            controller: controller.phoneNumber.value,
                            hintText: 'Enter mobile number',
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                            ],
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
                          SizedBox(
                            height: 20,
                          ),
                          RoundedButtonFill(
                            title: "Send OTP".tr,
                            height: 5.5,
                            color: AppThemeData.primaryDefault,
                            textColor: AppThemeData.neutral50,
                            onPress: () {
                              FocusScope.of(context).unfocus();
                              if (controller.phoneNumber.value.text.isNotEmpty) {
                                ShowToastDialog.showLoader("Code sending");
                                controller.sendCode();
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
                                  Get.back();
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(color: themeChange.getThem() ? AppThemeData.neutralDark200 : AppThemeData.neutral200, borderRadius: BorderRadius.circular(60)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(18),
                                        child: SvgPicture.asset("assets/icons/ic_email.svg"),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Email'.tr,
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
                                    SizedBox(
                                      height: 5,
                                    ),
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
                                                decoration:
                                                    BoxDecoration(color: themeChange.getThem() ? AppThemeData.neutralDark200 : AppThemeData.neutral200, borderRadius: BorderRadius.circular(60)),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(18),
                                                  child: SvgPicture.asset("assets/icons/ic_apple.svg"),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                'Apple'.tr,
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
            ),
          );
        });
  }
}
