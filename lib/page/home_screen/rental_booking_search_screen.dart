import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/ride_satatus.dart';
import 'package:cabme_driver/controller/rental_booking_search_controller.dart';
import 'package:cabme_driver/model/rental_booking_model.dart';
import 'package:cabme_driver/page/chats_screen/conversation_screen.dart';
import 'package:cabme_driver/themes/app_them_data.dart';
import 'package:cabme_driver/themes/responsive.dart';
import 'package:cabme_driver/utils/dark_theme_provider.dart';
import 'package:cabme_driver/utils/network_image_widget.dart';
import 'package:cabme_driver/widget/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:timelines_plus/timelines_plus.dart';

import '../../widget/round_button_fill.dart';

class RentalBookingSearchScreen extends StatelessWidget {
  const RentalBookingSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: RentalBookingSearchController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              titleSpacing: 0,
              centerTitle: false,
            ),
            body: controller.isLoading.value
                ? Constant.loader(context)
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: controller.rentalBookingData.isEmpty
                        ? Constant.showEmptyView(message: "No Rental booking available")
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller.rentalBookingData.length,
                            itemBuilder: (context, index) {
                              RentalBookingData rentalBookingData = controller.rentalBookingData[index];
                              return InkWell(
                                onTap: () {},
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
                                                  decoration:
                                                      BoxDecoration(borderRadius: BorderRadius.circular(30), color: themeChange.getThem() ? AppThemeData.successLight : AppThemeData.successLight),
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
                                                        Constant.makePhoneCall(rentalBookingData.user!.phone!);
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
                                                      'includingUnit'.trParams({
                                                        'unit': 'unit_${Constant.distanceUnit}'.tr,
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
                                          ? Row(
                                              children: [
                                                Expanded(
                                                  child: RoundedButtonFill(
                                                    title: "Reached Location".tr,
                                                    height: 5.5,
                                                    color: themeChange.getThem() ? AppThemeData.successDefault : AppThemeData.successDefault,
                                                    textColor: themeChange.getThem() ? AppThemeData.neutral50 : AppThemeData.neutral50,
                                                    onPress: () async {
                                                      // showVerifyPassengerDialog(context, themeChange, controller);
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                InkWell(
                                                  onTap: () {},
                                                  child: SvgPicture.asset(
                                                    "assets/icons/ic_livetracking.svg",
                                                    width: 36,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : rentalBookingData.status == RideStatus.onRide
                                              ? RoundedButtonFill(
                                                  title: "Payment Pending".tr,
                                                  height: 5.5,
                                                  color: themeChange.getThem() ? AppThemeData.errorDefault : AppThemeData.errorDefault,
                                                  textColor: themeChange.getThem() ? AppThemeData.neutral50 : AppThemeData.neutral50,
                                                  onPress: () async {
                                                    // if (rentalBookingData.paymentMethod == "Cash") {
                                                    //   conformCashPayment(context, themeChange, controller);
                                                    // } else {
                                                    //   ShowToastDialog.showToast(
                                                    //       "Payment is pending from customer via ${rentalBookingData.paymentMethodName}");
                                                    // }
                                                  },
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
                                                          controller.rejectedRentalBooking(rentalBookingData.id.toString());
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
                                                          controller.acceptRentalBooking(rentalBookingData.id.toString());
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
          );
        });
  }
}
