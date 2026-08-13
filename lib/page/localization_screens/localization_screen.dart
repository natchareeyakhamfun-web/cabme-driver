import 'dart:convert';

import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/controller/localization_controller.dart';
import 'package:cabme_driver/model/language_model.dart';
import 'package:cabme_driver/on_boarding_screen.dart';
import 'package:cabme_driver/service/localization_service.dart';
import 'package:cabme_driver/utils/Preferences.dart';
import 'package:cabme_driver/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../themes/app_them_data.dart';
import '../../widget/round_button_fill.dart';

class LocalizationScreens extends StatelessWidget {
  final String intentType;

  const LocalizationScreens({super.key, required this.intentType});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<LocalizationController>(
      init: LocalizationController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            actions: [
              if (intentType != "dashBoard")
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: RoundedButtonFill(
                    title: 'Skip'.tr,
                    width: 26,
                    height: 5,
                    textColor: themeChange.getThem() ? AppThemeData.neutralDark500 : AppThemeData.neutral500,
                    color: themeChange.getThem() ? AppThemeData.neutralDark100 : AppThemeData.neutral100,
                    onPress: () {
                      LanguageData languageModel = LanguageData(code: "en", isRtl: "no", language: "English");
                      Preferences.setString(Preferences.languageCodeKey, jsonEncode(languageModel.toJson()));
                      if (intentType == "dashBoard") {
                        ShowToastDialog.showToast("language_change_successfully".tr);
                      } else {
                        Get.offAll(const OnBoardingScreen(), transition: Transition.rightToLeft);
                      }
                    },
                  ),
                ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 6),
                    child: Text(
                      'Select Your Preferred Language'.tr,
                      style: AppThemeData.boldTextStyle(
                          fontSize: 22, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                    ),
                  ),
                  Text(
                    'Choose a language to personalize your CabME experience.'.tr,
                    style: AppThemeData.mediumTextStyle(
                        fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark500 : AppThemeData.neutral500),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    decoration: BoxDecoration(
                        color: themeChange.getThem() ? AppThemeData.neutralDark100 : AppThemeData.neutral100,
                        borderRadius: BorderRadius.all(Radius.circular(14))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.separated(
                        itemCount: controller.languageList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return Obx(
                                () => InkWell(
                              splashColor: Colors.transparent,
                              onTap: () {
                                controller.selectedLanguage.value = controller.languageList[index];
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(6),
                                                child: Image.network(
                                                  controller.languageList[index].flag.toString(),
                                                  height: 35,
                                                  width: 50,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Align(
                                                  alignment: Alignment.bottomRight,
                                                  child: Text(
                                                    controller.languageList[index].language.toString(),
                                                    style: AppThemeData.mediumTextStyle(
                                                        color:
                                                        themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                                                        fontSize: 16),
                                                  ))
                                            ],
                                          ),
                                        ),
                                        controller.languageList[index].code == controller.selectedLanguage.value.code
                                            ? SvgPicture.asset(
                                          "assets/icons/ic_radio_selected.svg",
                                        )
                                            : SvgPicture.asset(
                                          "assets/icons/ic_radio_unselected.svg",
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Divider(color: themeChange.getThem() ? AppThemeData.neutralDark200 : AppThemeData.neutral200),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
              child: RoundedButtonFill(
                title: intentType == "dashBoard" ? 'Save'.tr : 'Continue'.tr,
                width: 50,
                height: 5,
                textColor: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                color: themeChange.getThem() ? AppThemeData.primaryDarkDefault : AppThemeData.primaryDefault,
                onPress: () {
                  LocalizationService().changeLocale(controller.selectedLanguage.value.code.toString());
                  Preferences.setString(Preferences.languageCodeKey, jsonEncode(controller.selectedLanguage.value));

                  if (intentType == "dashBoard") {
                    ShowToastDialog.showToast("Language save successfully".tr);
                  } else {
                    Get.offAll(const OnBoardingScreen());
                  }
                },
              )),
        );
      },
    );
  }
}