// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/logdata.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

import '../service/api.dart';

class SendNotification {
  static final _scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

  static Future<String?> getAccessToken() async {
    try {
      final value = await API.handleApiRequest(
        request: () => http.get(Uri.parse(API.getServiceJson), headers: API.headers),
        showLoader: false,
      );
      showLog("API :: Service Account Response :: ${value.toString()}");
      if (value != null) {
        if (value['success'] == "failed" || value['success'] == "Failed") {
          ShowToastDialog.showToast(value['message']);
          return null;
        }
        // If the API returns a service account JSON, parse it
        try {
          final serviceAccountCredentials = ServiceAccountCredentials.fromJson(value);
          final client = await clientViaServiceAccount(serviceAccountCredentials, _scopes);
          return client.credentials.accessToken.data;
        } catch (e) {
          showLog("ServiceAccountCredentials parsing error: $e");
          return null;
        }
      } else {
        showLog("API :: Service Account Response is null");
        return null;
      }
    } catch (e) {
      showLog("getAccessToken error: $e");
      return null;
    }
  }

  static Future<bool> sendOneNotification(
      {required String token, required String title, required String body, required Map<String, dynamic> payload}) async {
    try {
      final String? accessToken = await getAccessToken();
      debugPrint("accessToken=======>");
      debugPrint(accessToken);

      if (accessToken != null) {
        // Ensure all data values are strings
        Map<String, String> data = {};
        payload.forEach((key, value) {
          if (value is Map || value is List) {
            data[key] = jsonEncode(value);
          } else {
            data[key] = value.toString();
          }
        });

        final response = await http.post(
          Uri.parse('https://fcm.googleapis.com/v1/projects/${Constant.senderId}/messages:send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
          body: jsonEncode(
            <String, dynamic>{
              'message': {
                'token': token,
                'notification': {'body': body, 'title': title},
                'data': data,
              }
            },
          ),
        );

        showLog("API :: URL :: ${'https://fcm.googleapis.com/v1/projects/${Constant.senderId}/messages:send'} ");
        showLog("API :: Request Body :: ${jsonEncode(
          <String, dynamic>{
            'message': {
              'token': token,
              'notification': {'body': body, 'title': title},
              'data': data,
            }
          },
        )} ");
        showLog("API :: Request Header :: ${<String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        }.toString()} ");
        showLog("API :: responseStatus :: ${response.statusCode} ");
        showLog("API :: responseBody :: ${response.body} ");
      }
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
