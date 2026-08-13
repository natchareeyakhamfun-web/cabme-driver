// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/model/uploaded_document_model.dart';
import 'package:cabme_driver/model/user_model.dart';
import 'package:cabme_driver/service/api.dart';
import 'package:cabme_driver/utils/Preferences.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DocumentStatusController extends GetxController {
  RxBool isLoading = true.obs;

  Rx<UserModel> userModel = UserModel().obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    userModel.value = Constant.getUserData();
    await getDriverDocument();
    isLoading.value = false;
  }

  RxList<UploadedDocumentData> documentList = <UploadedDocumentData>[].obs;

  Future getDriverDocument() async {
    Map<String, String> bodyParams = {
      'driver_id': Preferences.getInt(Preferences.userId).toString(),
      'type': userModel.value.userData!.isOwner != null && userModel.value.userData!.isOwner == "true" ? "owner" : "driver",
    };
    await API.handleApiRequest(request: () => http.post(Uri.parse(API.getDriverUploadedDocument), body: jsonEncode(bodyParams), headers: API.headers), showLoader: false).then(
      (value) {
        if (value != null) {
          if (value['success'] == "Failed") {
            ShowToastDialog.showToast(value['error']);
            return null;
          } else {
            UploadedDocumentModel model = UploadedDocumentModel.fromJson(value);
            documentList.value = model.data ?? [];
          }
        }
      },
    );
  }

  Future<dynamic> updateDocument(String driverDocumentId, String path) async {
    List<http.MultipartFile> files = [];

    files.add(http.MultipartFile.fromBytes('attachment', File(path).readAsBytesSync(), filename: File(path).path.split('/').last));

    Map<String, String> fields = {
      'document_id': driverDocumentId,
      'driver_id': Preferences.getInt(Preferences.userId).toString(),
    };
    final response = await API.handleMultipartRequest(
      url: API.driverDocumentUpdate,
      headers: API.headers,
      fields: fields,
      files: files,
      showLoader: true,
    );
    if (response != null && response['success'] == 'Success' || response['success'] == 'success') {
      await getDriverDocument();
      ShowToastDialog.showToast("Document Updated Successfully".tr);
    }
  }
}
