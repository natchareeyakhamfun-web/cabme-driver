import 'dart:convert';
import 'dart:developer';
import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/model/rental_booking_model.dart';
import 'package:cabme_driver/model/user_model.dart';
import 'package:cabme_driver/service/api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RentalDetailsController extends GetxController {
  RxBool isLoading = true.obs;

  Rx<RentalBookingData> rentalBookingData = RentalBookingData().obs;

  Rx<DateTime> startDate = DateTime.now().obs;
  Rx<DateTime> endDate = DateTime.now().obs;
  Rx<UserModel> userModel = UserModel().obs;

  @override
  void onInit() {
    getArguments();
    // TODO: implement onInit
    super.onInit();
  }

  Future<void> getArguments() async {
    userModel.value = Constant.getUserData();
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      rentalBookingData.value = argumentData['rentalBookingData'];
      startDate.value = DateTime.parse('${rentalBookingData.value.startDate} ${rentalBookingData.value.startTime}');
      endDate.value = DateTime.parse('${rentalBookingData.value.endDate} ${rentalBookingData.value.endTime}');

      setBookingData(rentalBookingData.value);
      await getParcelBookingData();
    }
    log("===>${userModel.toJson()}");
    isLoading.value = false;
  }

  Future<void> getParcelBookingData() async {
    Map<String, dynamic> bodyParams = {
      'id_rental': rentalBookingData.value.id,
    };

    await API.handleApiRequest(request: () => http.post(Uri.parse(API.getRentalBookingDetails), headers: API.headers, body: jsonEncode(bodyParams)), showLoader: false).then(
      (value) async {
        if (value != null) {
          if (value['success'] == "Failed" || value['success'] == "failed") {
            ShowToastDialog.showToast(value['error'] ?? "Booking data not found");
            return null;
          } else {
            setBookingData(RentalBookingData.fromJson(value['data']));
          }
        }
      },
    );
  }

  void setBookingData(RentalBookingData booking) {
    rentalBookingData.value = booking;
    calculateTotalAmount();
  }

  RxString subTotal = "0.0".obs;
  RxString discount = "0.0".obs;
  RxString taxAmount = "0.0".obs;
  RxString totalAmount = "0.0".obs;

  void calculateTotalAmount() {
    taxAmount = "0.0".obs;
    subTotal.value = rentalBookingData.value.amount.toString();
    if (rentalBookingData.value.discountType != null) {
      discount.value = Constant.calculateDiscountOrder(amount: subTotal.value, offerModel: rentalBookingData.value.discountType).toString();
    }
    for (var element in rentalBookingData.value.tax!) {
      taxAmount.value = (double.parse(taxAmount.value) + Constant().calculateTax(amount: ((double.parse(subTotal.value)) - (double.parse(discount.value))).toString(), taxModel: element))
          .toStringAsFixed(int.tryParse(Constant.decimal.toString()) ?? 2);
    }

    totalAmount.value = ((double.parse(subTotal.value) - (double.parse(discount.value))) + double.parse(taxAmount.value)).toStringAsFixed(int.tryParse(Constant.decimal.toString()) ?? 2);
    update();
  }
}
