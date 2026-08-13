import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/ride_satatus.dart';
import 'package:cabme_driver/controller/parcel_details_controller.dart';
import 'package:cabme_driver/page/chats_screen/conversation_screen.dart';
import 'package:cabme_driver/page/rating_screen/rating_screen.dart';
import 'package:cabme_driver/themes/app_them_data.dart';
import 'package:cabme_driver/themes/responsive.dart';
import 'package:cabme_driver/utils/dark_theme_provider.dart';
import 'package:cabme_driver/utils/network_image_widget.dart';
import 'package:cabme_driver/widget/parcel_map_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:timelines_plus/timelines_plus.dart';

import '../../model/tax_model.dart' show TaxModel;

class ParcelDetailsScreen extends StatelessWidget {
  const ParcelDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: ParcelDetailsController(),
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
                controller.parcelBookingData.value.bookingNumber ?? "#${controller.parcelBookingData.value.id}",
                style: AppThemeData.semiBoldTextStyle(
                    fontSize: 18, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
              ),
            ),
            body: Padding(
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
                      child: ParcelMapView(),
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
                                          decoration:
                                              BoxDecoration(color: AppThemeData.neutral900, borderRadius: BorderRadius.circular(40)),
                                          child: Center(
                                            child: Text(
                                              String.fromCharCode(index - 1 + 65),
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: AppThemeData.regular,
                                                  color: themeChange.getThem() ? AppThemeData.neutral50 : AppThemeData.neutral50),
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
                                  style: AppThemeData.mediumTextStyle(
                                      fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
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
                    controller.parcelBookingData.value.driver == null || controller.userModel.value.userData!.isOwner != "true"
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
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: NetworkImageWidget(
                                        imageUrl: controller.parcelBookingData.value.driver!.image.toString(),
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
                                            "${controller.parcelBookingData.value.driver!.prenom} ${controller.parcelBookingData.value.driver!.nom}"
                                                .tr,
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
                                                  "${controller.parcelBookingData.value.driver!.averageRating}",
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
                              "Customer Details",
                              style: AppThemeData.boldTextStyle(
                                  fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                            ),
                            Divider(color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: NetworkImageWidget(
                                      imageUrl: controller.parcelBookingData.value.user!.image.toString(),
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
                                          '${controller.parcelBookingData.value.user!.prenom} ${controller.parcelBookingData.value.user!.nom}'
                                              .tr,
                                          textAlign: TextAlign.start,
                                          style: AppThemeData.boldTextStyle(
                                              fontSize: 16,
                                              color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          width: 70,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(30),
                                              color: themeChange.getThem() ? AppThemeData.successLight : AppThemeData.successLight),
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
                                                  "${controller.parcelBookingData.value.user!.averageRating}",
                                                  style: AppThemeData.mediumTextStyle(
                                                      fontSize: 14,
                                                      color: themeChange.getThem()
                                                          ? AppThemeData.successDefault
                                                          : AppThemeData.successDefault),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  controller.parcelBookingData.value.status == RideStatus.confirmed ||
                                          controller.parcelBookingData.value.status == RideStatus.onRide
                                      ? Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Constant.makePhoneCall(controller.parcelBookingData.value.user!.phone!);
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
                                                  "receiverId": controller.parcelBookingData.value.user!.id,
                                                  "orderId": controller.parcelBookingData.value.id,
                                                  "receiverName":
                                                      "${controller.parcelBookingData.value.user!.prenom} ${controller.parcelBookingData.value.user!.nom}",
                                                  "receiverPhoto": controller.parcelBookingData.value.user!.image
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
                                  Get.to(() => RatingScreen(),
                                          arguments: {"bookingType": "parcel", "parcelBookingModel": controller.parcelBookingData.value})!
                                      .then(
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
                                      style: AppThemeData.boldTextStyle(
                                          fontSize: 16, color: themeChange.getThem() ? AppThemeData.accentDark : AppThemeData.accentDark),
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
                              "Parcel Details",
                              style: AppThemeData.boldTextStyle(
                                  fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                            ),
                            Divider(color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Parcel Category'.tr,
                                      textAlign: TextAlign.start,
                                      style: AppThemeData.mediumTextStyle(
                                          fontSize: 14,
                                          color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      NetworkImageWidget(
                                        imageUrl: controller.parcelBookingData.value.parcelTypeImage.toString(),
                                        height: 20,
                                        width: 20,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        controller.parcelBookingData.value.parcelType.toString().tr,
                                        textAlign: TextAlign.start,
                                        style: AppThemeData.mediumTextStyle(
                                            fontSize: 14,
                                            color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: controller.parcelBookingData.value.parcelImage!.isNotEmpty,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: SizedBox(
                                  height: 100,
                                  width: Responsive.width(100, context),
                                  child: ListView.builder(
                                    itemCount: controller.parcelBookingData.value.parcelImage!.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 16),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: SizedBox(
                                            width: 100,
                                            height: 100.0,
                                            child: NetworkImageWidget(
                                              imageUrl: controller.parcelBookingData.value.parcelImage![index],
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
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
                              "Sender Details",
                              style: AppThemeData.boldTextStyle(
                                  fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                            ),
                            Divider(color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${controller.parcelBookingData.value.senderName}'.tr,
                                          textAlign: TextAlign.start,
                                          style: AppThemeData.boldTextStyle(
                                              fontSize: 16,
                                              color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          '${controller.parcelBookingData.value.source}'.tr,
                                          textAlign: TextAlign.start,
                                          style: AppThemeData.mediumTextStyle(
                                              fontSize: 14,
                                              color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                        ),
                                      ],
                                    ),
                                  ),
                                  controller.parcelBookingData.value.status == RideStatus.confirmed ||
                                          controller.parcelBookingData.value.status == RideStatus.onRide
                                      ? InkWell(
                                          onTap: () {
                                            Constant.makePhoneCall(controller.parcelBookingData.value.senderPhone!);
                                          },
                                          child: SvgPicture.asset(
                                            "assets/icons/ic_phone_dial.svg",
                                            width: 36,
                                          ),
                                        )
                                      : SizedBox()
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
                              "Receiver Details",
                              style: AppThemeData.boldTextStyle(
                                  fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                            ),
                            Divider(color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${controller.parcelBookingData.value.receiverName}'.tr,
                                          textAlign: TextAlign.start,
                                          style: AppThemeData.boldTextStyle(
                                              fontSize: 16,
                                              color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          '${controller.parcelBookingData.value.destination}'.tr,
                                          textAlign: TextAlign.start,
                                          style: AppThemeData.mediumTextStyle(
                                              fontSize: 14,
                                              color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                        ),
                                      ],
                                    ),
                                  ),
                                  controller.parcelBookingData.value.status == RideStatus.confirmed ||
                                          controller.parcelBookingData.value.status == RideStatus.onRide
                                      ? InkWell(
                                          onTap: () {
                                            Constant.makePhoneCall(controller.parcelBookingData.value.receiverPhone!);
                                          },
                                          child: SvgPicture.asset(
                                            "assets/icons/ic_phone_dial.svg",
                                            width: 36,
                                          ),
                                        )
                                      : SizedBox()
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
                              "About Parcel Details",
                              style: AppThemeData.boldTextStyle(
                                  fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                            ),
                            Divider(color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Weight (kg)",
                                      style: AppThemeData.mediumTextStyle(
                                          fontSize: 14,
                                          color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                    ),
                                  ),
                                  Text(
                                    "${controller.parcelBookingData.value.parcelWeight} KG",
                                    style: AppThemeData.boldTextStyle(
                                        fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Size(ft)",
                                      style: AppThemeData.mediumTextStyle(
                                          fontSize: 14,
                                          color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                    ),
                                  ),
                                  Text(
                                    "${controller.parcelBookingData.value.parcelDimension} ft",
                                    style: AppThemeData.boldTextStyle(
                                        fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                  ),
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
                              "Parcel Details",
                              style: AppThemeData.boldTextStyle(
                                  fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                            ),
                            Divider(color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Booking Date and Time:",
                                      style: AppThemeData.mediumTextStyle(
                                          fontSize: 14,
                                          color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                    ),
                                  ),
                                  Text(
                                    "${controller.parcelBookingData.value.createdAt}",
                                    style: AppThemeData.boldTextStyle(
                                        fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Pickup Date and Time:",
                                      style: AppThemeData.mediumTextStyle(
                                          fontSize: 14,
                                          color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                    ),
                                  ),
                                  Text(
                                    "${controller.parcelBookingData.value.parcelDate} ${controller.parcelBookingData.value.parcelTime}",
                                    style: AppThemeData.boldTextStyle(
                                        fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Dropped Date and Time:",
                                      style: AppThemeData.mediumTextStyle(
                                          fontSize: 14,
                                          color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                    ),
                                  ),
                                  Text(
                                    "${controller.parcelBookingData.value.receiveDate} ${controller.parcelBookingData.value.receiveTime}",
                                    style: AppThemeData.boldTextStyle(
                                        fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                  ),
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
                              style: AppThemeData.boldTextStyle(
                                  fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                            ),
                            Divider(color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "Ride Cost".tr,
                                    style: AppThemeData.mediumTextStyle(
                                        fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    Constant().amountShow(amount: controller.subTotal.value),
                                    textAlign: TextAlign.end,
                                    style: AppThemeData.boldTextStyle(
                                        fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
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
                                      style: AppThemeData.semiBoldTextStyle(
                                          fontSize: 16,
                                          color: themeChange.getThem() ? AppThemeData.neutralDark700 : AppThemeData.neutral700),
                                    ),
                                  ),
                                  Text(
                                    Constant().amountShow(amount: controller.discount.value).tr,
                                    textAlign: TextAlign.start,
                                    style: AppThemeData.semiBoldTextStyle(
                                        fontSize: 16, color: themeChange.getThem() ? AppThemeData.errorDefault : AppThemeData.errorDefault),
                                  ),
                                ],
                              ),
                            ),
                            ListView.builder(
                              itemCount: controller.parcelBookingData.value.tax!.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                TaxModel taxModel = controller.parcelBookingData.value.tax![index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${taxModel.libelle} (${taxModel.value} ${taxModel.type == "Fixed" ? "${Constant.currency}" : "%"})'
                                              .tr,
                                          textAlign: TextAlign.start,
                                          style: AppThemeData.semiBoldTextStyle(
                                              fontSize: 16,
                                              color: themeChange.getThem() ? AppThemeData.neutralDark700 : AppThemeData.neutral700),
                                        ),
                                      ),
                                      Text(
                                        Constant()
                                            .amountShow(
                                                amount: Constant()
                                                    .calculateTax(
                                                        amount: (double.parse(controller.subTotal.value) -
                                                                double.parse(controller.discount.value))
                                                            .toString(),
                                                        taxModel: taxModel)
                                                    .toString())
                                            .tr,
                                        textAlign: TextAlign.start,
                                        style: AppThemeData.semiBoldTextStyle(
                                            fontSize: 16,
                                            color: themeChange.getThem() ? AppThemeData.neutralDark700 : AppThemeData.neutral700),
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
                                    "Total Paid Amount",
                                    style: AppThemeData.mediumTextStyle(
                                        fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    Constant().amountShow(amount: controller.totalAmount.value),
                                    textAlign: TextAlign.end,
                                    style: AppThemeData.boldTextStyle(
                                        fontSize: 16, color: themeChange.getThem() ? AppThemeData.accentDark : AppThemeData.accentDark),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            (controller.userModel.value.userData!.ownerId != null && controller.userModel.value.userData!.ownerId!.isNotEmpty) || controller.parcelBookingData.value.status == RideStatus.newRide
                                ? SizedBox()
                                : Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          "Admin commission:",
                                          style: AppThemeData.mediumTextStyle(
                                              fontSize: 16,
                                              color: themeChange.getThem() ? AppThemeData.errorDefault : AppThemeData.errorDefault),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text(
                                          Constant().amountShow(
                                              amount: Constant.calculateAdminCommission(
                                                      adminCommission: controller.parcelBookingData.value.adminCommissionType,
                                                      amount: (double.parse(controller.subTotal.value) -
                                                              double.parse(controller.discount.value))
                                                          .toString())
                                                  .toString()),
                                          textAlign: TextAlign.end,
                                          style: AppThemeData.boldTextStyle(
                                              fontSize: 16,
                                              color: themeChange.getThem() ? AppThemeData.errorDefault : AppThemeData.errorDefault),
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
                    controller.userModel.value.userData!.ownerId != null && controller.userModel.value.userData!.ownerId!.isNotEmpty  || controller.parcelBookingData.value.status == RideStatus.newRide
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
                                    style: AppThemeData.boldTextStyle(
                                        fontSize: 16, color: themeChange.getThem() ? AppThemeData.errorDefault : AppThemeData.errorDefault),
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
