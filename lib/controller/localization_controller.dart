import 'dart:async';

import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/service/api.dart';
import 'package:cabme_driver/utils/Preferences.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../model/language_model.dart';

class LocalizationController extends GetxController {
  RxList<LanguageData> languageList = <LanguageData>[].obs;
  Rx<LanguageData> selectedLanguage = LanguageData().obs;

  @override
  void onInit() {
    loadData();
    super.onInit();
  }

  void loadData() async {
    await getLanguage();
  }

  Future getLanguage() async {
    await API.handleApiRequest(request: () => http.get(Uri.parse(API.getLanguage), headers: API.authheader), showLoader: false).then(
          (value) {
        if (value != null) {
          if (value['success'] == "Success" || value['success'] == "success") {
            LanguageModel languageModel = LanguageModel.fromJson(value);

            languageList.addAll(languageModel.data!.where((element) => element.status == 'true'));

            if (Preferences.getString(Preferences.languageCodeKey).toString().isNotEmpty) {
              LanguageData pref = Constant.getLanguage();
              for (var element in languageList) {
                if (element.code == pref.code) {
                  selectedLanguage.value = element;
                }
              }
            }
          } else if (value['success'] == "Failed") {
            ShowToastDialog.showToast(value['error']);
          } else {
            ShowToastDialog.showToast('something_want_wrong_please_try_again_later');
            throw Exception('failed_to_load_album');
          }
        }
      },
    );
    return null;
  }
}
