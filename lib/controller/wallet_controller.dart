import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as maths;

import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/model/bank_details_model.dart';
import 'package:cabme_driver/model/booking_mode.dart';
import 'package:cabme_driver/model/parcel_bokking_model.dart';
import 'package:cabme_driver/model/payStackURLModel.dart';
import 'package:cabme_driver/model/payment_setting_model.dart';
import 'package:cabme_driver/model/rental_booking_model.dart';
import 'package:cabme_driver/model/stripe_failed_model.dart';
import 'package:cabme_driver/model/trancation_model.dart';
import 'package:cabme_driver/model/user_model.dart';
import 'package:cabme_driver/model/withdrawal_transaction_model.dart';
import 'package:cabme_driver/model/xenditModel.dart';
import 'package:cabme_driver/page/booking_details_screens/booking_details_screen.dart';
import 'package:cabme_driver/page/booking_details_screens/parcel_details_screen.dart';
import 'package:cabme_driver/page/rental_details_screen/rental_details_screen.dart';
import 'package:cabme_driver/page/wallet/mercadopago_screen.dart';
import 'package:cabme_driver/page/wallet/midtrans_screen.dart';
import 'package:cabme_driver/page/wallet/orangePayScreen.dart';
import 'package:cabme_driver/page/wallet/payStackScreen.dart';
import 'package:cabme_driver/page/wallet/payfast_screen.dart';
import 'package:cabme_driver/page/wallet/paystack_url_generator.dart';
import 'package:cabme_driver/page/wallet/xenditScreen.dart';
import 'package:cabme_driver/service/api.dart';
import 'package:cabme_driver/utils/Preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../themes/app_them_data.dart';

class WalletController extends GetxController {
  RxBool isLoading = true.obs;
  RxDouble walletAmount = 0.0.obs;
  RxList<TransactionData> transactionList = <TransactionData>[].obs;
  RxList<WithdrawalTransactionData> withdrawalTransactionList = <WithdrawalTransactionData>[].obs;
  Rx<TextEditingController> amountController = TextEditingController().obs;
  Rx<TextEditingController> withDrawAmountController = TextEditingController().obs;

  Rx<TextEditingController> bankNameController = TextEditingController().obs;
  Rx<TextEditingController> branchController = TextEditingController().obs;
  Rx<TextEditingController> holderNameController = TextEditingController().obs;
  Rx<TextEditingController> accountNumberController = TextEditingController().obs;
  Rx<TextEditingController> ifcsCodeController = TextEditingController().obs;
  Rx<TextEditingController> informationController = TextEditingController().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    await getUserData();
    await getTransactionList();
    await getPaymentMethod();
    await getBankDetails();
    await getWithdrawalTransactionList();

    isLoading.value = false;
  }

  Rx<UserModel> userModel = UserModel().obs;
  Rx<PaymentSettingModel> paymentSettingModel = PaymentSettingModel().obs;
  RxString selectedPaymentMethod = "".obs;

  Future<void> getUserData() async {
    userModel.value = Constant.getUserData();
    Map<String, String> bodyParams = {
      'phone': userModel.value.userData!.phone.toString(),
      'country_code': userModel.value.userData!.countryCode.toString(),
      'country_iso_code': userModel.value.userData!.countryISOCode.toString(),
      'user_cat': "driver",
      'email': userModel.value.userData!.email.toString(),
      'login_type': userModel.value.userData!.loginType.toString(),
    };
    await API.handleApiRequest(request: () => http.post(Uri.parse(API.getProfileByPhone), headers: API.headers, body: jsonEncode(bodyParams)), showLoader: false).then(
      (value) {
        if (value != null) {
          if (value['success'] == "success" || value['success'] == "Success") {
            userModel.value = UserModel.fromJson(value);
            Preferences.setString(Preferences.user, jsonEncode(value));
            walletAmount.value = double.parse(userModel.value.userData!.amount.toString());
          } else {
            ShowToastDialog.showToast(value['message'] ?? "Something went wrong");
          }
        }
      },
    );
  }

  Future<void> getBookingDetails(String rideId) async {
    Map<String, dynamic> bodyParams = {
      'id_ride': rideId,
    };

    await API.handleApiRequest(request: () => http.post(Uri.parse(API.getBookingDetails), headers: API.headers, body: jsonEncode(bodyParams)), showLoader: true).then(
      (value) async {
        if (value != null) {
          if (value['success'] == "Failed" || value['success'] == "failed") {
            ShowToastDialog.showToast(value['error'] ?? "Booking data not found");
            return null;
          } else {
            BookingModel bookingData = BookingModel.fromJson(value);
            if (bookingData.data == null) {
              ShowToastDialog.showToast("Booking data not found");
              return;
            }
            Get.to(() => BookingDetailsScreen(), arguments: {"bookingModel": bookingData.data});
          }
        }
      },
    );
  }

  Future<void> getParcelDetails(String parcelId) async {
    Map<String, dynamic> bodyParams = {
      'id_parcel': parcelId,
    };

    print(bodyParams);
    await API.handleApiRequest(request: () => http.post(Uri.parse(API.getParcelDetail), headers: API.headers, body: jsonEncode(bodyParams)), showLoader: false).then(
      (value) async {
        if (value != null) {
          if (value['success'] == "Failed" || value['success'] == "failed") {
            ShowToastDialog.showToast(value['error'] ?? "Booking data not found");
            return null;
          } else {
            ParcelBookingModel bookingData = ParcelBookingModel.fromJson(value);
            if (bookingData.data == null) {
              ShowToastDialog.showToast("Booking data not found");
              return;
            }
            Get.to(ParcelDetailsScreen(), arguments: {"parcelBookingData": bookingData.data});
          }
        }
      },
    );
  }

  Future<void> getRentalDetails(String rentalId) async {
    Map<String, dynamic> bodyParams = {
      'id_rental': rentalId,
    };

    await API.handleApiRequest(request: () => http.post(Uri.parse(API.getRentalBookingDetails), headers: API.headers, body: jsonEncode(bodyParams)), showLoader: false).then(
      (value) async {
        if (value != null) {
          if (value['success'] == "Failed" || value['success'] == "failed") {
            ShowToastDialog.showToast(value['error'] ?? "Booking data not found");
            return null;
          } else {
            RentalBookingData rentalBookingData = RentalBookingData.fromJson(value['data']);
            Get.to(RentalDetailsScreen(), arguments: {"rentalBookingData": rentalBookingData});
          }
        }
      },
    );
  }

  Rx<BankDetailsModel> bankDetailsModel = BankDetailsModel().obs;

  Future<void> getBankDetails() async {
    userModel.value = Constant.getUserData();
    Map<String, String> bodyParams = {
      'id_driver': userModel.value.userData!.id.toString(),
    };
    await API.handleApiRequest(request: () => http.post(Uri.parse(API.bankDetails), headers: API.headers, body: jsonEncode(bodyParams)), showLoader: false).then(
      (value) {
        if (value != null) {
          if (value['success'] == "success" || value['success'] == "Success") {
            bankDetailsModel.value = BankDetailsModel.fromJson(value);
            if (bankDetailsModel.value.data != null) {
              bankNameController.value.text = bankDetailsModel.value.data!.bankName ?? '';
              branchController.value.text = bankDetailsModel.value.data!.branchName ?? '';
              holderNameController.value.text = bankDetailsModel.value.data!.holderName ?? '';
              accountNumberController.value.text = bankDetailsModel.value.data!.accountNo ?? '';
              informationController.value.text = bankDetailsModel.value.data!.otherInfo ?? '';
              ifcsCodeController.value.text = bankDetailsModel.value.data!.ifscCode ?? '';
            }
          }
        }
      },
    );
  }

  Future<void> submitBankDetails() async {
    userModel.value = Constant.getUserData();
    Map<String, String> bodyParams = {
      'id_driver': userModel.value.userData!.id.toString(),
      'bank_name': bankNameController.value.text,
      'branch_name': branchController.value.text,
      'holder_name': holderNameController.value.text,
      'account_no': accountNumberController.value.text,
      'information': informationController.value.text,
      'ifsc_code': ifcsCodeController.value.text,
    };
    await API.handleApiRequest(request: () => http.post(Uri.parse(API.addBankDetails), headers: API.headers, body: jsonEncode(bodyParams)), showLoader: false).then(
      (value) async {
        if (value != null) {
          if (value['success'] == "success" || value['success'] == "Success") {
            await getBankDetails();
            ShowToastDialog.showToast("Bank Details added successfully");
            Get.back();
          } else {
            ShowToastDialog.showToast(value['message'] ?? "Something went wrong");
          }
        }
      },
    );
  }

  Future<void> withdrawAmount() async {
    userModel.value = Constant.getUserData();
    Map<String, String> bodyParams = {
      'driver_id': userModel.value.userData!.id.toString(),
      'amount': withDrawAmountController.value.text,
    };
    await API.handleApiRequest(request: () => http.post(Uri.parse(API.withdrawalsRequest), headers: API.headers, body: jsonEncode(bodyParams)), showLoader: false).then(
      (value) async {
        if (value != null) {
          if (value['success'] == "success" || value['success'] == "Success") {
            await getWithdrawalTransactionList();
            ShowToastDialog.showToast("Withdrawal request submitted successfully");
            Get.back();
          } else {
            ShowToastDialog.showToast(value['message'] ?? "Something went wrong");
          }
        }
      },
    );
  }

  Future<dynamic> getPaymentMethod() async {
    await API.handleApiRequest(request: () => http.get(Uri.parse(API.paymentSetting), headers: API.headers), showLoader: false).then(
      (value) {
        if (value != null) {
          Preferences.setString(Preferences.paymentSetting, jsonEncode(value));
          paymentSettingModel.value = Constant.getPaymentSetting();
          if (paymentSettingModel.value.strip?.clientpublishableKey != null) {
            Stripe.publishableKey = paymentSettingModel.value.strip!.clientpublishableKey.toString();
            Stripe.merchantIdentifier = 'PoolMate';
            Stripe.instance.applySettings();
          }
          setRef();
          razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
          razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWaller);
          razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
        }
      },
    );
  }

  Future<dynamic> setAmount() async {
    final value = Constant.getGatewayValue(
      key: selectedPaymentMethod.value,
      property: "id_payment_method",
      model: paymentSettingModel.value,
    );

    Map<String, dynamic> bodyParams = {
      'user_id': Preferences.getInt(Preferences.userId),
      'user_type': "driver",
      'amount': amountController.value.text,
      'payment_method': value,
      'is_credited': 1,
      'note': "Wallet TopUp",
      'transaction_id': DateTime.now().microsecondsSinceEpoch.toString(),
    };

    await API.handleApiRequest(request: () => http.post(Uri.parse(API.amount), headers: API.headers, body: jsonEncode(bodyParams)), showLoader: false).then(
      (value) {
        if (value != null) {
          if (value['success'] == "success" || value['success'] == "Success") {
            ShowToastDialog.showToast("Amount added successfully");
            getUserData();
            getTransactionList();
            amountController.value.clear();
          } else {
            ShowToastDialog.showToast(value['message'] ?? "Something went wrong");
          }
        }
      },
    );
  }

  Future<void> getTransactionList() async {
    Map<String, dynamic> bodyParams = {
      'user_id': Preferences.getInt(Preferences.userId),
      'user_type': "driver",
    };
    await API.handleApiRequest(request: () => http.post(Uri.parse(API.getWalletHistory), body: jsonEncode(bodyParams), headers: API.headers), showLoader: false).then(
      (value) {
        if (value != null) {
          if (value['success'] == "success" || value['success'] == "Success") {
            TransactionModel model = TransactionModel.fromJson(value);
            if (model.data != null) {
              transactionList.value = model.data!;
            }
          } else {
            ShowToastDialog.showToast(value['message'] ?? "Something went wrong");
          }
        }
      },
    );
  }

  Future<void> getWithdrawalTransactionList() async {
    Map<String, dynamic> bodyParams = {
      'id_driver': Preferences.getInt(Preferences.userId),
    };
    await API.handleApiRequest(request: () => http.post(Uri.parse(API.withdrawalsList), body: jsonEncode(bodyParams), headers: API.headers), showLoader: false).then(
      (value) {
        if (value != null) {
          if (value['success'] == "success" || value['success'] == "Success") {
            WithdrawalTransactionModel model = WithdrawalTransactionModel.fromJson(value);
            if (model.data != null) {
              withdrawalTransactionList.value = model.data!;
            }
          } else {
            // ShowToastDialog.showToast(value['message'] ?? "Something went wrong");
          }
        }
      },
    );
  }

  void paypalPaymentSheet(String amount, BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => UsePaypal(
            sandboxMode: paymentSettingModel.value.payPal!.isLive == "yes" ? false : true,
            clientId: paymentSettingModel.value.payPal!.publicKey ?? '',
            secretKey: paymentSettingModel.value.payPal!.secretKey ?? '',
            returnURL: "com.parkme://paypalpay",
            cancelURL: "com.parkme://paypalpay",
            transactions: [
              {
                "amount": {
                  "total": amount,
                  "currency": "USD",
                  "details": {"subtotal": amount}
                },
              }
            ],
            note: "Contact us for any questions on your order.",
            onSuccess: (Map params) async {
              setAmount();
              ShowToastDialog.showToast("Payment Successful!!");
            },
            onError: (error) {
              Get.back();
              ShowToastDialog.showToast("Payment UnSuccessful!!");
            },
            onCancel: (params) {
              Get.back();
              ShowToastDialog.showToast("Payment UnSuccessful!!");
            }),
      ),
    );
  }

  // Strip
  Future<void> stripeMakePayment({required String amount}) async {
    log(double.parse(amount).toStringAsFixed(0));
    try {
      Map<String, dynamic>? paymentIntentData = await createStripeIntent(amount: amount);
      log("stripe Responce====>$paymentIntentData");

      if (paymentIntentData!.containsKey("error")) {
        Get.back();
        ShowToastDialog.showToast("Something went wrong, please contact admin.");
      } else {
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
                paymentIntentClientSecret: paymentIntentData['client_secret'],
                allowsDelayedPaymentMethods: false,
                googlePay: const PaymentSheetGooglePay(
                  merchantCountryCode: 'US',
                  testEnv: true,
                  currencyCode: "USD",
                ),
                customFlow: true,
                style: ThemeMode.system,
                appearance: PaymentSheetAppearance(
                  colors: PaymentSheetAppearanceColors(
                    primary: AppThemeData.primaryDefault,
                  ),
                ),
                merchantDisplayName: 'GoRide'));
        displayStripePaymentSheet(amount: amount);
      }
    } catch (e, s) {
      log("$e \n$s");
      ShowToastDialog.showToast("exception:$e \n$s");
    }
  }

  Future<void> displayStripePaymentSheet({required String amount}) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        ShowToastDialog.showToast("Payment successfully");
        setAmount();
      });
    } on StripeException catch (e) {
      var lo1 = jsonEncode(e);
      var lo2 = jsonDecode(lo1);
      StripePayFailedModel lom = StripePayFailedModel.fromJson(lo2);
      ShowToastDialog.showToast(lom.error.message);
    } catch (e) {
      ShowToastDialog.showToast(e.toString());
    }
  }

  Future createStripeIntent({required String amount}) async {
    try {
      Map<String, dynamic> body = {
        'amount': ((double.parse(amount) * 100).round()).toString(),
        'currency': "USD",
        'payment_method_types[]': 'card',
        "description": "Strip Payment",
        "shipping[name]": userModel.value.userData!.nom,
        "shipping[address][line1]": "510 Townsend St",
        "shipping[address][postal_code]": "98140",
        "shipping[address][city]": "San Francisco",
        "shipping[address][state]": "CA",
        "shipping[address][country]": "US",
      };
      log(paymentSettingModel.value.strip!.secretKey.toString());
      var stripeSecret = paymentSettingModel.value.strip!.secretKey;
      var response =
          await http.post(Uri.parse('https://api.stripe.com/v1/payment_intents'), body: body, headers: {'Authorization': 'Bearer $stripeSecret', 'Content-Type': 'application/x-www-form-urlencoded'});

      return jsonDecode(response.body);
    } catch (e) {
      log(e.toString());
    }
  }

  //mercadoo
  void mercadoPagoMakePayment({required BuildContext context, required String amount}) {
    makePreference(amount).then((result) async {
      if (result != {}) {
        log("mercadoPagoMakePayment URL :: ${paymentSettingModel.value.mercadopago?.isSandboxEnabled == "false" ? result['init_point'] : result['sandbox_init_point']}");
        Get.to(MercadoPagoScreen(initialURl: paymentSettingModel.value.mercadopago?.isSandboxEnabled == "false" ? result['init_point'] : result['sandbox_init_point']))!.then((value) {
          if (value) {
            ShowToastDialog.showToast("Payment Successful!!");
            setAmount();
          } else {
            ShowToastDialog.showToast("Payment UnSuccessful!!");
          }
        });
        // final bool isDone = await Navigator.push(context, MaterialPageRoute(builder: (context) => MercadoPagoScreen(initialURl: result['response']['init_point'])));
      } else {
        ShowToastDialog.showToast("Error while transaction!");
      }
    });
  }

  Future<Map<String, dynamic>> makePreference(String amount) async {
    final headers = {
      'Authorization': 'Bearer ${paymentSettingModel.value.mercadopago!.accesstoken ?? ''}',
      'Content-Type': 'application/json',
    };

    var body = jsonEncode({
      "items": [
        {
          "title": "Wallet TopUp",
          "quantity": 1,
          "currency_id": "BRL",
          "unit_price": double.parse(amount),
        }
      ],
      "payer": {"email": userModel.value.userData!.email ?? ''},
      "back_urls": {
        "failure": "${Constant.globalUrl}payment/failure",
        "pending": "${Constant.globalUrl}payment/pending",
        "success": "${Constant.globalUrl}payment/success",
      },
      "auto_return": "approved"
    });

    final response = await http.post(
      Uri.parse("https://api.mercadopago.com/checkout/preferences"),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      return {};
    }
  }

  ///PayStack Payment Method
  Future<void> payStackPayment(String totalAmount) async {
    await PayStackURLGen.payStackURLGen(amount: (double.parse(totalAmount) * 100).toString(), currency: "ZAR", secretKey: paymentSettingModel.value.payStack!.secretKey.toString()).then((value) async {
      if (value != null) {
        PayStackUrlModel payStackModel = value;
        Get.to(PayStackScreen(
          secretKey: paymentSettingModel.value.payStack!.secretKey.toString(),
          callBackUrl: paymentSettingModel.value.payStack!.callbackUrl.toString(),
          initialURl: payStackModel.data.authorizationUrl,
          amount: totalAmount,
          reference: payStackModel.data.reference,
        ))!
            .then((value) {
          if (value) {
            ShowToastDialog.showToast("Payment Successful!!");
            setAmount();
          } else {
            ShowToastDialog.showToast("Payment UnSuccessful!!");
          }
        });
      } else {
        ShowToastDialog.showToast("Something went wrong, please contact admin.");
      }
    });
  }

  //flutter wave Payment Method
  Future<Null> flutterWaveInitiatePayment({required BuildContext context, required String amount}) async {
    final url = Uri.parse('https://api.flutterwave.com/v3/payments');
    final headers = {
      'Authorization': 'Bearer ${paymentSettingModel.value.flutterWave!.secretKey}',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "tx_ref": _ref,
      "amount": amount,
      "currency": "NGN",
      "redirect_url": "${Constant.globalUrl}payment/success",
      "payment_options": "ussd, card, barter, payattitude",
      "customer": {
        "email": userModel.value.userData!.email.toString(),
        "phonenumber": userModel.value.userData!.phone, // Add a real phone number
        "name": userModel.value.userData!.prenom, // Add a real customer name
      },
      "customizations": {
        "title": "Payment for Services",
        "description": "Payment for XYZ services",
      }
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      Get.to(MercadoPagoScreen(initialURl: data['data']['link']))!.then((value) {
        if (value) {
          ShowToastDialog.showToast("Payment Successful!!");
          setAmount();
        } else {
          ShowToastDialog.showToast("Payment UnSuccessful!!");
        }
      });
    } else {
      print('Payment initialization failed: ${response.body}');
      return null;
    }
  }

  String? _ref;

  void setRef() {
    maths.Random numRef = maths.Random();
    int year = DateTime.now().year;
    int refNumber = numRef.nextInt(20000);
    if (Platform.isAndroid) {
      _ref = "AndroidRef$year$refNumber";
    } else if (Platform.isIOS) {
      _ref = "IOSRef$year$refNumber";
    }
  }

  // payFast
  void payFastPayment({required BuildContext context, required String amount}) {
    PayStackURLGen.getPayHTML(payFastSettingData: paymentSettingModel.value.payFast!, amount: amount.toString()).then((String? value) async {
      bool isDone = await Get.to(PayFastScreen(htmlData: value!, payFastSettingData: paymentSettingModel.value.payFast!));
      if (isDone) {
        Get.back();
        ShowToastDialog.showToast("Payment successfully");
        setAmount();
      } else {
        Get.back();
        ShowToastDialog.showToast("Payment Failed");
      }
    });
  }

  ///RazorPay payment function
  final Razorpay razorPay = Razorpay();

  void openCheckout({required amount, required orderId}) async {
    var options = {
      'key': paymentSettingModel.value.razorpay!.key,
      'amount': amount * 100,
      'name': 'PoolMate',
      'order_id': orderId,
      "currency": "INR",
      'description': 'wallet Topup',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {
        'contact': userModel.value.userData!.phone,
        'email': userModel.value.userData!.email,
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      razorPay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    // Get.back();
    ShowToastDialog.showToast("Payment Successful!!");
    setAmount();
  }

  void handleExternalWaller(ExternalWalletResponse response) {
    Get.back();
    ShowToastDialog.showToast("Payment Processing!! via");
  }

  void handlePaymentError(PaymentFailureResponse response) {
    Get.back();
    // RazorPayFailedModel lom = RazorPayFailedModel.fromJson(jsonDecode(response.message!.toString()));
    ShowToastDialog.showToast("Payment Failed!!");
  }

  Future<void> xenditPayment(context, amount) async {
    await createXenditInvoice(amount: amount).then((model) {
      if (model.id != null) {
        Get.to(() => XenditScreen(
                  initialURl: model.invoiceUrl ?? '',
                  transId: model.id ?? '',
                  apiKey: paymentSettingModel.value.xendit!.key!.toString(),
                ))!
            .then((value) {
          if (value == true) {
            ShowToastDialog.showToast("Payment Successful!!");
            setAmount();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Payment Unsuccessful!! \n"),
              backgroundColor: Colors.red,
            ));
          }
        });
      }
    });
  }

  Future<XenditModel> createXenditInvoice({required var amount}) async {
    const url = 'https://api.xendit.co/v2/invoices';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': generateBasicAuthHeader(paymentSettingModel.value.xendit!.key!.toString()),
      // 'Cookie': '__cf_bm=yERkrx3xDITyFGiou0bbKY1bi7xEwovHNwxV1vCNbVc-1724155511-1.0.1.1-jekyYQmPCwY6vIJ524K0V6_CEw6O.dAwOmQnHtwmaXO_MfTrdnmZMka0KZvjukQgXu5B.K_6FJm47SGOPeWviQ',
    };

    final body = jsonEncode({
      'external_id': const Uuid().v1(),
      'amount': amount,
      'payer_email': 'customer@domain.com',
      'description': 'Test - VA Successful invoice payment',
      'currency': 'IDR', //IDR, PHP, THB, VND, MYR
    });

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        XenditModel model = XenditModel.fromJson(jsonDecode(response.body));
        return model;
      } else {
        return XenditModel();
      }
    } catch (e) {
      return XenditModel();
    }
  }

  String generateBasicAuthHeader(String apiKey) {
    String credentials = '$apiKey:';
    String base64Encoded = base64Encode(utf8.encode(credentials));
    return 'Basic $base64Encoded';
  }

  static String accessToken = '';
  static String payToken = '';
  static String orderId = '';
  static String amount = '';

  Future<void> orangeMakePayment({required String amount, required BuildContext context}) async {
    reset();
    var id = const Uuid().v4();
    var paymentURL = await fetchToken(context: context, orderId: id, amount: amount, currency: 'USD');

    if (paymentURL.toString() != '') {
      Get.to(() => OrangeMoneyScreen(initialURl: paymentURL, accessToken: accessToken, amount: amount, orangePay: paymentSettingModel.value.orangePay!, orderId: orderId, payToken: payToken))!
          .then((value) {
        if (value != null) {
          if (value == true) {
            ShowToastDialog.showToast("Payment Successful!!");
            setAmount();
          }
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Payment Unsuccessful!! \n"),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future fetchToken({required String orderId, required String currency, required BuildContext context, required String amount}) async {
    String apiUrl = 'https://api.orange.com/oauth/v3/token';
    Map<String, String> requestBody = {
      'grant_type': 'client_credentials',
    };

    var response = await http.post(Uri.parse(apiUrl),
        headers: <String, String>{'Authorization': "Basic ${paymentSettingModel.value.orangePay!.key!}", 'Content-Type': 'application/x-www-form-urlencoded', 'Accept': 'application/json'},
        body: requestBody);

    // Handle the response
    print("================Responce Body : ${response.statusCode}");
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      print("================Responce Body : $responseData");
      accessToken = responseData['access_token'];
      // ignore: use_build_context_synchronously
      return await webpayment(context: context, amountData: amount, currency: currency, orderIdData: orderId);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Color(0xff635bff),
          content: Text(
            "Something went wrong, please contact admin.",
            style: TextStyle(fontSize: 17),
          )));

      return '';
    }
  }

  Future webpayment({required String orderIdData, required BuildContext context, required String currency, required String amountData}) async {
    orderId = orderIdData;
    amount = amountData;
    String apiUrl = paymentSettingModel.value.orangePay!.isSandboxEnabled! == "true"
        ? 'https://api.orange.com/orange-money-webpay/dev/v1/webpayment'
        : 'https://api.orange.com/orange-money-webpay/cm/v1/webpayment';
    Map<String, String> requestBody = {
      "merchant_key": paymentSettingModel.value.orangePay!.merchantKey ?? '',
      "currency": paymentSettingModel.value.orangePay!.isSandboxEnabled == "true" ? "OUV" : currency,
      "order_id": orderId,
      "amount": amount,
      "reference": 'Y-Note Test',
      "lang": "en",
      "return_url": paymentSettingModel.value.orangePay!.returnUrl!.toString(),
      "cancel_url": paymentSettingModel.value.orangePay!.cancelUrl!.toString(),
      "notif_url": paymentSettingModel.value.orangePay!.notifUrl!.toString(),
    };
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{'Authorization': 'Bearer $accessToken', 'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: json.encode(requestBody),
    );
    // Handle the response
    if (response.statusCode == 201) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData['message'] == 'OK') {
        payToken = responseData['pay_token'];
        return responseData['payment_url'];
      } else {
        return '';
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Color(0xff635bff),
          content: Text(
            "Something went wrong, please contact admin.",
            style: TextStyle(fontSize: 17),
          )));
      return '';
    }
  }

  static void reset() {
    accessToken = '';
    payToken = '';
    orderId = '';
    amount = '';
  }

  Future<void> midtransMakePayment({required String amount, required BuildContext context}) async {
    await createPaymentLink(amount: amount).then((url) {
      if (url != '') {
        Get.to(() => MidtransScreen(initialURl: url))!.then((value) {
          if (value == true) {
            ShowToastDialog.showToast("Payment Successful!!");
            setAmount();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Payment Unsuccessful!! \n"),
              backgroundColor: Colors.red,
            ));
          }
        });
      }
    });
  }

  Future<String> createPaymentLink({required var amount}) async {
    var orderId = const Uuid().v1();
    final url = Uri.parse(paymentSettingModel.value.midtrans!.isSandboxEnabled! == "true" ? 'https://api.sandbox.midtrans.com/v1/payment-links' : 'https://api.midtrans.com/v1/payment-links');

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': generateBasicAuthHeader(paymentSettingModel.value.midtrans!.key!),
      },
      body: jsonEncode({
        'transaction_details': {
          'order_id': orderId,
          'gross_amount': double.parse(amount.toString()).toInt(),
        },
        'usage_limit': 2,
        "callbacks": {"finish": "https://www.google.com?merchant_order_id=$orderId"},
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      print('Payment link created: ${responseData['payment_url']}');
      return responseData['payment_url'];
    } else {
      return '';
    }
  }
}
