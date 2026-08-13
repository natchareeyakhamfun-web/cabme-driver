import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/controller/rental_details_controller.dart';
import 'package:cabme_driver/model/tax_model.dart';
import 'package:cabme_driver/page/chats_screen/conversation_screen.dart';
import 'package:cabme_driver/page/rating_screen/rating_screen.dart';
import 'package:cabme_driver/themes/responsive.dart';
import 'package:cabme_driver/utils/dark_theme_provider.dart';
import 'package:cabme_driver/utils/network_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../constant/ride_satatus.dart';
import '../../themes/app_them_data.dart';

class RentalDetailsScreen extends StatelessWidget {
  const RentalDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: RentalDetailsController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              leading: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Icon(Icons.arrow_back),
              ),
              centerTitle: false,
              title: Text(
                controller.rentalBookingData.value.bookingNumber ?? "#${controller.rentalBookingData.value.id}",
                style: AppThemeData.semiBoldTextStyle(fontSize: 18, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: controller.isLoading.value
                  ? Constant.loader(context)
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          controller.rentalBookingData.value.driver == null || controller.userModel.value.userData!.isOwner != "true"
                              ? const SizedBox()
                              : Container(
                                  width: Responsive.width(100, context),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Title
                                      Text(
                                        "Driver Details".tr,
                                        style: AppThemeData.boldTextStyle(
                                          fontSize: 16,
                                          color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                                        ),
                                      ),
                                      Divider(color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300),

                                      // Driver Info
                                      Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: NetworkImageWidget(
                                              imageUrl: controller.rentalBookingData.value.driver!.image.toString(),
                                              width: 55,
                                              height: 55,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                // Name
                                                Text(
                                                  "${controller.rentalBookingData.value.driver!.prenom} ${controller.rentalBookingData.value.driver!.nom}".tr,
                                                  style: AppThemeData.boldTextStyle(
                                                    fontSize: 16,
                                                    color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                // Rating Badge
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: AppThemeData.successLight,
                                                    borderRadius: BorderRadius.circular(30),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      const Icon(Icons.star_half, size: 14, color: AppThemeData.successDefault),
                                                      const SizedBox(width: 5),
                                                      Text(
                                                        "${controller.rentalBookingData.value.driver!.averageRating}",
                                                        style: AppThemeData.mediumTextStyle(
                                                          fontSize: 14,
                                                          color: AppThemeData.successDefault,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                          SizedBox(
                            height: 20,
                          ),
                          controller.rentalBookingData.value.status == RideStatus.canceled
                              ? SizedBox()
                              : Container(
                                  width: Responsive.width(100, context),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Customer Details".tr,
                                          style: AppThemeData.boldTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                        ),
                                        Divider(color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300),
                                        Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 10),
                                              child: Row(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(10),
                                                    child: NetworkImageWidget(
                                                      imageUrl: controller.rentalBookingData.value.user!.image.toString(),
                                                      width: 55,
                                                      height: 55,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          '${controller.rentalBookingData.value.user!.prenom} ${controller.rentalBookingData.value.user!.nom}'.tr,
                                                          textAlign: TextAlign.start,
                                                          style: AppThemeData.boldTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Container(
                                                          width: 80,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(30), color: themeChange.getThem() ? AppThemeData.successLight : AppThemeData.successLight),
                                                          child: Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                                                            child: Row(
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Icon(
                                                                  Icons.star_half,
                                                                  size: 14,
                                                                  color: themeChange.getThem() ? AppThemeData.successDefault : AppThemeData.successDefault,
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text(
                                                                  "${controller.rentalBookingData.value.user!.averageRating}",
                                                                  style: AppThemeData.mediumTextStyle(
                                                                      fontSize: 14, color: themeChange.getThem() ? AppThemeData.successDefault : AppThemeData.successDefault),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  controller.rentalBookingData.value.status == RideStatus.confirmed || controller.rentalBookingData.value.status == RideStatus.onRide
                                                      ? Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                Constant.makePhoneCall(controller.rentalBookingData.value.user!.phone!);
                                                              },
                                                              child: SvgPicture.asset(
                                                                "assets/icons/ic_phone_dial.svg",
                                                                width: 36,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                Get.to(ConversationScreen(), arguments: {
                                                                  "receiverId": controller.rentalBookingData.value.driver!.id,
                                                                  "orderId": controller.rentalBookingData.value.id,
                                                                  "receiverName": "${controller.rentalBookingData.value.driver!.prenom} ${controller.rentalBookingData.value.driver!.nom}",
                                                                  "receiverPhoto": controller.rentalBookingData.value.driver!.image
                                                                });
                                                              },
                                                              child: SvgPicture.asset(
                                                                "assets/icons/ic_chat_details.svg",
                                                                width: 36,
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : SizedBox()
                                                ],
                                              ),
                                            ),
                                            Divider(color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 5),
                                              child: InkWell(
                                                onTap: () {
                                                  Get.to(RatingScreen(), arguments: {"bookingType": "rental", "rentalBookingModel": controller.rentalBookingData.value})!.then(
                                                    (value) {
                                                      if (value != null) {
                                                        if (value == true) {
                                                          controller.getParcelBookingData();
                                                        }
                                                      }
                                                    },
                                                  );
                                                },
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.add, color: themeChange.getThem() ? AppThemeData.accentDark : AppThemeData.accentDark),
                                                    Text(
                                                      "Add Ratings".tr,
                                                      style: AppThemeData.boldTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.accentDark : AppThemeData.accentDark),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: Responsive.width(100, context),
                            decoration: BoxDecoration(
                              border: Border.all(color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Rental Details".tr,
                                    style: AppThemeData.boldTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                  ),
                                  Divider(color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Rental Package'.tr,
                                            textAlign: TextAlign.start,
                                            style: AppThemeData.mediumTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                          ),
                                        ),
                                        Text(
                                          controller.rentalBookingData.value.packageDetails!.title.toString().tr,
                                          textAlign: TextAlign.start,
                                          style: AppThemeData.boldTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Rental Package Price'.tr,
                                            textAlign: TextAlign.start,
                                            style: AppThemeData.mediumTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                          ),
                                        ),
                                        Text(
                                          Constant().amountShow(amount: controller.rentalBookingData.value.packageDetails!.baseFare.toString()).tr,
                                          textAlign: TextAlign.start,
                                          style: AppThemeData.boldTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'includingUnit'.trParams({
                                              'unit': '${Constant.distanceUnit}'.tr,
                                            }),
                                            textAlign: TextAlign.start,
                                            style: AppThemeData.mediumTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                          ),
                                        ),
                                        Text(
                                          "${controller.rentalBookingData.value.packageDetails!.includedDistance.toString()} ${Constant.distanceUnit}".tr,
                                          textAlign: TextAlign.start,
                                          style: AppThemeData.boldTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Including Hours'.tr,
                                            textAlign: TextAlign.start,
                                            style: AppThemeData.mediumTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                          ),
                                        ),
                                        Text(
                                          "${controller.rentalBookingData.value.packageDetails!.includedHours.toString()} Hr".tr,
                                          textAlign: TextAlign.start,
                                          style: AppThemeData.boldTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'extraUnit'.trParams({
                                              'unit': '${Constant.distanceUnit}'.tr,
                                            }),
                                            textAlign: TextAlign.start,
                                            style: AppThemeData.mediumTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                          ),
                                        ),
                                        Text(
                                          "${controller.rentalBookingData.value.completeKm == "0" ? "0" : ((double.parse(controller.rentalBookingData.value.completeKm.toString()) - double.parse(controller.rentalBookingData.value.currentKm.toString())) - double.parse(controller.rentalBookingData.value.packageDetails!.includedDistance.toString())).toString()} ${Constant.distanceUnit}"
                                              .tr,
                                          textAlign: TextAlign.start,
                                          style: AppThemeData.boldTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Extra Minutes'.tr,
                                            textAlign: TextAlign.start,
                                            style: AppThemeData.mediumTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                          ),
                                        ),
                                        Text(
                                          "${Constant.getExtraMinutes(startDate: controller.startDate.value, endDate: controller.endDate.value, includedHours: controller.rentalBookingData.value.packageDetails!.includedHours.toString())} Minutes",
                                          textAlign: TextAlign.start,
                                          style: AppThemeData.boldTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: Responsive.width(100, context),
                            decoration: BoxDecoration(
                              border: Border.all(color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Payment Details".tr,
                                    style: AppThemeData.boldTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                  ),
                                  Divider(color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          "Ride Cost".tr,
                                          style: AppThemeData.mediumTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text(
                                          Constant().amountShow(amount: controller.subTotal.value),
                                          textAlign: TextAlign.end,
                                          style: AppThemeData.boldTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Discount'.tr,
                                            textAlign: TextAlign.start,
                                            style: AppThemeData.semiBoldTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark700 : AppThemeData.neutral700),
                                          ),
                                        ),
                                        Text(
                                          Constant().amountShow(amount: controller.discount.value).tr,
                                          textAlign: TextAlign.start,
                                          style: AppThemeData.semiBoldTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.errorDefault : AppThemeData.errorDefault),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ListView.builder(
                                    itemCount: controller.rentalBookingData.value.tax!.length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index) {
                                      TaxModel taxModel = controller.rentalBookingData.value.tax![index];
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 10),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                '${taxModel.libelle} (${taxModel.value} ${taxModel.type == "Fixed" ? "${Constant.currency}" : "%"})'.tr,
                                                textAlign: TextAlign.start,
                                                style: AppThemeData.semiBoldTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark700 : AppThemeData.neutral700),
                                              ),
                                            ),
                                            Text(
                                              Constant()
                                                  .amountShow(
                                                      amount: Constant()
                                                          .calculateTax(amount: (double.parse(controller.subTotal.value) - double.parse(controller.discount.value)).toString(), taxModel: taxModel)
                                                          .toString())
                                                  .tr,
                                              textAlign: TextAlign.start,
                                              style: AppThemeData.semiBoldTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark700 : AppThemeData.neutral700),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          "Total Paid Amount".tr,
                                          style: AppThemeData.mediumTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text(
                                          Constant().amountShow(amount: controller.totalAmount.value),
                                          textAlign: TextAlign.end,
                                          style: AppThemeData.boldTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.accentDark : AppThemeData.accentDark),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  controller.userModel.value.userData!.ownerId != null && controller.userModel.value.userData!.ownerId!.isNotEmpty
                                      ? SizedBox()
                                      : Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                "Admin commission:",
                                                style: AppThemeData.mediumTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.errorDefault : AppThemeData.errorDefault),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Text(
                                                Constant().amountShow(
                                                    amount: Constant.calculateAdminCommission(
                                                            adminCommission: controller.rentalBookingData.value.adminCommissionType,
                                                            amount: (double.parse(controller.subTotal.value) - double.parse(controller.discount.value)).toString())
                                                        .toString()),
                                                textAlign: TextAlign.end,
                                                style: AppThemeData.boldTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.errorDefault : AppThemeData.errorDefault),
                                              ),
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          controller.userModel.value.userData!.ownerId != null && controller.userModel.value.userData!.ownerId!.isNotEmpty
                              ? SizedBox()
                              : Container(
                                  width: Responsive.width(100, context),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: themeChange.getThem() ? AppThemeData.errorDefault : AppThemeData.errorDefault),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Note : Admin commission will be debited from your wallet balance. \n \nAdmin commission will apply on your booking Amount minus Discount(if applicable).",
                                          style: AppThemeData.boldTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.errorDefault : AppThemeData.errorDefault),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                        ],
                      ),
                    ),
            ),
          );
        });
  }
}
