import 'dart:convert';
import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/ride_satatus.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/controller/home_controller.dart';
import 'package:cabme_driver/model/parcel_bokking_model.dart';
import 'package:cabme_driver/model/rental_booking_model.dart';
import 'package:cabme_driver/model/user_model.dart';
import 'package:cabme_driver/page/auth_screens/vehicle_info_screen.dart';
import 'package:cabme_driver/page/booking_details_screens/booking_details_screen.dart';
import 'package:cabme_driver/page/booking_details_screens/parcel_details_screen.dart';
import 'package:cabme_driver/page/chats_screen/conversation_screen.dart';
import 'package:cabme_driver/page/document_status/document_status_screen.dart';
import 'package:cabme_driver/page/home_screen/parcel_search_screen.dart';
import 'package:cabme_driver/page/home_screen/rental_booking_search_screen.dart';
import 'package:cabme_driver/page/live_tracking_screen/live_tracking_screen.dart';
import 'package:cabme_driver/page/rental_details_screen/rental_details_screen.dart';
import 'package:cabme_driver/service/api.dart';
import 'package:cabme_driver/themes/app_them_data.dart';
import 'package:cabme_driver/themes/responsive.dart';
import 'package:cabme_driver/themes/text_field_widget.dart';
import 'package:cabme_driver/utils/dark_theme_provider.dart';
import 'package:cabme_driver/utils/network_image_widget.dart';
import 'package:cabme_driver/widget/blink_background.dart';
import 'package:cabme_driver/widget/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:timelines_plus/timelines_plus.dart';

import '../../widget/round_button_fill.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: HomeController(),
        initState: (state) {
          final controller = Get.find<HomeController>();
          controller.getBookingData();
        },
        builder: (controller) {
          final availableTabs = getAvailableTabs(controller.userModel.value.userData?.serviceType ?? []);
          final selectedType = controller.selectedTabType.value;
          controller.setAvailableTabs(availableTabs);

          return Scaffold(
            backgroundColor: themeChange.getThem() ? AppThemeData.neutralDark50 : AppThemeData.neutral50,
            appBar: AppBar(
              backgroundColor: themeChange.getThem() ? AppThemeData.neutralDark50 : AppThemeData.neutral50,
              centerTitle: false,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'welcomeUser'.trParams({
                      'first': controller.userModel.value.userData!.prenom.toString(),
                      'last': controller.userModel.value.userData!.nom.toString(),
                    }),
                    style: AppThemeData.semiBoldTextStyle(
                      fontSize: 16,
                      color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                    ),
                  ),
                  Text(
                    'Ready to drive?'.tr,
                    style: AppThemeData.mediumTextStyle(
                      fontSize: 12,
                      color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                    ),
                  )
                ],
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        'Status'.tr,
                        style: AppThemeData.boldTextStyle(
                          fontSize: 14,
                          color: themeChange.getThem() ? AppThemeData.neutralDark500 : AppThemeData.neutral500,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        height: 34, // smaller than default
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: CupertinoSwitch(
                            value: controller.status.value,
                            activeTrackColor: AppThemeData.accentDefault,
                            thumbColor: themeChange.getThem() ? AppThemeData.neutralDark50 : AppThemeData.neutral50,
                            onChanged: (bool value) {
                              if (value == false) {
                                controller.changeStatus(value);
                              } else {
                                if (controller.userModel.value.userData?.ownerId != null && controller.userModel.value.userData!.ownerId!.isNotEmpty) {
                                  if (controller.userModel.value.userData!.statutVehicule == "no") {
                                    ShowToastDialog.showToast("You don’t have any vehicle assigned. Please contact your owner to get one assigned.");
                                  } else {
                                    controller.changeStatus(value);
                                  }
                                } else {
                                  if (controller.userModel.value.userData!.statutVehicule == "no") {
                                    showAlertDialog(themeChange, context, "vehicleInformation", controller);
                                  } else if (Constant.driverDocVerification == "yes" && controller.userModel.value.userData?.isVerified == "no") {
                                    showAlertDialog(themeChange, context, "document", controller);
                                  } else {
                                    controller.changeStatus(value);
                                  }
                                }
                              }
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            body: controller.isLoading.value
                ? Constant.loader(context)
                : Column(
                    children: [
                      shouldShowWalletError(controller.userModel.value.userData!)
                          ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Container(
                                width: Responsive.width(100, context),
                                decoration: BoxDecoration(
                                  color: themeChange.getThem() ? AppThemeData.errorLight : AppThemeData.errorLight,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                                  child: Text("You need at least ${Constant().amountShow(amount: Constant.minimumWalletBalance)} in your wallet to receive rides.",
                                      style: AppThemeData.mediumTextStyle(
                                        fontSize: 14,
                                        color: themeChange.getThem() ? AppThemeData.errorDark : AppThemeData.errorDark,
                                      )),
                                ),
                              ),
                            )
                          : SizedBox(),
                      availableTabs.isNotEmpty
                          ? Container(
                              height: 55,
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: ShapeDecoration(
                                color: themeChange.getThem() ? AppThemeData.neutralDark50 : AppThemeData.neutral50,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(36)),
                                shadows: [
                                  BoxShadow(
                                    color: themeChange.getThem() ? AppThemeData.neutralDark200 : Color(0x14000000),
                                    blurRadius: 23,
                                    offset: Offset(0, 0),
                                    spreadRadius: 0,
                                  )
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Row(
                                  children: List.generate(availableTabs.length, (index) {
                                    final tab = availableTabs[index];
                                    final isSelected = selectedType == tab;

                                    String getLabel(String key) {
                                      switch (key) {
                                        case 'ride':
                                          return 'Cab Booking'.tr;
                                        case 'parcel':
                                          return 'Parcel Delivery'.tr;
                                        case 'rental':
                                          return 'Rental'.tr;
                                        default:
                                          return '';
                                      }
                                    }

                                    return Expanded(
                                      child: GestureDetector(
                                        onTap: () => controller.updateTabType(tab),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: isSelected ? AppThemeData.accentDefault : Colors.transparent,
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            getLabel(tab),
                                            style: AppThemeData.boldTextStyle(
                                              color: isSelected
                                                  ? AppThemeData.neutral50
                                                  : themeChange.getThem()
                                                      ? AppThemeData.neutralDark900
                                                      : AppThemeData.neutral900,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            )
                          : SizedBox(),
                      Obx(() {
                        switch (controller.selectedTabType.value) {
                          case 'ride':
                            return bookingView(themeChange, context, controller);
                          case 'parcel':
                            return parcelView(themeChange, context, controller);
                          case 'rental':
                            return rentalView(themeChange, context, controller);
                          default:
                            return SizedBox();
                        }
                      }),
                    ],
                  ),
          );
        });
  }

  bool shouldShowWalletError(UserData user) {
    final double walletAmount = double.tryParse(user.amount.toString()) ?? 0.0;
    final double minBalance = double.tryParse(Constant.minimumWalletBalance.toString()) ?? 0.0;

    final bool isIndependentDriver = user.ownerId == null || user.ownerId!.isEmpty;

    return walletAmount < minBalance && isIndependentDriver;
  }

  List<String> getAvailableTabs(List<dynamic> userServices) {
    // Priority: ride must always be shown if available
    List<String> tabs = [];

    if (userServices.contains('ride')) {
      tabs.add('ride');
    }
    if (userServices.contains('parcel')) {
      tabs.add('parcel');
    }
    if (userServices.contains('rental')) {
      tabs.add('rental');
    }

    return tabs;
  }

  Widget bookingView(DarkThemeProvider themeChange, BuildContext context, HomeController controller) {
    return Obx(
      () => controller.bookingModel.value.data == null
          ? Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/images/empty_parcel.svg"),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'No Booking requests available in your selected zone.'.tr,
                        textAlign: TextAlign.center,
                        style: AppThemeData.mediumTextStyle(
                          fontSize: 18,
                          color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await controller.getBooking(); // Make sure this method reloads bookings
                },
                child: SingleChildScrollView(
                  child: InkWell(
                    onTap: () {
                      Get.to(BookingDetailsScreen(), arguments: {'bookingModel': controller.bookingModel.value.data})!.then(
                        (value) {
                          if (value == true) {
                            controller.getBooking();
                          }
                        },
                      );
                    },
                    child: Container(
                      width: Responsive.width(100, context),
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(16),
                      decoration: ShapeDecoration(
                        color: themeChange.getThem() ? AppThemeData.neutralDark50 : AppThemeData.neutral50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        shadows: [
                          BoxShadow(
                            color: themeChange.getThem() ? AppThemeData.neutralDark200 : Color(0x14000000),
                            blurRadius: 23,
                            offset: Offset(0, 0),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              ClipOval(
                                child: NetworkImageWidget(
                                  imageUrl: controller.bookingModel.value.data!.user!.image.toString(),
                                  width: 52,
                                  height: 52,
                                  fit: BoxFit.cover,
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
                                      '${controller.bookingModel.value.data!.user!.prenom} ${controller.bookingModel.value.data!.user!.nom}'.tr,
                                      textAlign: TextAlign.start,
                                      style: AppThemeData.boldTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      width: 75,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: themeChange.getThem() ? AppThemeData.successLight : AppThemeData.successLight),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                                        child: Row(
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
                                              "${controller.bookingModel.value.data!.user!.averageRating}",
                                              style: AppThemeData.mediumTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.successDefault : AppThemeData.successDefault),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              controller.bookingModel.value.data!.statut == RideStatus.confirmed || controller.bookingModel.value.data!.statut == RideStatus.onRide
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Constant.makePhoneCall(controller.bookingModel.value.data!.user!.phone!);
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
                                              "receiverId": controller.bookingModel.value.data!.user!.id,
                                              "orderId": controller.bookingModel.value.data!.id,
                                              "receiverName": "${controller.bookingModel.value.data!.user!.prenom} ${controller.bookingModel.value.data!.user!.nom}",
                                              "receiverPhoto": controller.bookingModel.value.data!.user!.image
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
                          SizedBox(
                            height: 20,
                          ),
                          if (controller.bookingModel.value.data?.bumpAmount != null &&
                              double.parse(controller.bookingModel.value.data?.bumpAmount ?? '0.0') > 0 &&
                              controller.bookingModel.value.data?.statut?.toLowerCase() == 'new')
                            BlinkBackground(
                              beginColor: AppThemeData.neutral50,
                              endColor: AppThemeData.successDefault,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                child: Row(
                                  children: [
                                    // Info Icon
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: AppThemeData.successDarkDark,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.flash_on_rounded,
                                        color: AppThemeData.neutral50,
                                        size: 18,
                                      ),
                                    ),

                                    const SizedBox(width: 10),

                                    // Text
                                    Expanded(
                                      child: Text(
                                        "Customer increased fare rate : ${Constant().amountShow(amount: controller.bookingModel.value.data?.bumpAmount)}",
                                        style: AppThemeData.boldTextStyle(fontSize: 13, color: AppThemeData.neutral900),
                                      ),
                                    ),

                                    // Help Icon
                                  ],
                                ),
                              ),
                            ),
                          if (controller.bookingModel.value.data?.bumpAmount != null)
                            SizedBox(
                              height: 20,
                            ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    SvgPicture.asset("assets/icons/ic_distance.svg"),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '${double.parse(controller.bookingModel.value.data!.distance.toString()).toStringAsFixed(2)}${controller.bookingModel.value.data!.distanceUnit}  '.tr,
                                      textAlign: TextAlign.start,
                                      style: AppThemeData.boldTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    SvgPicture.asset("assets/icons/ic_amount.svg"),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      Constant().amountShow(amount: controller.totalAmount.value).tr,
                                      textAlign: TextAlign.start,
                                      style: AppThemeData.boldTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    SvgPicture.asset("assets/icons/ic_time.svg"),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '${controller.bookingModel.value.data!.duree}'.tr,
                                      textAlign: TextAlign.start,
                                      style: AppThemeData.boldTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 16),
                          DottedLine(
                            dashColor: Colors.grey,
                            lineThickness: 1.0,
                            dashLength: 4.0,
                            dashGapLength: 3.0,
                            direction: Axis.horizontal,
                          ),
                          const SizedBox(height: 16),
                          controller.bookingModel.value.data!.statut == RideStatus.confirmed
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
                                        Get.to(LiveTrackingScreen(), arguments: {'orderModel': controller.bookingModel.value.data});
                                      },
                                      child: SvgPicture.asset(
                                        "assets/icons/ic_livetracking.svg",
                                        width: 36,
                                      ),
                                    ),
                                  ],
                                )
                              : controller.bookingModel.value.data!.statut == RideStatus.onRide
                                  ? Row(
                                      children: [
                                        Expanded(
                                          child: RoundedButtonFill(
                                            title: controller.bookingModel.value.data?.paymentMethod == "Cash" ? "Confirm Cash Payment".tr : "Payment Pending".tr,
                                            height: 5.5,
                                            color: themeChange.getThem() ? AppThemeData.errorDefault : AppThemeData.errorDefault,
                                            textColor: themeChange.getThem() ? AppThemeData.neutral50 : AppThemeData.neutral50,
                                            onPress: () async {
                                              if (controller.bookingModel.value.data!.paymentMethod == "Cash") {
                                                conformCashPayment(context, themeChange, controller);
                                              } else {
                                                ShowToastDialog.showToast("Payment is pending from customer");
                                              }
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: RoundedButtonFill(
                                            title: "Live Tracking".tr,
                                            height: 5.5,
                                            color: themeChange.getThem() ? AppThemeData.primaryDefault : AppThemeData.primaryDefault,
                                            textColor: themeChange.getThem() ? AppThemeData.neutral50 : AppThemeData.neutral50,
                                            onPress: () async {
                                              Get.to(LiveTrackingScreen(), arguments: {'orderModel': controller.bookingModel.value.data});
                                            },
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        Expanded(
                                          child: RoundedButtonFill(
                                            title: "Reject".tr,
                                            height: 5.5,
                                            color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300,
                                            textColor: themeChange.getThem() ? AppThemeData.neutralDark500 : AppThemeData.neutral500,
                                            onPress: () async {
                                              controller.rejectBooking(controller.bookingModel.value.data!.id.toString());
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
                                              controller.acceptBooking(controller.bookingModel.value.data!.id.toString());
                                            },
                                          ),
                                        ),
                                      ],
                                    )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget parcelView(DarkThemeProvider themeChange, BuildContext context, HomeController controller) {
    return Obx(
      () => controller.parcelList.isEmpty
          ? Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/images/empty_parcel.svg"),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'No parcel requests available in your selected zone.'.tr,
                        textAlign: TextAlign.center,
                        style: AppThemeData.mediumTextStyle(
                          fontSize: 18,
                          color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Try changing the location or date.'.tr,
                        textAlign: TextAlign.center,
                        style: AppThemeData.mediumTextStyle(
                          fontSize: 14,
                          color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      RoundedButtonFill(
                        title: "Search Parcel".tr,
                        height: 5.5,
                        color: AppThemeData.primaryDefault,
                        textColor: AppThemeData.neutral50,
                        onPress: () {
                          Get.to(ParcelSearchScreen())!.then((value) {
                            if (value != null && value is bool && value) {
                              controller.getParcelList();
                            }
                          });
                        },
                      )
                    ],
                  ),
                ),
              ),
            )
          : Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await controller.getParcelList();
                },
                child: ListView.builder(
                  itemCount: controller.parcelList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    ParcelBookingData parcelBookingData = controller.parcelList[index];
                    return InkWell(
                      onTap: () {
                        Get.to(ParcelDetailsScreen(), arguments: {"parcelBookingData": parcelBookingData});
                      },
                      child: Container(
                        width: Responsive.width(100, context),
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(16),
                        decoration: ShapeDecoration(
                          color: themeChange.getThem() ? AppThemeData.neutralDark50 : AppThemeData.neutral50,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          shadows: [
                            BoxShadow(
                              color: themeChange.getThem() ? AppThemeData.neutralDark200 : Color(0x14000000),
                              blurRadius: 23,
                              offset: Offset(0, 0),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                          : index == 1
                                              ? SvgPicture.asset("assets/icons/ic_recevier.svg")
                                              : SizedBox();
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
                                          index == 0 ? "${parcelBookingData.source}" : "${parcelBookingData.destination}",
                                          style: AppThemeData.mediumTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                        ),
                                      );
                                    },
                                    itemCount: 2,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                ClipOval(
                                  child: NetworkImageWidget(
                                    imageUrl: parcelBookingData.user!.image.toString(),
                                    width: 52,
                                    height: 52,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${parcelBookingData.user!.prenom} ${parcelBookingData.user!.nom}'.tr,
                                      textAlign: TextAlign.start,
                                      style: AppThemeData.boldTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      width: 75,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: themeChange.getThem() ? AppThemeData.successLight : AppThemeData.successLight),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                                        child: Row(
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
                                              "${parcelBookingData.user!.averageRating}",
                                              style: AppThemeData.mediumTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.successDefault : AppThemeData.successDefault),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      SvgPicture.asset("assets/icons/ic_amount.svg"),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        Constant().amountShow(amount: controller.calculateParcelTotalAmountBooking(parcelBookingData)),
                                        textAlign: TextAlign.start,
                                        style: AppThemeData.semiBoldTextStyle(fontSize: 12, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      SvgPicture.asset("assets/images/ic_data.svg"),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        '${parcelBookingData.receiveDate}  '.tr,
                                        textAlign: TextAlign.start,
                                        style: AppThemeData.semiBoldTextStyle(fontSize: 12, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      NetworkImageWidget(
                                        imageUrl: parcelBookingData.parcelTypeImage.toString(),
                                        width: 20,
                                        height: 20,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        '${parcelBookingData.parcelType}'.tr,
                                        textAlign: TextAlign.start,
                                        style: AppThemeData.semiBoldTextStyle(fontSize: 12, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 16),
                            DottedLine(
                              dashColor: Colors.grey,
                              lineThickness: 1.0,
                              dashLength: 4.0,
                              dashGapLength: 3.0,
                              direction: Axis.horizontal,
                            ),
                            const SizedBox(height: 16),
                            parcelBookingData.status == RideStatus.confirmed
                                ? RoundedButtonFill(
                                    title: "Pickup Parcel".tr,
                                    height: 5.5,
                                    color: themeChange.getThem() ? AppThemeData.successDefault : AppThemeData.successDefault,
                                    textColor: themeChange.getThem() ? AppThemeData.neutral50 : AppThemeData.neutral50,
                                    onPress: () async {
                                      controller.pickUpParcelBooking(parcelBookingData);
                                    },
                                  )
                                : parcelBookingData.status == RideStatus.onRide
                                    ? RoundedButtonFill(
                                        title: "Deliver Parcel".tr,
                                        height: 5.5,
                                        color: themeChange.getThem() ? AppThemeData.errorDefault : AppThemeData.errorDefault,
                                        textColor: themeChange.getThem() ? AppThemeData.neutral50 : AppThemeData.neutral50,
                                        onPress: () async {
                                          controller.completeParcelBooking(parcelBookingData);
                                        },
                                      )
                                    : SizedBox()
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }

  Widget rentalView(DarkThemeProvider themeChange, BuildContext context, HomeController controller) {
    return Obx(
      () => controller.rentalBookingData.isEmpty
          ? Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/images/empty_parcel.svg"),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'No rental requests available in your selected zone.'.tr,
                        textAlign: TextAlign.center,
                        style: AppThemeData.mediumTextStyle(
                          fontSize: 18,
                          color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Try changing the location or date.',
                        textAlign: TextAlign.center,
                        style: AppThemeData.mediumTextStyle(
                          fontSize: 14,
                          color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      RoundedButtonFill(
                        title: "Search Rental Booking".tr,
                        height: 5.5,
                        color: AppThemeData.primaryDefault,
                        textColor: AppThemeData.neutral50,
                        onPress: () {
                          Get.to(RentalBookingSearchScreen())!.then((value) {
                            if (value != null && value is bool && value) {
                              controller.getRentalSearchBooking();
                            }
                          });
                        },
                      )
                    ],
                  ),
                ),
              ),
            )
          : Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await controller.getRentalSearchBooking();
                },
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.rentalBookingData.length,
                  itemBuilder: (context, index) {
                    RentalBookingData rentalBookingData = controller.rentalBookingData[index];
                    return InkWell(
                      onTap: () {
                        Get.to(RentalDetailsScreen(), arguments: {"rentalBookingData": rentalBookingData});
                      },
                      child: Container(
                        width: Responsive.width(100, context),
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(16),
                        decoration: ShapeDecoration(
                          color: themeChange.getThem() ? AppThemeData.neutralDark50 : AppThemeData.neutral50,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          shadows: [
                            BoxShadow(
                              color: themeChange.getThem() ? AppThemeData.neutralDark200 : Color(0x14000000),
                              blurRadius: 23,
                              offset: Offset(0, 0),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ClipOval(
                                  child: NetworkImageWidget(
                                    imageUrl: rentalBookingData.user!.image.toString(),
                                    width: 52,
                                    height: 52,
                                    fit: BoxFit.cover,
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
                                        '${rentalBookingData.user!.prenom} ${rentalBookingData.user!.nom}'.tr,
                                        textAlign: TextAlign.start,
                                        style: AppThemeData.boldTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        width: 75,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: themeChange.getThem() ? AppThemeData.successLight : AppThemeData.successLight),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                                          child: Row(
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
                                                "${rentalBookingData.user!.averageRating}",
                                                style: AppThemeData.mediumTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.successDefault : AppThemeData.successDefault),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                rentalBookingData.status == RideStatus.confirmed || rentalBookingData.status == RideStatus.onRide
                                    ? Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Constant.makePhoneCall(controller.bookingModel.value.data!.user!.phone!);
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
                                                "receiverId": rentalBookingData.user!.id,
                                                "orderId": rentalBookingData.id,
                                                "receiverName": "${rentalBookingData.user!.prenom} ${rentalBookingData.user!.nom}",
                                                "receiverPhoto": rentalBookingData.user!.image
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
                            const SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                color: themeChange.getThem() ? AppThemeData.neutralDark100 : AppThemeData.neutral100,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                child: Column(
                                  children: [
                                    Timeline.tileBuilder(
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
                                          return SvgPicture.asset("assets/icons/ic_sender.svg");
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
                                              "${rentalBookingData.departName}",
                                              style: AppThemeData.mediumTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                            ),
                                          );
                                        },
                                        itemCount: 1,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    DottedLine(
                                      dashColor: Colors.grey,
                                      lineThickness: 1.0,
                                      dashLength: 4.0,
                                      dashGapLength: 3.0,
                                      direction: Axis.horizontal,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Package Details:".tr,
                                            textAlign: TextAlign.start,
                                            style: AppThemeData.mediumTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                          ),
                                        ),
                                        Text(
                                          "${rentalBookingData.packageDetails!.title}".tr,
                                          textAlign: TextAlign.start,
                                          style: AppThemeData.semiBoldTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.primaryDark : AppThemeData.primaryDark),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'includingDistance'.trParams({
                                              'unit': Constant.distanceUnit.toString(),
                                            }),
                                            textAlign: TextAlign.start,
                                            style: AppThemeData.mediumTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                          ),
                                        ),
                                        Text(
                                          "${rentalBookingData.packageDetails!.includedDistance} ${Constant.distanceUnit}".tr,
                                          textAlign: TextAlign.start,
                                          style: AppThemeData.semiBoldTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.primaryDark : AppThemeData.primaryDark),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Including Duration:".tr,
                                            textAlign: TextAlign.start,
                                            style: AppThemeData.mediumTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                          ),
                                        ),
                                        Text(
                                          "${rentalBookingData.packageDetails!.includedHours} Hr".tr,
                                          textAlign: TextAlign.start,
                                          style: AppThemeData.semiBoldTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.primaryDark : AppThemeData.primaryDark),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      SvgPicture.asset("assets/icons/ic_amount.svg"),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        Constant().amountShow(amount: rentalBookingData.amount).tr,
                                        textAlign: TextAlign.start,
                                        style: AppThemeData.semiBoldTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      SvgPicture.asset("assets/icons/ic_date.svg"),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        '${rentalBookingData.startDate} ${rentalBookingData.startTime}'.tr,
                                        textAlign: TextAlign.start,
                                        style: AppThemeData.semiBoldTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 16),
                            rentalBookingData.status == RideStatus.confirmed
                                ? RoundedButtonFill(
                                    title: "Reached Location".tr,
                                    height: 5.5,
                                    color: themeChange.getThem() ? AppThemeData.successDefault : AppThemeData.successDefault,
                                    textColor: themeChange.getThem() ? AppThemeData.neutral50 : AppThemeData.neutral50,
                                    onPress: () async {
                                      showVerifyRentalPassengerDialog(context, themeChange, controller, rentalBookingData);
                                    },
                                  )
                                : rentalBookingData.status == RideStatus.onRide && double.parse(rentalBookingData.completeKm.toString()) < double.parse(rentalBookingData.currentKm.toString())
                                    ? RoundedButtonFill(
                                        title: "Set Final kilometers".tr,
                                        height: 5.5,
                                        color: themeChange.getThem() ? AppThemeData.infoDefault : AppThemeData.infoDefault,
                                        textColor: themeChange.getThem() ? AppThemeData.neutral50 : AppThemeData.neutral50,
                                        onPress: () async {
                                          setFinalKilometerDialog(context, themeChange, controller, rentalBookingData);
                                        },
                                      )
                                    : RoundedButtonFill(
                                        title: rentalBookingData.paymentMethod == "Cash" ? "Confirm Cash Payment".tr : "Payment Pending".tr,
                                        height: 5.5,
                                        color: themeChange.getThem() ? AppThemeData.errorDefault : AppThemeData.errorDefault,
                                        textColor: themeChange.getThem() ? AppThemeData.neutral50 : AppThemeData.neutral50,
                                        onPress: () async {
                                          if (rentalBookingData.paymentMethod == "Cash") {
                                            conformCashRentalPayment(context, themeChange, controller, rentalBookingData);
                                          } else {
                                            ShowToastDialog.showToast(
                                              'paymentPending'.trParams({
                                                'method': rentalBookingData.paymentMethod.toString(),
                                              }),
                                            );
                                          }
                                        },
                                      )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }

  void showVerifyPassengerDialog(BuildContext context, DarkThemeProvider themeChange, HomeController controller) {
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
                    Expanded(child: Text("Verify Passenger".tr, style: AppThemeData.boldTextStyle(fontSize: 22, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900))),
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
                  "Enter the OTP shared by the customer to begin the trip".tr,
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

  void showVerifyRentalPassengerDialog(BuildContext context, DarkThemeProvider themeChange, HomeController controller, RentalBookingData rentalBookingData) {
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
                    Expanded(child: Text("Verify Passenger".tr, style: AppThemeData.boldTextStyle(fontSize: 22, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900))),
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(Icons.close),
                    )
                  ],
                ),
                SizedBox(height: 8),
                Constant.rideOtp == "no"
                    ? SizedBox()
                    : Text(
                        "Enter the OTP shared by the customer to begin the trip".tr,
                        textAlign: TextAlign.start,
                        style: AppThemeData.mediumTextStyle(color: themeChange.getThem() ? AppThemeData.neutralDark500 : AppThemeData.neutral500, fontSize: 14),
                      ),
                SizedBox(height: 20),
                TextFieldWidget(
                  controller: controller.currentKilometerController.value,
                  hintText: 'Enter Current Kilometer reading'.tr,
                  title: ' Current Kilometer reading'.tr,
                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                ),
                SizedBox(height: 20),
                Constant.rideOtp == "no"
                    ? SizedBox()
                    : Pinput(
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
                    controller.onRideStatusRental(rentalBookingData.id.toString());
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

  void setFinalKilometerDialog(BuildContext context, DarkThemeProvider themeChange, HomeController controller, RentalBookingData rentalBookingData) {
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
                        child: Text("Enter Kilometer Reading", style: AppThemeData.boldTextStyle(fontSize: 22, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900))),
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(Icons.close),
                    )
                  ],
                ),
                SizedBox(height: 8),
                TextFieldWidget(
                  controller: controller.completeKilometerController.value,
                  hintText: 'Enter Current Kilometer reading',
                  title: ' Current Kilometer reading',
                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                ),
                SizedBox(height: 20),
                RoundedButtonFill(
                  title: "Save".tr,
                  height: 5.5,
                  color: AppThemeData.primaryDefault,
                  textColor: AppThemeData.neutral50,
                  onPress: () async {
                    controller.setFinalKilometerOfRental(rentalBookingData.id.toString());
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

  void conformCashPayment(BuildContext context, DarkThemeProvider themeChange, HomeController controller) {
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

  void conformCashRentalPayment(BuildContext context, DarkThemeProvider themeChange, HomeController controller, RentalBookingData rentalBookingData) {
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
                    Map<String, dynamic> requestBody = {
                      "id_rental": rentalBookingData.id,
                      "id_user": rentalBookingData.user!.id,
                      "id_driver": rentalBookingData.driver!.id,
                      "id_payment": rentalBookingData.idPaymentMethod.toString(),
                      "transaction_id": DateTime.now().microsecondsSinceEpoch.toString(),
                    };

                    print(requestBody);
                    await API.handleApiRequest(request: () => http.post(Uri.parse(API.rentalComplete), headers: API.headers, body: jsonEncode(requestBody)), showLoader: false).then(
                      (value) async {
                        if (value != null) {
                          if (value['success'] == "Failed" || value['success'] == "ailed") {
                            ShowToastDialog.showToast(value['error']);
                            return null;
                          } else {
                            await controller.getRentalSearchBooking();
                            Get.back();
                          }
                        }
                      },
                    );
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

  Future<void> showAlertDialog(themeChange, BuildContext context, String type, HomeController controller) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Information'.tr,
            style: AppThemeData.boldTextStyle(fontSize: 20, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'To start earning with CabMe you need to fill in your information'.tr,
                  style: AppThemeData.mediumTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            RoundedButtonFill(
              title: "No".tr,
              height: 5,
              width: 24,
              color: AppThemeData.neutral200,
              textColor: AppThemeData.neutral900,
              onPress: () async {
                Get.back();
              },
            ),
            RoundedButtonFill(
              title: "Yes".tr,
              height: 5,
              width: 24,
              color: AppThemeData.primaryDefault,
              textColor: AppThemeData.neutral50,
              onPress: () async {
                if (type == "document") {
                  Get.back();
                  Get.to(() => DocumentStatusScreen())!.then(
                    (value) {
                      if (value == true) {
                        controller.getUserData();
                      }
                    },
                  );
                } else {
                  Get.back();
                  Get.to(() => const VehicleInfoScreen())!.then(
                    (value) {
                      if (value == true) {
                        controller.getUserData();
                      }
                    },
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
