// ignore_for_file: must_be_immutable

import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/controller/subscription_controller.dart';
import 'package:cabme_driver/model/razorpay_gen_userid_model.dart';
import 'package:cabme_driver/model/subscription_plan_model.dart';
import 'package:cabme_driver/page/auth_screens/login_screen.dart';
import 'package:cabme_driver/service/rozorpayConroller.dart';
import 'package:cabme_driver/themes/app_them_data.dart';
import 'package:cabme_driver/utils/Preferences.dart';
import 'package:cabme_driver/utils/dark_theme_provider.dart';
import 'package:cabme_driver/utils/network_image_widget.dart';
import 'package:cabme_driver/widget/round_button_fill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SubscriptionPlanScreen extends StatelessWidget {
  const SubscriptionPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: SubscriptionController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: controller.isSplashScreen.value
                  ? null
                  : InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(Icons.arrow_back),
                    ),
              actions: controller.isSplashScreen.value
                  ? [
                      Padding(
                        padding: const EdgeInsets.only(right: 14),
                        child: RoundedButtonFill(
                          title: "Log out".tr,
                          height: 5.5,
                          width: 24,
                          color: AppThemeData.errorDarkLight,
                          textColor: AppThemeData.errorDefault,
                          onPress: () async {
                            Preferences.clearKeyData(Preferences.user);
                            Preferences.clearKeyData(Preferences.userId);
                            Preferences.clearKeyData(Preferences.accesstoken);
                            Preferences.clearKeyData(Preferences.isLogin);
                            Get.offAll(const LoginScreen());
                          },
                        ),
                      ),
                    ]
                  : [],
            ),
            body: controller.isLoading.value
                ? Constant.loader(context)
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Choose Your Business Plan'.tr,
                          textAlign: TextAlign.center,
                          style: AppThemeData.boldTextStyle(fontSize: 22, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Select the most suitable business plan for your business to maximize your potential and access exclusive features.'.tr,
                          textAlign: TextAlign.center,
                          style: AppThemeData.mediumTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                        ),
                        SizedBox(height: 20),
                        Expanded(
                          child: ListView.builder(
                            itemCount: controller.subscriptionPlanList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              SubscriptionPlanData plan = controller.subscriptionPlanList[index];
                              return Obx(
                                () => InkWell(
                                  onTap: () {
                                    controller.selectedSubscriptionPlan.value = plan;
                                    controller.update();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: plan == controller.selectedSubscriptionPlan.value
                                            ? themeChange.getThem()
                                                ? AppThemeData.neutralDark900
                                                : AppThemeData.neutral900
                                            : themeChange.getThem()
                                                ? AppThemeData.neutralDark200
                                                : AppThemeData.neutral200,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                NetworkImageWidget(
                                                  imageUrl: plan.image ?? '',
                                                  height: 50,
                                                  width: 50,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        plan.name ?? '',
                                                        style: AppThemeData.boldTextStyle(
                                                          fontSize: 18,
                                                          color: plan == controller.selectedSubscriptionPlan.value
                                                              ? themeChange.getThem()
                                                                  ? AppThemeData.neutralDark50
                                                                  : AppThemeData.neutral50
                                                              : themeChange.getThem()
                                                                  ? AppThemeData.neutralDark900
                                                                  : AppThemeData.neutral900,
                                                        ),
                                                      ),
                                                      Text(
                                                        plan.description ?? '',
                                                        style: AppThemeData.mediumTextStyle(
                                                          fontSize: 12,
                                                          color: plan == controller.selectedSubscriptionPlan.value
                                                              ? AppThemeData.neutral500
                                                              : themeChange.getThem()
                                                                  ? AppThemeData.neutralDark900
                                                                  : AppThemeData.neutral900,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                plan.status == true
                                                    ? RoundedButtonFill(
                                                        title: "Active".tr,
                                                        height: 4,
                                                        width: 20,
                                                        color: AppThemeData.successDark,
                                                        textColor: AppThemeData.neutral50,
                                                        onPress: () async {},
                                                      )
                                                    : SizedBox(),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        SizedBox(height: 10),
                                                        Text(
                                                          plan.type == "free" ? "Free" : Constant().amountShow(amount: plan.price),
                                                          style: AppThemeData.boldTextStyle(
                                                            fontSize: 18,
                                                            color: plan == controller.selectedSubscriptionPlan.value
                                                                ? themeChange.getThem()
                                                                    ? AppThemeData.neutralDark50
                                                                    : AppThemeData.neutral50
                                                                : themeChange.getThem()
                                                                    ? AppThemeData.neutralDark900
                                                                    : AppThemeData.neutral900,
                                                          ),
                                                        ),
                                                        Text(
                                                          plan.expiryDay == "-1" ? "Lifetime" : "${plan.expiryDay} ${'Days'.tr}",
                                                          style: AppThemeData.mediumTextStyle(
                                                            fontSize: 14,
                                                            color: themeChange.getThem() ? AppThemeData.neutralDark500 : AppThemeData.neutral500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      SizedBox(height: 10),
                                                      Text(
                                                        plan.bookingLimit == "-1" ? "Unlimited" : plan.bookingLimit.toString(),
                                                        style: AppThemeData.boldTextStyle(
                                                          fontSize: 18,
                                                          color: plan == controller.selectedSubscriptionPlan.value
                                                              ? themeChange.getThem()
                                                                  ? AppThemeData.neutralDark50
                                                                  : AppThemeData.neutral50
                                                              : themeChange.getThem()
                                                                  ? AppThemeData.neutralDark900
                                                                  : AppThemeData.neutral900,
                                                        ),
                                                      ),
                                                      Text(
                                                        "Accept Booking limits",
                                                        style: AppThemeData.mediumTextStyle(
                                                          fontSize: 14,
                                                          color: themeChange.getThem() ? AppThemeData.neutralDark500 : AppThemeData.neutral500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Divider(),
                                            controller.userModel.value.userData!.isOwner == "true"
                                                ? Row(
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            SizedBox(height: 10),
                                                            Text(
                                                              plan.vehicleLimit == "-1" ? "Unlimited" : plan.vehicleLimit.toString(),
                                                              style: AppThemeData.boldTextStyle(
                                                                fontSize: 18,
                                                                color: plan == controller.selectedSubscriptionPlan.value
                                                                    ? themeChange.getThem()
                                                                        ? AppThemeData.neutralDark50
                                                                        : AppThemeData.neutral50
                                                                    : themeChange.getThem()
                                                                        ? AppThemeData.neutralDark900
                                                                        : AppThemeData.neutral900,
                                                              ),
                                                            ),
                                                            Text(
                                                              "Vehicles allowed",
                                                              style: AppThemeData.mediumTextStyle(
                                                                fontSize: 14,
                                                                color: themeChange.getThem() ? AppThemeData.neutralDark500 : AppThemeData.neutral500,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(height: 10),
                                                          Text(
                                                            plan.driverLimit == "-1" ? "Unlimited" : plan.driverLimit.toString(),
                                                            style: AppThemeData.boldTextStyle(
                                                              fontSize: 18,
                                                              color: plan == controller.selectedSubscriptionPlan.value
                                                                  ? themeChange.getThem()
                                                                      ? AppThemeData.neutralDark50
                                                                      : AppThemeData.neutral50
                                                                  : themeChange.getThem()
                                                                      ? AppThemeData.neutralDark900
                                                                      : AppThemeData.neutral900,
                                                            ),
                                                          ),
                                                          Text(
                                                            "Driver allowed",
                                                            style: AppThemeData.mediumTextStyle(
                                                              fontSize: 14,
                                                              color: themeChange.getThem() ? AppThemeData.neutralDark500 : AppThemeData.neutral500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                : SizedBox(),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            if (controller.userModel.value.userData?.isOwner == "true") Divider(),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 10),
                                                Text(
                                                  plan.dispatcherAccess?.capitalizeString() ?? '',
                                                  style: AppThemeData.boldTextStyle(
                                                    fontSize: 18,
                                                    color: plan == controller.selectedSubscriptionPlan.value
                                                        ? themeChange.getThem()
                                                            ? AppThemeData.neutralDark50
                                                            : AppThemeData.neutral50
                                                        : themeChange.getThem()
                                                            ? AppThemeData.neutralDark900
                                                            : AppThemeData.neutral900,
                                                  ),
                                                ),
                                                Text(
                                                  'Dispatcher Panel Access'.tr,
                                                  style: AppThemeData.mediumTextStyle(
                                                    fontSize: 14,
                                                    color: themeChange.getThem() ? AppThemeData.neutralDark500 : AppThemeData.neutral500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Divider(),
                                            plan.id == Constant.commissionSubscriptionID
                                                ? Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          controller.userModel.value.userData!.adminCommission != null
                                                              ? 'payCommission'.trParams({
                                                                  'commission': controller.userModel.value.userData!.adminCommission!.type == 'Percentage'
                                                                      ? "${controller.userModel.value.userData!.adminCommission!.value} %"
                                                                      : "${Constant().amountShow(amount: controller.userModel.value.userData!.adminCommission!.value)} Flat",
                                                                  'tail': 'onEachBooking'.tr,
                                                                })
                                                              : 'payCommission'.trParams({
                                                                  'commission': Constant.adminCommission?.type == 'Percentage'
                                                                      ? "${Constant.adminCommission?.value} %"
                                                                      : "${Constant().amountShow(amount: Constant.adminCommission?.value)} Flat",
                                                                  'tail': 'onEachBooking'.tr,
                                                                }),
                                                          style: AppThemeData.mediumTextStyle(
                                                            fontSize: 16,
                                                            color: plan == controller.selectedSubscriptionPlan.value
                                                                ? themeChange.getThem()
                                                                    ? AppThemeData.neutralDark50
                                                                    : AppThemeData.neutral50
                                                                : themeChange.getThem()
                                                                    ? AppThemeData.neutralDark900
                                                                    : AppThemeData.neutral900,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                : SizedBox(),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: ListView.builder(
                                                itemCount: plan.planPoints!.length,
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding: const EdgeInsets.only(bottom: 10),
                                                    child: Text(
                                                      "✅ ${plan.planPoints![index]}",
                                                      style: AppThemeData.mediumTextStyle(
                                                        fontSize: 16,
                                                        color: plan == controller.selectedSubscriptionPlan.value
                                                            ? themeChange.getThem()
                                                                ? AppThemeData.neutralDark50
                                                                : AppThemeData.neutral50
                                                            : themeChange.getThem()
                                                                ? AppThemeData.neutralDark900
                                                                : AppThemeData.neutral900,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            RoundedButtonFill(
                                              title: plan.status == true ? "Renewal now" : "Active Now".tr,
                                              height: 5.5,
                                              color: plan == controller.selectedSubscriptionPlan.value ? AppThemeData.primaryDefault : AppThemeData.neutral50,
                                              textColor: plan == controller.selectedSubscriptionPlan.value ? AppThemeData.neutral50 : AppThemeData.neutral900,
                                              onPress: () async {
                                                controller.amount.value = double.parse(controller.selectedSubscriptionPlan.value.price ?? '0.0');
                                                if (controller.selectedSubscriptionPlan.value.id == plan.id) {
                                                  if (controller.selectedSubscriptionPlan.value.type == 'free' || controller.selectedSubscriptionPlan.value.id == Constant.commissionSubscriptionID) {
                                                    await controller.setSubscriptionPlan();
                                                    controller.update();
                                                  } else {
                                                    paymentBottomSheet(context, themeChange, controller);
                                                  }
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
          );
        });
  }

  Future paymentBottomSheet(context, themeChange, SubscriptionController controller) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          // Start height
          minChildSize: 0.7,
          // Minimum height
          maxChildSize: 0.8,
          // Maximum height
          expand: false,
          // ✅ Prevents full-screen takeover
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: themeChange.getThem() ? AppThemeData.neutralDark50 : AppThemeData.neutral50,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        controller: scrollController,
                        shrinkWrap: true,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 150, vertical: 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                height: 5,
                                color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300,
                              ),
                            ),
                          ),
                          Text(
                            'Select payment method'.tr,
                            textAlign: TextAlign.center,
                            style: AppThemeData.boldTextStyle(fontSize: 18, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              controller.isSplashScreen.value
                                  ? SizedBox()
                                  : Visibility(
                                      visible: controller.paymentSettingModel.value.myWallet != null && controller.paymentSettingModel.value.myWallet!.isEnabled == "true",
                                      child: cardDecoration(controller, controller.paymentSettingModel.value.myWallet!.libelle.toString(), themeChange, "assets/images/ic_wallet_image.png"),
                                    ),
                              Visibility(
                                visible: controller.paymentSettingModel.value.strip != null && controller.paymentSettingModel.value.strip!.isEnabled == "true",
                                child: cardDecoration(controller, controller.paymentSettingModel.value.strip!.libelle.toString(), themeChange, "assets/images/stripe.png"),
                              ),
                              Visibility(
                                visible: controller.paymentSettingModel.value.payPal != null && controller.paymentSettingModel.value.payPal!.isEnabled == "true",
                                child: cardDecoration(controller, controller.paymentSettingModel.value.payPal!.libelle.toString(), themeChange, "assets/images/paypal.png"),
                              ),
                              Visibility(
                                visible: controller.paymentSettingModel.value.payStack != null && controller.paymentSettingModel.value.payStack!.isEnabled == "true",
                                child: cardDecoration(controller, controller.paymentSettingModel.value.payStack!.libelle.toString(), themeChange, "assets/images/paystack.png"),
                              ),
                              Visibility(
                                visible: controller.paymentSettingModel.value.mercadopago != null && controller.paymentSettingModel.value.mercadopago!.isEnabled == "true",
                                child: cardDecoration(controller, "Mercado Pago", themeChange, "assets/images/mercado-pago.png"),
                              ),
                              Visibility(
                                visible: controller.paymentSettingModel.value.flutterWave != null && controller.paymentSettingModel.value.flutterWave!.isEnabled == "true",
                                child: cardDecoration(controller, controller.paymentSettingModel.value.flutterWave!.libelle.toString(), themeChange, "assets/images/flutterwave_logo.png"),
                              ),
                              Visibility(
                                visible: controller.paymentSettingModel.value.payFast != null && controller.paymentSettingModel.value.payFast!.isEnabled == "true",
                                child: cardDecoration(controller, controller.paymentSettingModel.value.payFast!.libelle.toString(), themeChange, "assets/images/payfast.png"),
                              ),
                              Visibility(
                                visible: controller.paymentSettingModel.value.razorpay != null && controller.paymentSettingModel.value.razorpay!.isEnabled == "true",
                                child: cardDecoration(controller, controller.paymentSettingModel.value.razorpay!.libelle.toString(), themeChange, "assets/images/razorpay.png"),
                              ),
                              Visibility(
                                visible: controller.paymentSettingModel.value.xendit != null && controller.paymentSettingModel.value.xendit!.isEnabled == "true",
                                child: cardDecoration(controller, controller.paymentSettingModel.value.xendit!.libelle.toString(), themeChange, "assets/images/xendit.png"),
                              ),
                              Visibility(
                                visible: controller.paymentSettingModel.value.orangePay != null && controller.paymentSettingModel.value.orangePay!.isEnabled == "true",
                                child: cardDecoration(controller, controller.paymentSettingModel.value.orangePay!.libelle.toString(), themeChange, "assets/images/orangeMoney.png"),
                              ),
                              Visibility(
                                visible: controller.paymentSettingModel.value.midtrans != null && controller.paymentSettingModel.value.midtrans!.isEnabled == "true",
                                child: cardDecoration(controller, controller.paymentSettingModel.value.midtrans!.libelle.toString(), themeChange, "assets/images/midtrans.png"),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: RoundedButtonFill(
                        title: "Confirm".tr,
                        height: 5.5,
                        color: AppThemeData.primaryDefault,
                        textColor: AppThemeData.neutral50,
                        onPress: () async {
                          if (controller.selectedPaymentMethod.value.isEmpty) {
                            ShowToastDialog.showToast("Please select payment method");
                          } else {
                            Get.back();
                            if (controller.selectedPaymentMethod.value == controller.paymentSettingModel.value.myWallet!.libelle) {
                              if ((controller.userModel.value.userData!.amount!.isEmpty ? 0.0 : double.parse(controller.userModel.value.userData!.amount!)) < controller.amount.value) {
                                ShowToastDialog.showToast("Insufficient balance in wallet".tr);
                                return;
                              }
                              controller.setSubscriptionPlan();
                            } else if (controller.selectedPaymentMethod.value == controller.paymentSettingModel.value.strip!.libelle) {
                              Stripe.publishableKey = controller.paymentSettingModel.value.strip?.key ?? '';
                              Stripe.merchantIdentifier = 'Cabme';
                              await Stripe.instance.applySettings();
                              controller.stripeMakePayment(amount: controller.amount.value.toString());
                            } else if (controller.selectedPaymentMethod.value == controller.paymentSettingModel.value.razorpay!.libelle) {
                              RazorPayController()
                                  .createOrderRazorPay(amount: double.parse(controller.amount.value.toString()).toStringAsFixed(2), razorpayModel: controller.paymentSettingModel.value.razorpay)
                                  .then((value) {
                                if (value == null) {
                                  Get.back();
                                  ShowToastDialog.showToast("Something went wrong, please contact admin.".tr);
                                } else {
                                  CreateRazorPayOrderModel result = value;
                                  controller.openCheckout(amount: controller.amount.value.toString(), orderId: result.id);
                                }
                              });
                            } else if (controller.selectedPaymentMethod.value == controller.paymentSettingModel.value.payPal!.libelle) {
                              controller.paypalPaymentSheet(double.parse(controller.amount.value.toString()).toString(), context);
                              // _paypalPayment();
                            } else if (controller.selectedPaymentMethod.value == controller.paymentSettingModel.value.payStack!.libelle) {
                              controller.payStackPayment(controller.amount.value.toString());
                            } else if (controller.selectedPaymentMethod.value == controller.paymentSettingModel.value.flutterWave!.libelle) {
                              controller.flutterWaveInitiatePayment(context: context, amount: double.parse(controller.amount.value.toString()).toString());
                            } else if (controller.selectedPaymentMethod.value == controller.paymentSettingModel.value.payFast!.libelle) {
                              controller.payFastPayment(context: context, amount: controller.amount.value.toString());
                            } else if (controller.selectedPaymentMethod.value == controller.paymentSettingModel.value.mercadopago!.libelle) {
                              controller.mercadoPagoMakePayment(
                                context: context,
                                amount: double.parse(controller.amount.value.toString()).toString(),
                              );
                            } else if (controller.selectedPaymentMethod.value == controller.paymentSettingModel.value.xendit!.libelle) {
                              controller.xenditPayment(context, double.parse(controller.amount.value.toString()));
                            } else if (controller.selectedPaymentMethod.value == controller.paymentSettingModel.value.orangePay!.libelle) {
                              controller.orangeMakePayment(amount: double.parse(controller.amount.value.toString()).toStringAsFixed(2), context: context);
                            } else if (controller.selectedPaymentMethod.value == controller.paymentSettingModel.value.midtrans!.libelle) {
                              controller.midtransMakePayment(amount: controller.amount.value.toString().toString(), context: context);
                            } else {
                              ShowToastDialog.showToast("Please select payment method".tr);
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

  Obx cardDecoration(SubscriptionController controller, String value, themeChange, String image) {
    return Obx(
      () => Column(
        children: [
          InkWell(
            onTap: () {
              controller.selectedPaymentMethod.value = value;
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Image.asset(
                    image,
                    width: value == controller.paymentSettingModel.value.myWallet!.libelle || value == controller.paymentSettingModel.value.cash!.libelle ? 30 : 40,
                    height: value == controller.paymentSettingModel.value.myWallet!.libelle || value == controller.paymentSettingModel.value.cash!.libelle ? 30 : 40,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                value == controller.paymentSettingModel.value.myWallet!.libelle
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "My Wallet",
                            style: AppThemeData.semiBoldTextStyle(color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900, fontSize: 16),
                          ),
                          Text(
                            'balanceText'.trParams({
                              'amount': Constant().amountShow(
                                amount: controller.userModel.value.userData!.amount.toString(),
                              ),
                            }),
                            style: AppThemeData.semiBoldTextStyle(color: themeChange.getThem() ? AppThemeData.secondary200 : AppThemeData.secondary200, fontSize: 12),
                          ),
                        ],
                      )
                    : Text(
                        value,
                        style: AppThemeData.semiBoldTextStyle(color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900, fontSize: 16),
                      ),
                const SizedBox(
                  width: 10,
                ),
                const Expanded(
                  child: SizedBox(),
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
          ),
          Divider(
            color: themeChange.getThem() ? AppThemeData.neutralDark200 : AppThemeData.neutral200,
            height: 1,
          )
        ],
      ),
    );
  }
}
