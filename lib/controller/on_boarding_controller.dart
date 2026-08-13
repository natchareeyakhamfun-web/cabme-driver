import 'dart:async';
import 'package:cabme_driver/model/onboarding_model.dart';
import 'package:cabme_driver/service/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class OnBoardingController extends GetxController {
  var selectedPageIndex = 0.obs;

  RxBool isLoading = true.obs;
  var pageController = PageController();

  Rx<OnboardingModel> onboardingModel = OnboardingModel().obs;
  RxList<String> localImage = ['assets/images/intro_1.png', 'assets/images/intro_2.png'].obs;

  @override
  void onInit() {
    getBoardingData();
    super.onInit();
  }

  Future<dynamic> getBoardingData() async {
    isLoading.value = true;
    await API.handleApiRequest(request: () => http.get(Uri.parse(API.onBoarding), headers: API.headers),showLoader: false).then(
          (value) {
        if (value != null) {
          onboardingModel.value = OnboardingModel.fromJson(value);
        }
      },
    );

    isLoading.value = false;
  }
}
