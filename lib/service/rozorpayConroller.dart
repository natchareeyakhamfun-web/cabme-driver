import 'dart:convert';
import 'dart:developer';
import 'package:cabme_driver/model/payment_setting_model.dart';
import 'package:cabme_driver/model/razorpay_gen_userid_model.dart';
import 'package:http/http.dart' as http;


class RazorPayController {
  Future<CreateRazorPayOrderModel?> createOrderRazorPay({required String amount, required RazorpayModel? razorpayModel}) async {
    final String orderId = DateTime.now().millisecondsSinceEpoch.toString();
    RazorpayModel razorPayData = razorpayModel!;
    String url = "https://api.razorpay.com/v1/orders";
    final String basicAuth = 'Basic ${base64Encode(utf8.encode('${razorPayData.key}:${razorPayData.secretKey}'))}';
    print(orderId);
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': basicAuth,
      },
      body: jsonEncode({
        "amount": (double.parse(amount) * 100).toStringAsFixed(0),
        "currency": "INR",
      }),
    );
    log("https://api.razorpay.com/v1/orders :: ${response.body}");
    if (response.statusCode == 500) {
      return null;
    } else {
      final data = jsonDecode(response.body);
      print(data);

      return CreateRazorPayOrderModel.fromJson(data);
    }
  }
}
