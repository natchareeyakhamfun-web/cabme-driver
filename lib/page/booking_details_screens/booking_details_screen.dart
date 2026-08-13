import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/ride_satatus.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/controller/booking_details_controller.dart';
import 'package:cabme_driver/model/tax_model.dart';
import 'package:cabme_driver/page/chats_screen/conversation_screen.dart';
import 'package:cabme_driver/page/live_tracking_screen/live_tracking_screen.dart';
import 'package:cabme_driver/page/rating_screen/rating_screen.dart';
import 'package:cabme_driver/themes/responsive.dart';
import 'package:cabme_driver/utils/dark_theme_provider.dart';
import 'package:cabme_driver/utils/network_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:timelines_plus/timelines_plus.dart';

import '../../themes/app_them_data.dart';
import '../../themes/round_button_fill.dart';
import '../../widget/map_view.dart';

class BookingDetailsScreen extends StatelessWidget {
  const BookingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: BookingDetailsController(),
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
                controller.bookingModel.value.bookingNumber ?? "#${controller.bookingModel.value.id}",
                style: AppThemeData.semiBoldTextStyle(fontSize: 18, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
              ),
            ),
            body: controller.isLoading.value
                ? Constant.loader(context)
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: Responsive.height(20, context),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: MapView(),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: themeChange.getThem() ? AppThemeData.neutralDark100 : AppThemeData.neutral100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              child: Timeline.tileBuilder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: const NeverScrollableScrollPhysics(),
                                theme: TimelineThemeData(
                                  nodePosition: 0,
                                  // indicatorPosition: 0,
                                ),
                                builder: TimelineTileBuilder.connected(
                                  contentsAlign: ContentsAlign.basic,
                                  indicatorBuilder: (context, index) {
                                    return index == 0
                                        ? SvgPicture.asset("assets/icons/ic_sender.svg")
                                        : controller.locationData.length - 1 == index
                                            ? SvgPicture.asset("assets/icons/ic_recevier.svg")
                                            : Container(
                                                width: 24,
                                                height: 24,
                                                decoration: BoxDecoration(color: AppThemeData.neutral900, borderRadius: BorderRadius.circular(40)),
                                                child: Center(
                                                  child: Text(
                                                    String.fromCharCode(index - 1 + 65),
                                                    style: TextStyle(fontSize: 14, fontFamily: AppThemeData.regular, color: themeChange.getThem() ? AppThemeData.neutral50 : AppThemeData.neutral50),
                                                  ),
                                                ),
                                              );
                                  },
                                  connectorBuilder: (context, index, connectorType) {
                                    return DashedLineConnector(
                                      color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300,
                                      gap: 4,
                                    );
                                  },
                                  contentsBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                      child: Text(
                                        "${controller.locationData[index].location}",
                                        style: AppThemeData.mediumTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                      ),
                                    );
                                  },
                                  itemCount: controller.locationData.length,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          controller.bookingModel.value.driver == null || controller.userModel.value.userData!.isOwner != "true"
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
                                              imageUrl: controller.bookingModel.value.driver!.image.toString(),
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
                                                  "${controller.bookingModel.value.driver!.prenom} ${controller.bookingModel.value.driver!.nom}".tr,
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
                                                        "${controller.bookingModel.value.driver!.averageRating}",
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
                          controller.bookingModel.value.user == null
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
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 10),
                                          child: Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: NetworkImageWidget(
                                                  imageUrl: controller.bookingModel.value.user!.image.toString(),
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
                                                      '${controller.bookingModel.value.user!.prenom} ${controller.bookingModel.value.user!.nom}'.tr,
                                                      textAlign: TextAlign.start,
                                                      style: AppThemeData.boldTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Container(
                                                      width: 80,
                                                      decoration:
                                                          BoxDecoration(borderRadius: BorderRadius.circular(30), color: themeChange.getThem() ? AppThemeData.successLight : AppThemeData.successLight),
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
                                                              "${controller.bookingModel.value.user!.averageRating}",
                                                              style:
                                                                  AppThemeData.mediumTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.successDefault : AppThemeData.successDefault),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              controller.bookingModel.value.statut == RideStatus.confirmed || controller.bookingModel.value.statut == RideStatus.onRide
                                                  ? Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            Constant.makePhoneCall(controller.bookingModel.value.user!.phone!);
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
                                                            Get.to(() => ConversationScreen(), arguments: {
                                                              "receiverId": controller.bookingModel.value.user!.id,
                                                              "orderId": controller.bookingModel.value.id,
                                                              "receiverName": "${controller.bookingModel.value.user!.prenom} ${controller.bookingModel.value.user!.nom}",
                                                              "receiverPhoto": controller.bookingModel.value.user!.image
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
                                              Get.to(() => RatingScreen(), arguments: {"bookingType": "ride", "bookingModel": controller.bookingModel.value})!.then(
                                                (value) {
                                                  if (value != null) {
                                                    if (value == true) {
                                                      controller.getPusherBookingData();
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
                                    "Booking Details".tr,
                                    style: AppThemeData.boldTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                  ),
                                  Divider(color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Booking Date and Time:".tr,
                                          style: AppThemeData.mediumTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text(
                                          controller.bookingModel.value.creer.toString(),
                                          style: AppThemeData.boldTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
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
                                          Constant().amountShow(amount: (double.parse(controller.subTotal.value) - double.parse(controller.bumpAmount.value)).toString()),
                                          textAlign: TextAlign.end,
                                          style: AppThemeData.boldTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  if (double.parse(controller.bumpAmount.value) > 0 && controller.bumpAmount.value != "null")
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            "Increased fare rate".tr,
                                            style: AppThemeData.mediumTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            Constant().amountShow(amount: controller.bumpAmount.value.toString()),
                                            textAlign: TextAlign.end,
                                            style: AppThemeData.boldTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (double.parse(controller.bumpAmount.value) > 0 && controller.bumpAmount.value != "null")
                                    SizedBox(
                                      height: 10,
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Discount ${controller.bookingModel.value.discountType == null ? "" : controller.bookingModel.value.discountType!.type.toString() == "Percentage" ? " (${controller.bookingModel.value.discountType!.value}%)" : Constant().amountShow(amount: controller.bookingModel.value.discountType!.value)}'
                                                .tr,
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
                                  controller.bookingModel.value.tax != null
                                      ? ListView.builder(
                                          itemCount: controller.bookingModel.value.tax!.length,
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          itemBuilder: (context, index) {
                                            TaxModel taxModel = controller.bookingModel.value.tax![index];
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
                                                                .calculateTax(
                                                                    amount: ((double.parse(controller.subTotal.value)) - (double.parse(controller.discount.value))).toString(), taxModel: taxModel)
                                                                .toString())
                                                        .tr,
                                                    textAlign: TextAlign.start,
                                                    style: AppThemeData.semiBoldTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark700 : AppThemeData.neutral700),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        )
                                      : SizedBox(),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          "Total Payable Amount".tr,
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
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          "Payment Method:".tr,
                                          style: AppThemeData.mediumTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "${controller.bookingModel.value.paymentMethod}",
                                          textAlign: TextAlign.end,
                                          style: AppThemeData.boldTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  (controller.userModel.value.userData!.ownerId != null && controller.userModel.value.userData!.ownerId!.isNotEmpty) ||
                                          controller.bookingModel.value.statut == RideStatus.newRide
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
                                                            adminCommission: controller.bookingModel.value.adminCommissionType,
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
                          controller.userModel.value.userData!.ownerId != null && controller.userModel.value.userData!.ownerId!.isNotEmpty || controller.bookingModel.value.statut == RideStatus.newRide
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
            bottomNavigationBar: controller.userModel.value.userData!.isOwner == "true"
                ? SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 30),
                    child: controller.bookingModel.value.statut == RideStatus.canceled ||
                            controller.bookingModel.value.statut == RideStatus.completed ||
                            controller.bookingModel.value.statut == RideStatus.rejected
                        ? SizedBox()
                        : controller.bookingModel.value.statut == RideStatus.confirmed
                            ? Row(
                                children: [
                                  Expanded(
                                    child: RoundedButtonFill(
                                      title: "Reached Location".tr,
                                      height: 5.5,
                                      color: themeChange.getThem() ? AppThemeData.successDefault : AppThemeData.successDefault,
                                      textColor: themeChange.getThem() ? AppThemeData.neutral50 : AppThemeData.neutral50,
                                      onPress: () async {
                                        showVerifyPassengerDialog(context, themeChange, controller);
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.to(LiveTrackingScreen(), arguments: {'orderModel': controller.bookingModel.value});
                                    },
                                    child: SvgPicture.asset(
                                      "assets/icons/ic_livetracking.svg",
                                      width: 42,
                                    ),
                                  ),
                                ],
                              )
                            : controller.bookingModel.value.statut == RideStatus.onRide
                                ? RoundedButtonFill(
                                    title: controller.bookingModel.value.paymentMethod == "Cash" ? "Confirm Cash Payment".tr : "Payment Pending".tr,
                                    height: 5.5,
                                    color: themeChange.getThem() ? AppThemeData.errorDefault : AppThemeData.errorDefault,
                                    textColor: themeChange.getThem() ? AppThemeData.neutral50 : AppThemeData.neutral50,
                                    onPress: () async {
                                      if (controller.bookingModel.value.paymentMethod == "Cash") {
                                        conformCashPayment(context, themeChange, controller);
                                      } else {
                                        ShowToastDialog.showToast("Payment is pending from customer");
                                      }
                                    },
                                  )
                                : controller.bookingModel.value.statut == RideStatus.newRide
                                    ? Row(
                                        children: [
                                          Expanded(
                                            child: RoundedButtonFill(
                                              title: "Reject".tr,
                                              height: 5.5,
                                              color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300,
                                              textColor: themeChange.getThem() ? AppThemeData.neutralDark500 : AppThemeData.neutral500,
                                              onPress: () async {
                                                controller.rejectBooking(controller.bookingModel.value.id.toString());
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                            child: RoundedButtonFill(
                                              title: "Accept".tr,
                                              height: 5.5,
                                              color: AppThemeData.successDefault,
                                              textColor: AppThemeData.neutral50,
                                              onPress: () async {
                                                controller.acceptBooking(controller.bookingModel.value.id.toString());
                                              },
                                            ),
                                          ),
                                        ],
                                      )
                                    : SizedBox(),
                  ),
          );
        });
  }

  void showVerifyPassengerDialog(BuildContext context, DarkThemeProvider themeChange, BookingDetailsController controller) {
    if (Constant.rideOtp == "no") {
      controller.onRideStatus();
      return;
    }
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SizedBox(
          width: Responsive.width(80, context),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(child: Text("Verify Passenger", style: AppThemeData.boldTextStyle(fontSize: 22, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900))),
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(Icons.close),
                    )
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  "Enter the OTP shared by the customer to begin the trip",
                  textAlign: TextAlign.start,
                  style: AppThemeData.mediumTextStyle(color: themeChange.getThem() ? AppThemeData.neutralDark500 : AppThemeData.neutral500, fontSize: 14),
                ),
                SizedBox(height: 20),
                Pinput(
                  scrollPadding: EdgeInsets.zero,
                  controller: controller.otpController.value,
                  defaultPinTheme: PinTheme(
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    height: 42,
                    width: 50,
                    textStyle: AppThemeData.mediumTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(50),
                      color: themeChange.getThem() ? AppThemeData.neutralDark100 : AppThemeData.neutral100,
                      border: Border.all(color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300, width: 0.8),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  length: 6,
                ),
                SizedBox(height: 25),
                RoundedButtonFill(
                  title: "Start Ride".tr,
                  height: 5.5,
                  color: AppThemeData.primaryDefault,
                  textColor: AppThemeData.neutral50,
                  onPress: () async {
                    controller.onRideStatus();
                  },
                )
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  void conformCashPayment(BuildContext context, DarkThemeProvider themeChange, BookingDetailsController controller) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SizedBox(
          width: Responsive.width(80, context),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Text("Confirm Cash Collection", style: AppThemeData.boldTextStyle(fontSize: 20, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900))),
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(Icons.close),
                    )
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  "Please confirm that you have received the full cash amount from the customer before continuing.",
                  textAlign: TextAlign.start,
                  style: AppThemeData.mediumTextStyle(color: themeChange.getThem() ? AppThemeData.neutralDark500 : AppThemeData.neutral500, fontSize: 14),
                ),
                SizedBox(height: 25),
                RoundedButtonFill(
                  title: "Ride Completed".tr,
                  height: 5.5,
                  color: AppThemeData.successDefault,
                  textColor: AppThemeData.neutral50,
                  onPress: () async {
                    controller.completeBooking();
                  },
                )
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}
