import 'dart:async';
import 'dart:convert';
import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/model/subscription_history_model.dart';
import 'package:cabme_driver/model/user_model.dart';
import 'package:cabme_driver/service/api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SubscriptionHistoryController extends GetxController {
  RxBool isLoading = true.obs;
  RxList<SubscriptionData> subscriptionHistoryList = <SubscriptionData>[].obs;
  Rx<UserModel> userModel = UserModel().obs;

  @override
  void onInit() {
    userModel.value = Constant.getUserData();
    getAllSubscriptionList();
    super.onInit();
  }

  Future<Null> getAllSubscriptionList() async {
    Map<String, dynamic> requestBody = {
      "driverId": userModel.value.userData!.id.toString(),
    };

    print(requestBody);
    await API.handleApiRequest(request: () => http.post(Uri.parse(API.getSubscriptionHistory), headers: API.headers, body: jsonEncode(requestBody)), showLoader: false).then(
      (value) async {
        if (value != null) {
          if (value['success'] == "Failed" || value['success'] == "ailed") {
            ShowToastDialog.showToast(value['error']);
            return null;
          } else {
            SubscriptionHistoryModel model = SubscriptionHistoryModel.fromJson(value);
            subscriptionHistoryList.value = model.data!;
          }
        }
      },
    );
    isLoading.value = false;
  }
}
