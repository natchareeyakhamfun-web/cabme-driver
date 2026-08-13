import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/controller/subscription_history_controller.dart';
import 'package:cabme_driver/model/subscription_history_model.dart';
import 'package:cabme_driver/themes/app_them_data.dart';
import 'package:cabme_driver/utils/dark_theme_provider.dart';
import 'package:cabme_driver/utils/network_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../widget/round_button_fill.dart';

class SubscriptionHistoryScreen extends StatelessWidget {
  const SubscriptionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: SubscriptionHistoryController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: themeChange.getThem() ? Colors.black : Colors.white,
              iconTheme: IconThemeData(color: themeChange.getThem() ? Colors.white : Colors.black),
            ),
            body: controller.isLoading.value
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Subscription Purchase History'.tr,
                            textAlign: TextAlign.start,
                            style: AppThemeData.boldTextStyle(
                                fontSize: 22, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'View your previously purchased business plans and their billing cycles.'.tr,
                            textAlign: TextAlign.start,
                            style: AppThemeData.mediumTextStyle(
                                fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                          ),
                          SizedBox(height: 20),
                          ListView.builder(
                            itemCount: controller.subscriptionHistoryList.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              SubscriptionData subscription = controller.subscriptionHistoryList[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: themeChange.getThem() ? AppThemeData.neutralDark200 : AppThemeData.neutral200,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            NetworkImageWidget(
                                              imageUrl: subscription.subscriptionPlan!.image.toString(),
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
                                                    subscription.subscriptionPlan!.name.toString(),
                                                    textAlign: TextAlign.start,
                                                    style: AppThemeData.boldTextStyle(
                                                        fontSize: 18,
                                                        color:
                                                            themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                                  ),
                                                  Text(
                                                    subscription.subscriptionPlan!.type == 'free'
                                                        ? "Free".tr
                                                        : Constant().amountShow(amount: subscription.subscriptionPlan!.price.toString()),
                                                    textAlign: TextAlign.start,
                                                    style: AppThemeData.semiBoldTextStyle(
                                                        fontSize: 18,
                                                        color:
                                                            themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            RoundedButtonFill(
                                              title: subscription.status!.capitalizeString(),
                                              height: 4,
                                              width: 20,
                                              color: subscription.status == "cancelled" || subscription.status == "expire"
                                                  ? AppThemeData.errorDefault
                                                  : AppThemeData.successDark,
                                              textColor: AppThemeData.neutral50,
                                              onPress: () async {},
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "Validity Period:",
                                                textAlign: TextAlign.start,
                                                style: AppThemeData.mediumTextStyle(
                                                    fontSize: 14,
                                                    color: themeChange.getThem() ? AppThemeData.neutralDark700 : AppThemeData.neutral700),
                                              ),
                                            ),
                                            Text(
                                              subscription.subscriptionPlan!.expiryDay == "-1"
                                                  ? "Unlimited"
                                                  : "${subscription.subscriptionPlan!.expiryDay} ${'Days'.tr}",
                                              textAlign: TextAlign.start,
                                              style: AppThemeData.semiBoldTextStyle(
                                                  fontSize: 14,
                                                  color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "Date Purchased:",
                                                textAlign: TextAlign.start,
                                                style: AppThemeData.mediumTextStyle(
                                                    fontSize: 14,
                                                    color: themeChange.getThem() ? AppThemeData.neutralDark700 : AppThemeData.neutral700),
                                              ),
                                            ),
                                            Text(
                                              subscription.createdAt.toString(),
                                              textAlign: TextAlign.start,
                                              style: AppThemeData.semiBoldTextStyle(
                                                  fontSize: 14,
                                                  color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "Expired Date:",
                                                textAlign: TextAlign.start,
                                                style: AppThemeData.mediumTextStyle(
                                                    fontSize: 14,
                                                    color: themeChange.getThem() ? AppThemeData.neutralDark700 : AppThemeData.neutral700),
                                              ),
                                            ),
                                            Text(
                                              subscription.expiryDate == null ? "Unlimited" : subscription.expiryDate.toString(),
                                              textAlign: TextAlign.start,
                                              style: AppThemeData.semiBoldTextStyle(
                                                  fontSize: 14,
                                                  color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        subscription.subscriptionPlan!.type == 'free'
                                            ? SizedBox()
                                            : Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      "Payment method:",
                                                      textAlign: TextAlign.start,
                                                      style: AppThemeData.mediumTextStyle(
                                                          fontSize: 14,
                                                          color: themeChange.getThem()
                                                              ? AppThemeData.neutralDark700
                                                              : AppThemeData.neutral700),
                                                    ),
                                                  ),
                                                  Text(
                                                    subscription.paymentMethod.toString(),
                                                    textAlign: TextAlign.start,
                                                    style: AppThemeData.semiBoldTextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                                  ),
                                                ],
                                              )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        });
  }
}
