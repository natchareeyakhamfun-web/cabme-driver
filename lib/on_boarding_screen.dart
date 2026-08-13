// ignore_for_file: deprecated_member_use, implicit_call_tearoffs

import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/controller/on_boarding_controller.dart';
import 'package:cabme_driver/themes/app_them_data.dart';
import 'package:cabme_driver/themes/responsive.dart';
import 'package:cabme_driver/utils/dark_theme_provider.dart';
import 'package:cabme_driver/utils/network_image_widget.dart';
import 'package:cabme_driver/widget/round_button_fill.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'page/auth_screens/login_screen.dart';
import 'utils/Preferences.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<OnBoardingController>(
      init: OnBoardingController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              controller.selectedPageIndex.value == 2
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: RoundedButtonFill(
                        title: "Skip".tr,
                        width: 24,
                        height: 5,
                        color: themeChange.getThem() ? AppThemeData.neutralDark100 : AppThemeData.neutral100,
                        textColor: themeChange.getThem() ? AppThemeData.neutralDark500 : AppThemeData.neutral500,
                        onPress: () {
                          Preferences.setBoolean(Preferences.isFinishOnBoardingKey, true);
                          Get.offAll(const LoginScreen());
                        },
                      ),
                    ),
            ],
          ),
          body: controller.isLoading.value
              ? Constant.loader(context)
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Expanded(
                          child: PageView.builder(
                              controller: controller.pageController,
                              onPageChanged: controller.selectedPageIndex.call,
                              itemCount: controller.onboardingModel.value.data!.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      NetworkImageWidget(
                                        imageUrl: controller.onboardingModel.value.data![index].image.toString(),
                                        width: Responsive.width(100, context),
                                        height: Responsive.height(30, context),
                                        fit: BoxFit.cover,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: List.generate(
                                            controller.onboardingModel.value.data!.length,
                                            (index) => Container(
                                              margin: const EdgeInsets.symmetric(horizontal: 4),
                                              width: controller.selectedPageIndex.value == index ? 38 : 10,
                                              height: 10,
                                              decoration: BoxDecoration(
                                                color: controller.selectedPageIndex.value == index
                                                    ? themeChange.getThem()
                                                        ? AppThemeData.primaryDefault
                                                        : AppThemeData.primaryDefault
                                                    : themeChange.getThem()
                                                        ? AppThemeData.neutralDark200
                                                        : AppThemeData.neutral200,
                                                borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        controller.onboardingModel.value.data![index].title.toString().tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                                          fontSize: 24,
                                          fontFamily: AppThemeData.bold,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        controller.onboardingModel.value.data![index].description.toString().tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: themeChange.getThem() ? AppThemeData.neutralDark500 : AppThemeData.neutral500,
                                          fontSize: 14,
                                          fontFamily: AppThemeData.regular,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                          child: RoundedButtonFill(
                            title: controller.selectedPageIndex.value ==  controller.onboardingModel.value.data!.length - 1  ? "Lets Get Started".tr : "Continue".tr,
                            color: AppThemeData.primaryDefault,
                            textColor: AppThemeData.neutral50,
                            onPress: () {
                              if (controller.selectedPageIndex.value ==  controller.onboardingModel.value.data!.length - 1) {
                                Preferences.setBoolean(Preferences.isFinishOnBoardingKey, true);
                                Get.offAll(const LoginScreen());
                              } else {
                                controller.pageController.jumpToPage(controller.selectedPageIndex.value + 1);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
