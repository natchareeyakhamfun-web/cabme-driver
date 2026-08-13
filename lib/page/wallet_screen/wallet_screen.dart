import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/controller/wallet_controller.dart';
import 'package:cabme_driver/model/razorpay_gen_userid_model.dart';
import 'package:cabme_driver/model/trancation_model.dart';
import 'package:cabme_driver/model/withdrawal_transaction_model.dart';
import 'package:cabme_driver/service/rozorpayConroller.dart';
import 'package:cabme_driver/themes/responsive.dart';
import 'package:cabme_driver/themes/round_button_fill.dart';
import 'package:cabme_driver/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../themes/app_them_data.dart';
import '../../themes/text_field_widget.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: WalletController(),
        builder: (controller) {
          return DefaultTabController(
            length: 2, // Number of tabs
            child: Scaffold(
              body: controller.isLoading.value
                  ? Constant.loader(context)
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: Responsive.width(100, context),
                          height: Responsive.width(75, context),
                          decoration: BoxDecoration(
                              image: DecorationImage(image: AssetImage("assets/images/wallet_bg.png"), fit: BoxFit.fitHeight)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 30),
                                child: Text(
                                  'My Wallet'.tr,
                                  textAlign: TextAlign.start,
                                  style: AppThemeData.boldTextStyle(
                                      fontSize: 24, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                ),
                              ),
                              Center(
                                child: Column(
                                  children: [
                                    Text(
                                      'Wallet Amount'.tr,
                                      textAlign: TextAlign.center,
                                      style: AppThemeData.mediumTextStyle(
                                          fontSize: 14,
                                          color: themeChange.getThem() ? AppThemeData.neutralDark700 : AppThemeData.neutral700),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      Constant().amountShow(amount: controller.walletAmount.value.toString()).tr,
                                      textAlign: TextAlign.center,
                                      style: AppThemeData.boldTextStyle(
                                          fontSize: 36,
                                          color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                    ),
                                    SizedBox(height: 30),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: RoundedButtonFill(
                                              title: "Top up Wallet".tr,
                                              height: 5.5,
                                              width: 45,
                                              color: AppThemeData.accentDefault,
                                              textColor: AppThemeData.neutral50,
                                              onPress: () async {
                                                paymentBottomSheet(context, themeChange, controller);
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: RoundedButtonFill(
                                              title: "Withdraw".tr,
                                              height: 5.5,
                                              width: 45,
                                              color: AppThemeData.successDefault,
                                              textColor: AppThemeData.neutral50,
                                              onPress: () async {
                                                if (controller.bankDetailsModel.value.data == null) {
                                                  addBankBottomSheet(context, themeChange, controller);
                                                } else {
                                                  withdrawBottomSheet(context, themeChange, controller);
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        TabBar(
                          labelColor: Colors.blue,
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: Colors.blue,
                          tabs: [
                            Tab(text: 'Transaction History'.tr),
                            Tab(text: 'Withdrawal History'.tr),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color: themeChange.getThem() ? AppThemeData.neutralDark200 : AppThemeData.neutral200,
                                            width: 1,
                                          ),
                                        ),
                                        child: controller.transactionList.isEmpty
                                            ? Constant.showEmptyView(message: "Transaction Details not found".tr)
                                            : Padding(
                                                padding: const EdgeInsets.all(10),
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  padding: EdgeInsets.zero,
                                                  itemCount:
                                                      controller.transactionList.length, // Replace with your transaction history length
                                                  itemBuilder: (context, index) {
                                                    TransactionData transactionData = controller.transactionList[index];
                                                    return InkWell(
                                                      onTap: () async {
                                                        if (transactionData.bookingType == "ride") {
                                                          await controller.getBookingDetails(transactionData.bookingId.toString());
                                                        } else if (transactionData.bookingType == "rental") {
                                                          await controller.getRentalDetails(transactionData.bookingId.toString());
                                                        } else if (transactionData.bookingType == "parcel") {
                                                          await controller.getParcelDetails(transactionData.bookingId.toString());
                                                        }
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(bottom: 14),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              width: 50,
                                                              height: 50,
                                                              decoration: BoxDecoration(
                                                                color: transactionData.isCredited == "1"
                                                                    ? AppThemeData.successLight
                                                                    : AppThemeData.errorLight,
                                                                borderRadius: BorderRadius.circular(10),
                                                              ),
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: SvgPicture.asset(transactionData.isCredited == "1"
                                                                    ? "assets/icons/arrow-left-down-line.svg"
                                                                    : "assets/icons/arrow-right-up-line.svg"),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 20,
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    '${transactionData.note}'.tr,
                                                                    textAlign: TextAlign.start,
                                                                    style: AppThemeData.boldTextStyle(
                                                                        fontSize: 14,
                                                                        color: themeChange.getThem()
                                                                            ? AppThemeData.neutralDark900
                                                                            : AppThemeData.neutral900),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 2,
                                                                  ),
                                                                  Text(
                                                                    '${transactionData.createdAt}'.tr,
                                                                    textAlign: TextAlign.center,
                                                                    style: AppThemeData.mediumTextStyle(
                                                                        fontSize: 14,
                                                                        color: themeChange.getThem()
                                                                            ? AppThemeData.neutralDark500
                                                                            : AppThemeData.neutral500),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Text(
                                                              Constant().amountShow(amount: transactionData.amount).tr,
                                                              textAlign: TextAlign.center,
                                                              style: AppThemeData.boldTextStyle(
                                                                  fontSize: 16,
                                                                  color: transactionData.isCredited == "1"
                                                                      ? AppThemeData.successDefault
                                                                      : AppThemeData.errorDefault),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color: themeChange.getThem() ? AppThemeData.neutralDark200 : AppThemeData.neutral200,
                                            width: 1,
                                          ),
                                        ),
                                        child: controller.withdrawalTransactionList.isEmpty
                                            ? Constant.showEmptyView(message: "Transaction Details not found")
                                            : Padding(
                                                padding: const EdgeInsets.all(10),
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  padding: EdgeInsets.zero,
                                                  itemCount: controller.withdrawalTransactionList.length,
                                                  // Replace with your transaction history length
                                                  itemBuilder: (context, index) {
                                                    WithdrawalTransactionData transactionData = controller.withdrawalTransactionList[index];
                                                    return Padding(
                                                      padding: const EdgeInsets.only(bottom: 14),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            width: 50,
                                                            height: 50,
                                                            decoration: BoxDecoration(
                                                              color: AppThemeData.errorLight,
                                                              borderRadius: BorderRadius.circular(10),
                                                            ),
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: SvgPicture.asset("assets/icons/arrow-right-up-line.svg"),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 20,
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  '${transactionData.bankName}'.tr,
                                                                  textAlign: TextAlign.start,
                                                                  style: AppThemeData.boldTextStyle(
                                                                      fontSize: 14,
                                                                      color: themeChange.getThem()
                                                                          ? AppThemeData.neutralDark900
                                                                          : AppThemeData.neutral900),
                                                                ),
                                                                SizedBox(
                                                                  height: 2,
                                                                ),
                                                                Text(
                                                                  '${transactionData.creer}'.tr,
                                                                  textAlign: TextAlign.center,
                                                                  style: AppThemeData.mediumTextStyle(
                                                                      fontSize: 14,
                                                                      color: themeChange.getThem()
                                                                          ? AppThemeData.neutralDark500
                                                                          : AppThemeData.neutral500),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Column(
                                                            children: [
                                                              Text(
                                                                Constant().amountShow(amount: transactionData.amount).tr,
                                                                textAlign: TextAlign.center,
                                                                style: AppThemeData.boldTextStyle(
                                                                    fontSize: 16, color: AppThemeData.errorDefault),
                                                              ),
                                                              Text(
                                                                transactionData.statut!.capitalizeString(),
                                                                textAlign: TextAlign.center,
                                                                style: AppThemeData.boldTextStyle(
                                                                    fontSize: 14,
                                                                    color: transactionData.statut! == "pending"
                                                                        ? AppThemeData.errorDefault
                                                                        : AppThemeData.successDefault),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          );
        });
  }

  Future paymentBottomSheet(context, themeChange, WalletController controller) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          // Open at 50% of the screen
          minChildSize: 0.7,
          // Minimum height 50%
          maxChildSize: 0.8,
          // Maximum height full screen
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: themeChange.getThem() ? AppThemeData.neutralDark50 : AppThemeData.neutral50,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: 5,
                          width: 60,
                          color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300,
                        ),
                      ),
                    ),
                    Text(
                      'Select payment method'.tr,
                      textAlign: TextAlign.center,
                      style: AppThemeData.boldTextStyle(
                        fontSize: 18,
                        color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFieldWidget(
                      controller: controller.amountController.value,
                      hintText: 'Enter amount',
                      title: 'Amount',
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      ],
                      prefix: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: SvgPicture.asset("assets/icons/money-dollar-circle-line.svg"),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        controller: scrollController,
                        children: [
                          Visibility(
                            visible: controller.paymentSettingModel.value.strip != null &&
                                controller.paymentSettingModel.value.strip!.isEnabled == "true",
                            child: cardDecoration(
                              controller,
                              controller.paymentSettingModel.value.strip!.libelle.toString(),
                              themeChange,
                              "assets/images/stripe.png",
                            ),
                          ),
                          Visibility(
                            visible: controller.paymentSettingModel.value.payPal != null &&
                                controller.paymentSettingModel.value.payPal!.isEnabled == "true",
                            child: cardDecoration(
                              controller,
                              controller.paymentSettingModel.value.payPal!.libelle.toString(),
                              themeChange,
                              "assets/images/paypal.png",
                            ),
                          ),
                          Visibility(
                            visible: controller.paymentSettingModel.value.payStack != null &&
                                controller.paymentSettingModel.value.payStack!.isEnabled == "true",
                            child: cardDecoration(
                              controller,
                              controller.paymentSettingModel.value.payStack!.libelle.toString(),
                              themeChange,
                              "assets/images/paystack.png",
                            ),
                          ),
                          Visibility(
                            visible: controller.paymentSettingModel.value.mercadopago != null &&
                                controller.paymentSettingModel.value.mercadopago!.isEnabled == "true",
                            child: cardDecoration(
                              controller,
                              "Mercado Pago",
                              themeChange,
                              "assets/images/mercado-pago.png",
                            ),
                          ),
                          Visibility(
                            visible: controller.paymentSettingModel.value.flutterWave != null &&
                                controller.paymentSettingModel.value.flutterWave!.isEnabled == "true",
                            child: cardDecoration(
                              controller,
                              controller.paymentSettingModel.value.flutterWave!.libelle.toString(),
                              themeChange,
                              "assets/images/flutterwave_logo.png",
                            ),
                          ),
                          Visibility(
                            visible: controller.paymentSettingModel.value.payFast != null &&
                                controller.paymentSettingModel.value.payFast!.isEnabled == "true",
                            child: cardDecoration(
                              controller,
                              controller.paymentSettingModel.value.payFast!.libelle.toString(),
                              themeChange,
                              "assets/images/payfast.png",
                            ),
                          ),
                          Visibility(
                            visible: controller.paymentSettingModel.value.razorpay != null &&
                                controller.paymentSettingModel.value.razorpay!.isEnabled == "true",
                            child: cardDecoration(
                              controller,
                              controller.paymentSettingModel.value.razorpay!.libelle.toString(),
                              themeChange,
                              "assets/images/razorpay.png",
                            ),
                          ),
                          Visibility(
                            visible: controller.paymentSettingModel.value.xendit != null &&
                                controller.paymentSettingModel.value.xendit!.isEnabled == "true",
                            child: cardDecoration(
                              controller,
                              controller.paymentSettingModel.value.xendit!.libelle.toString(),
                              themeChange,
                              "assets/images/xendit.png",
                            ),
                          ),
                          Visibility(
                            visible: controller.paymentSettingModel.value.orangePay != null &&
                                controller.paymentSettingModel.value.orangePay!.isEnabled == "true",
                            child: cardDecoration(
                              controller,
                              controller.paymentSettingModel.value.orangePay!.libelle.toString(),
                              themeChange,
                              "assets/images/orangeMoney.png",
                            ),
                          ),
                          Visibility(
                            visible: controller.paymentSettingModel.value.midtrans != null &&
                                controller.paymentSettingModel.value.midtrans!.isEnabled == "true",
                            child: cardDecoration(
                              controller,
                              controller.paymentSettingModel.value.midtrans!.libelle.toString(),
                              themeChange,
                              "assets/images/midtrans.png",
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: RoundedButtonFill(
                        title: "Confirm".tr,
                        height: 5.5,
                        color: AppThemeData.primaryDefault,
                        textColor: AppThemeData.neutral50,
                        onPress: () async {
                          FocusScope.of(context).unfocus();
                          if (controller.amountController.value.text.isEmpty) {
                            ShowToastDialog.showToast("Please enter topup amount");
                          } else if (controller.selectedPaymentMethod.value.isEmpty) {
                            ShowToastDialog.showToast("Please select payment method");
                          } else {
                            Get.back();
                            if (controller.selectedPaymentMethod.value == "Stripe") {
                              Stripe.publishableKey = controller.paymentSettingModel.value.strip?.key ?? '';
                              Stripe.merchantIdentifier = 'Cabme';
                              await Stripe.instance.applySettings();
                              controller.stripeMakePayment(amount: controller.amountController.value.text);
                            } else if (controller.selectedPaymentMethod.value == controller.paymentSettingModel.value.razorpay!.libelle) {
                              RazorPayController()
                                  .createOrderRazorPay(
                                      amount: double.parse(controller.amountController.value.text).toStringAsFixed(2),
                                      razorpayModel: controller.paymentSettingModel.value.razorpay)
                                  .then((value) {
                                if (value == null) {
                                  Get.back();
                                  ShowToastDialog.showToast("Something went wrong, please contact admin.".tr);
                                } else {
                                  CreateRazorPayOrderModel result = value;
                                  controller.openCheckout(amount: controller.amountController.value.text, orderId: result.id);
                                }
                              });
                            } else if (controller.selectedPaymentMethod.value == controller.paymentSettingModel.value.payPal!.libelle) {
                              controller.paypalPaymentSheet(double.parse(controller.amountController.value.text).toString(), context);
                              // _paypalPayment();
                            } else if (controller.selectedPaymentMethod.value == controller.paymentSettingModel.value.payStack!.libelle) {
                              controller.payStackPayment(controller.amountController.value.text);
                            } else if (controller.selectedPaymentMethod.value ==
                                controller.paymentSettingModel.value.flutterWave!.libelle) {
                              controller.flutterWaveInitiatePayment(
                                  context: context, amount: double.parse(controller.amountController.value.text).toString());
                            } else if (controller.selectedPaymentMethod.value == controller.paymentSettingModel.value.payFast!.libelle) {
                              controller.payFastPayment(context: context, amount: controller.amountController.value.text);
                            } else if (controller.selectedPaymentMethod.value ==
                                controller.paymentSettingModel.value.mercadopago!.libelle) {
                              controller.mercadoPagoMakePayment(
                                context: context,
                                amount: double.parse(controller.amountController.value.text).toString(),
                              );
                            } else if (controller.selectedPaymentMethod.value == controller.paymentSettingModel.value.xendit!.libelle) {
                              controller.xenditPayment(context, double.parse(controller.amountController.value.text));
                            } else if (controller.selectedPaymentMethod.value == controller.paymentSettingModel.value.orangePay!.libelle) {
                              controller.orangeMakePayment(
                                  amount: double.parse(controller.amountController.value.text).toStringAsFixed(2), context: context);
                            } else if (controller.selectedPaymentMethod.value == controller.paymentSettingModel.value.midtrans!.libelle) {
                              controller.midtransMakePayment(amount: controller.amountController.value.text.toString(), context: context);
                            } else {
                              ShowToastDialog.showToast("Please select payment method");
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future withdrawBottomSheet(context, themeChange, WalletController controller) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.4,
          // Open at 50% of the screen
          minChildSize: 0.4,
          // Minimum height 50%
          maxChildSize: 0.8,
          // Maximum height full screen
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: themeChange.getThem() ? AppThemeData.neutralDark50 : AppThemeData.neutral50,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: 5,
                          width: 60,
                          color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300,
                        ),
                      ),
                    ),
                    Text(
                      'Withdraw Amount'.tr,
                      textAlign: TextAlign.center,
                      style: AppThemeData.boldTextStyle(
                        fontSize: 18,
                        color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFieldWidget(
                      controller: controller.withDrawAmountController.value,
                      hintText: 'Enter amount',
                      title: 'Amount',
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      ],
                      prefix: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: SvgPicture.asset("assets/icons/money-dollar-circle-line.svg"),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: themeChange.getThem() ? AppThemeData.neutralDark200 : AppThemeData.neutral200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset("assets/icons/ic_bank.svg"),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.bankDetailsModel.value.data?.holderName ?? "Bank Name",
                              style: AppThemeData.semiBoldTextStyle(
                                color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              controller.bankDetailsModel.value.data?.accountNo ?? "1234567890",
                              style: AppThemeData.semiBoldTextStyle(
                                color: themeChange.getThem() ? AppThemeData.neutralDark500 : AppThemeData.neutral500,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20, top: 20),
                      child: RoundedButtonFill(
                        title: "Withdraw".tr,
                        height: 5.5,
                        color: AppThemeData.primaryDefault,
                        textColor: AppThemeData.neutral50,
                        onPress: () async {
                          FocusScope.of(context).unfocus();
                          if (controller.withDrawAmountController.value.text.isEmpty) {
                            ShowToastDialog.showToast("Please enter amount");
                          }
                          if (double.parse(controller.withDrawAmountController.value.text) <
                              double.parse(Constant.minimumWithdrawalAmount!)) {
                            ShowToastDialog.showToast("You must have at least ${Constant().amountShow(amount: Constant.minimumWithdrawalAmount)} to withdraw.");
                          } else {
                            controller.withdrawAmount();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future addBankBottomSheet(context, themeChange, WalletController controller) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          // Open at 50% of the screen
          minChildSize: 0.8,
          // Minimum height 50%
          maxChildSize: 0.8,
          // Maximum height full screen
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: themeChange.getThem() ? AppThemeData.neutralDark50 : AppThemeData.neutral50,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: 5,
                            width: 60,
                            color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300,
                          ),
                        ),
                      ),
                      Text(
                        'Withdraw Amount'.tr,
                        textAlign: TextAlign.center,
                        style: AppThemeData.boldTextStyle(
                          fontSize: 18,
                          color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFieldWidget(
                        controller: controller.bankNameController.value,
                        hintText: 'Enter Bank Name',
                        title: 'Bank Name',
                      ),
                      TextFieldWidget(
                        controller: controller.branchController.value,
                        hintText: 'Enter Branch Name',
                        title: 'Branch Name',
                      ),
                      TextFieldWidget(
                        controller: controller.holderNameController.value,
                        hintText: 'Enter Bank Holder Name',
                        title: 'Bank Holder Name',
                      ),
                      TextFieldWidget(
                        controller: controller.accountNumberController.value,
                        hintText: 'Enter Bank Account number',
                        title: 'Bank Account Number',
                      ),
                      TextFieldWidget(
                        controller: controller.ifcsCodeController.value,
                        hintText: 'Enter Bank IFSC Code',
                        title: 'IFSC Code',
                      ),
                      TextFieldWidget(
                        controller: controller.informationController.value,
                        hintText: 'Enter information',
                        title: 'Information',
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 40),
                        child: RoundedButtonFill(
                          title: "Add Account".tr,
                          height: 5.5,
                          color: AppThemeData.primaryDefault,
                          textColor: AppThemeData.neutral50,
                          onPress: () async {
                            if (controller.bankNameController.value.text.isEmpty) {
                              ShowToastDialog.showToast("Please enter bank name");
                            } else if (controller.branchController.value.text.isEmpty) {
                              ShowToastDialog.showToast("Please enter branch name");
                            } else if (controller.holderNameController.value.text.isEmpty) {
                              ShowToastDialog.showToast("Please enter bank holder name");
                            } else if (controller.accountNumberController.value.text.isEmpty) {
                              ShowToastDialog.showToast("Please enter bank account number");
                            } else if (controller.ifcsCodeController.value.text.isEmpty) {
                              ShowToastDialog.showToast("Please enter IFSC code");
                            } else if (controller.informationController.value.text.isEmpty) {
                              ShowToastDialog.showToast("Please enter information");
                            } else {
                              controller.submitBankDetails();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Obx cardDecoration(WalletController controller, String value, themeChange, String image) {
    return Obx(
      () => InkWell(
        onTap: () {
          controller.selectedPaymentMethod.value = value;
        },
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Image.asset(
                    image,
                    width: value == controller.paymentSettingModel.value.myWallet!.libelle ||
                            value == controller.paymentSettingModel.value.cash!.libelle
                        ? 30
                        : 40,
                    height: value == controller.paymentSettingModel.value.myWallet!.libelle ||
                            value == controller.paymentSettingModel.value.cash!.libelle
                        ? 30
                        : 40,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: value == controller.paymentSettingModel.value.myWallet!.libelle
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "My Wallet".tr,
                              style: AppThemeData.semiBoldTextStyle(
                                  color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900, fontSize: 16),
                            ),
                            Text(
                              "Balance: ${Constant().amountShow(amount: "100")}",
                              style: AppThemeData.semiBoldTextStyle(
                                  color: themeChange.getThem() ? AppThemeData.secondary200 : AppThemeData.secondary200, fontSize: 12),
                            ),
                          ],
                        )
                      : Text(
                          value,
                          style: AppThemeData.semiBoldTextStyle(
                              color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900, fontSize: 16),
                        ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Radio(
                  value: value.toString(),
                  groupValue: controller.selectedPaymentMethod.value,
                  activeColor: themeChange.getThem() ? AppThemeData.primaryDefault : AppThemeData.primaryDefault,
                  onChanged: (value) {
                    controller.selectedPaymentMethod.value = value.toString();
                  },
                )
              ],
            ),
            Divider(
              color: themeChange.getThem() ? AppThemeData.neutralDark200 : AppThemeData.neutral200,
              height: 1,
            )
          ],
        ),
      ),
    );
  }
}
