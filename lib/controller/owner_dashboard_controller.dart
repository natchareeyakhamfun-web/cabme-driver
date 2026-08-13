import 'dart:convert';

import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/model/user_model.dart';
import 'package:cabme_driver/page/booking_screens/booking_screen.dart';
import 'package:cabme_driver/page/home_screen/owner_home_screen.dart';
import 'package:cabme_driver/page/profile_screen/profile_screen.dart';
import 'package:cabme_driver/page/wallet_screen/wallet_screen.dart';
import 'package:cabme_driver/service/api.dart';
import 'package:cabme_driver/utils/Preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class OwnerDashboardController extends GetxController {
  RxInt selectedIndex = 0.obs;
  RxBool isLoading = true.obs;
  RxList pageList = [].obs;
  Rx<UserModel> userModel = UserModel().obs;
  DateTime? currentBackPressTime;
  RxBool canPopNow = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    userModel.value = Constant.getUserData();
    pageList.value = [
      OwnerHomeScreen(),
      BookingScreen(),
      WalletScreen(),
      ProfileScreen(),
    ];
    getSettings();
    super.onInit();
  }

  Future<void> getSettings() async {
    await updateToken();
    isLoading.value = false;
  }

  Future<void> updateToken() async {
    // use the returned token to send messages to users from your custom server
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      updateFCMToken(token);
    }
  }

  Future updateFCMToken(String token) async {
    Map<String, dynamic> bodyParams = {'user_id': Preferences.getInt(Preferences.userId), 'fcm_id': token, 'device_id': "", 'user_cat': userModel.value.userData!.userCat};
    await API.handleApiRequest(request: () => http.post(Uri.parse(API.updateToken), headers: API.headers, body: jsonEncode(bodyParams)), showLoader: false);
  }
}
