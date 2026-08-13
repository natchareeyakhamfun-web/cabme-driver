import 'dart:async';

import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/service/api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class TermsOfServiceController extends GetxController {
  @override
  void onInit() {
    getTermsOfService();

    super.onInit();
  }

  var termsData = ''.obs;

  Future<dynamic> getTermsOfService() async {
    await API.handleApiRequest(request: () => http.get(Uri.parse(API.termsOfCondition), headers: API.headers), showLoader: false).then(
          (value) {
        if (value != null) {
          if (value['success'] == "Failed") {
            ShowToastDialog.showToast(value['error']);
            return null;
          } else {
            termsData.value = value['data']['terms'];
          }
        }
      },
    );
  }
}
