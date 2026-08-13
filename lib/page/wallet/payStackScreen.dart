// ignore_for_file: file_names, must_be_immutable

import 'dart:async';
import 'dart:convert';

import 'package:cabme_driver/constant/logdata.dart';
import 'package:cabme_driver/themes/app_them_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class PayStackScreen extends StatefulWidget {
  final String initialURl;
  final String reference;
  final String amount;
  final String secretKey;
  final String callBackUrl;

  const PayStackScreen({
    super.key,
    required this.initialURl,
    required this.reference,
    required this.amount,
    required this.secretKey,
    required this.callBackUrl,
  });

  @override
  State<PayStackScreen> createState() => _PayStackScreenState();
}

class _PayStackScreenState extends State<PayStackScreen> {
  WebViewController controller = WebViewController();

  @override
  void initState() {
    initController();
    super.initState();
  }

  void initController() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest navigation) async {
            debugPrint("--->2 ${navigation.url}");
            // if (Platform.isIOS) {
            //   debugPrint("--->22 ${navigation.url}");
            if (navigation.url.contains('success')) {
              final isDone = await payStackVerifyTransaction(
                  secretKey: widget.secretKey,
                  reference: widget.reference,
                  amount: widget.amount);
              Get.back(result: isDone);
            } else if (navigation.url.contains('failed')) {
              Get.back(result: false);
            }
            // } else {
            //   debugPrint("--->222 ${navigation.url}");
            //   if (navigation.url == '${widget.callBackUrl}?trxref=${widget.reference}&reference=${widget.reference}') {
            //     final isDone = await payStackVerifyTransaction(secretKey: widget.secretKey, reference: widget.reference, amount: widget.amount);
            //     Get.back(result: isDone);
            //     //close webview
            //   }
            // }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.initialURl));
  }

  Future<bool> payStackVerifyTransaction({
    required String reference,
    required String secretKey,
    required String amount,
  }) async {
    final url = "https://api.paystack.co/transaction/verify/$reference";
    var response = await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer $secretKey",
    });
    showLog("API :: URL :: $url");
    showLog("API :: Request Header :: ${{
      "Authorization": "Bearer $secretKey",
    }.toString()} ");
    showLog("API :: responseStatus :: ${response.statusCode} ");
    showLog("API :: responseBody :: ${response.body} ");
    final data = jsonDecode(response.body);
    if (data["status"] == true) {
      if (data["message"] == "Verification successful") {}
    }

    return data["status"];

    //PayPalClientSettleModel.fromJson(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppThemeData.primaryDefault,
          centerTitle: false,
          leading: GestureDetector(
            onTap: () {
              _showMyDialog(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          )),

      body: WebViewWidget(controller: controller),
    );
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancel Payment'.tr),
          content: SingleChildScrollView(
            child: Text('Are you want to cancel Payment?'.tr),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel'.tr,
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Get.back();
                Get.back(result: false);
              },
            ),
            TextButton(
              child: Text(
                'Continue'.tr,
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }
}
