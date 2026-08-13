import 'dart:convert';

import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/ride_satatus.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/controller/booking_controller.dart';
import 'package:cabme_driver/model/booking_mode.dart';
import 'package:cabme_driver/model/parcel_bokking_model.dart';
import 'package:cabme_driver/model/rental_booking_model.dart';
import 'package:cabme_driver/page/booking_details_screens/booking_details_screen.dart';
import 'package:cabme_driver/page/booking_details_screens/parcel_details_screen.dart';
import 'package:cabme_driver/page/rental_details_screen/rental_details_screen.dart';
import 'package:cabme_driver/themes/responsive.dart';
import 'package:cabme_driver/themes/text_field_widget.dart';
import 'package:cabme_driver/utils/dark_theme_provider.dart';
import 'package:cabme_driver/utils/network_image_widget.dart';
import 'package:cabme_driver/widget/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:timelines_plus/timelines_plus.dart';

import '../../service/api.dart';
import '../../themes/app_them_data.dart';
import '../../themes/round_button_fill.dart';
import '../chats_screen/conversation_screen.dart' show ConversationScreen;

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: BookingController(),
        builder: (controller) {
          return DefaultTabController(
            length: 4, // Number of tabs
            child: Scaffold(
              backgroundColor: themeChange.getThem() ? AppThemeData.neutralDark100 : AppThemeData.neutral200,
              appBar: AppBar(
                backgroundColor: themeChange.getThem() ? AppThemeData.neutralDark100 : AppThemeData.neutral200,
                centerTitle: false,
                automaticallyImplyLeading: false,
                title: Text(
                  "Bookings".tr,
                  style: AppThemeData.semiBoldTextStyle(fontSize: 18, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                ),
                bottom: TabBar(
                  isScrollable: true,
                  labelColor: themeChange.getThem() ? AppThemeData.primaryDark : AppThemeData.primaryDark,
                  unselectedLabelColor: themeChange.getThem() ? AppThemeData.neutralDark700 : AppThemeData.neutral700,
                  indicatorColor: themeChange.getThem() ? AppThemeData.primaryDark : AppThemeData.primaryDark,
                  tabAlignment: TabAlignment.start,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  tabs: [
                    Tab(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text('New'.tr),
                    )),
                    Tab(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text('Ongoing'.tr),
                    )),
                    Tab(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text('Completed'.tr),
                    )),
                    Tab(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text('Cancelled'.tr),
                    )),
                  ],
                ),
                actions: [
                  CompositedTransformTarget(
                    link: controller.layerLink,
                    child: InkWell(
                      key: controller.overlayKey,
                      onTap: () {
                        showOverlay(context, controller);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SvgPicture.asset(
                          "assets/icons/ic_filter.svg",
                          colorFilter: ColorFilter.mode(themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900, BlendMode.srcIn),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              body: controller.isLoading.value
                  ? Constant.loader(context)
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      child: controller.bookingType.value == "Ride Booking"
                          ? TabBarView(
                              children: [
                                newBookingWidget(themeChange, controller, controller.newList),
                                newBookingWidget(themeChange, controller, controller.onGoingList),
                                newBookingWidget(themeChange, controller, controller.completedList),
                                newBookingWidget(themeChange, controller, controller.cancelledList),
                              ],
                            )
                          : controller.bookingType.value == "Parcel Delivery"
                              ? TabBarView(
                                  children: [
                                    newParcelBookingWidget(themeChange, controller, controller.newParcelList),
                                    newParcelBookingWidget(themeChange, controller, controller.onGoingParcelList),
                                    newParcelBookingWidget(themeChange, controller, controller.completedParcelList),
                                    newParcelBookingWidget(themeChange, controller, controller.cancelledParcelList),
                                  ],
                                )
                              : TabBarView(children: [
                                  rentalBookingWidget(themeChange, controller, controller.newRentalList),
                                  rentalBookingWidget(themeChange, controller, controller.onGoingRentalList),
                                  rentalBookingWidget(themeChange, controller, controller.completedRentalList),
                                  rentalBookingWidget(themeChange, controller, controller.cancelledRentalList),
                                ]),
                    ),
            ),
          );
        });
  }

  Widget newBookingWidget(DarkThemeProvider themeChange, BookingController controller, List<BookingData> list) {
    return list.isEmpty
        ? Constant.showEmptyView(message: "Booking not Found".tr)
        : RefreshIndicator(
            onRefresh: () => controller.getBookingList(),
            child: ListView.builder(
              itemCount: list.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                BookingData bookingData = list[index];
                List<Stops> locationData = <Stops>[];
                locationData.add(Stops(location: bookingData.departName, latitude: bookingData.latitudeDepart, longitude: bookingData.longitudeDepart));
                if (bookingData.stops != null) {
                  locationData.addAll(bookingData.stops!.map((e) => Stops(location: e.location, latitude: e.latitude, longitude: e.longitude)));
                }
                locationData.add(Stops(location: bookingData.destinationName, latitude: bookingData.latitudeArrivee, longitude: bookingData.longitudeArrivee));
                return Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 10),
                    decoration: ShapeDecoration(
                      color: themeChange.getThem() ? AppThemeData.neutralDark50 : AppThemeData.neutral50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        Get.to(() => BookingDetailsScreen(), arguments: {"bookingModel": bookingData})!.then(
                          (value) {
                            if (value == true) {
                              controller.getBookingList();
                            }
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 120,
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: NetworkImageWidget(
                                          imageUrl: bookingData.driver!.vehicleDetails!.image.toString(),
                                          width: 105,
                                          height: 100,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 5,
                                        left: 6,
                                        right: 6,
                                        child: Container(
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: themeChange.getThem() ? AppThemeData.successLight : AppThemeData.successLight),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                                            child: Center(
                                              child: Text(
                                                "${bookingData.statut}",
                                                style: AppThemeData.mediumTextStyle(fontSize: 12, color: themeChange.getThem() ? AppThemeData.successDefault : AppThemeData.successDefault),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 14,
                                ),
                                bookingData.user == null
                                    ? SizedBox()
                                    : Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        bookingData.statut == RideStatus.newRide
                                                            ? Text(
                                                                '${bookingData.driver!.vehicleDetails!.type}'.tr,
                                                                textAlign: TextAlign.center,
                                                                style: AppThemeData.boldTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                                              )
                                                            : Text(
                                                                '${bookingData.user!.prenom} ${bookingData.user!.nom}'.tr,
                                                                textAlign: TextAlign.center,
                                                                style: AppThemeData.boldTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                                              ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              bookingData.driver!.vehicleDetails!.brand.toString().tr,
                                                              textAlign: TextAlign.center,
                                                              style: AppThemeData.mediumTextStyle(fontSize: 12, color: themeChange.getThem() ? AppThemeData.neutralDark700 : AppThemeData.neutral700),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.symmetric(horizontal: 5),
                                                              child: Icon(
                                                                Icons.circle_sharp,
                                                                size: 8,
                                                              ),
                                                            ),
                                                            Text(
                                                              bookingData.driver!.vehicleDetails!.model.toString().tr,
                                                              textAlign: TextAlign.center,
                                                              style: AppThemeData.semiBoldTextStyle(fontSize: 12, color: themeChange.getThem() ? AppThemeData.neutralDark700 : AppThemeData.neutral700),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 10),
                                                    child: bookingData.statut == RideStatus.confirmed || bookingData.statut == RideStatus.onRide
                                                        ? Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  Constant.makePhoneCall(bookingData.user!.phone!);
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
                                                                    "receiverId": bookingData.user!.id,
                                                                    "orderId": bookingData.id,
                                                                    "receiverName": "${bookingData..user!.prenom} ${bookingData.user!.nom}",
                                                                    "receiverPhoto": bookingData.user!.image
                                                                  });
                                                                },
                                                                child: SvgPicture.asset(
                                                                  "assets/icons/ic_chat_details.svg",
                                                                  width: 36,
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : SizedBox(),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            controller.userModel.value.userData!.isOwner == "true"
                                ? SizedBox()
                                : bookingData.statut == RideStatus.canceled || bookingData.statut == RideStatus.completed || bookingData.statut == RideStatus.rejected
                                    ? InkWell(
                                        onTap: () {
                                          Get.to(() => BookingDetailsScreen(), arguments: {"bookingModel": bookingData})!.then(
                                            (value) {
                                              if (value == true) {
                                                controller.getBookingList();
                                              }
                                            },
                                          );
                                        },
                                        child: Column(
                                          children: [
                                            SvgPicture.asset("assets/icons/ic_show_details.svg"),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'View Details'.tr,
                                              textAlign: TextAlign.center,
                                              style: AppThemeData.semiBoldTextStyle(fontSize: 12, color: themeChange.getThem() ? AppThemeData.successDefault : AppThemeData.successDefault),
                                            )
                                          ],
                                        ),
                                      )
                                    : bookingData.statut == RideStatus.confirmed
                                        ? RoundedButtonFill(
                                            title: "Reached Location".tr,
                                            height: 5.5,
                                            color: themeChange.getThem() ? AppThemeData.successDefault : AppThemeData.successDefault,
                                            textColor: themeChange.getThem() ? AppThemeData.neutral50 : AppThemeData.neutral50,
                                            onPress: () async {
                                              showVerifyPassengerDialog(context, themeChange, controller, bookingData);
                                            },
                                          )
                                        : bookingData.statut == RideStatus.onRide
                                            ? RoundedButtonFill(
                                                title: bookingData.paymentMethod == "Cash" ? "Confirm Cash Payment".tr : "Payment Pending".tr,
                                                height: 5.5,
                                                color: themeChange.getThem() ? AppThemeData.errorDefault : AppThemeData.errorDefault,
                                                textColor: themeChange.getThem() ? AppThemeData.neutral50 : AppThemeData.neutral50,
                                                onPress: () async {
                                                  if (bookingData.paymentMethod == "Cash") {
                                                    conformCashPayment(context, themeChange, controller, bookingData);
                                                  } else {
                                                    ShowToastDialog.showToast("Payment is pending from customer");
                                                  }
                                                },
                                              )
                                            : bookingData.statut == RideStatus.newRide
                                                ? Row(
                                                    children: [
                                                      Expanded(
                                                        child: RoundedButtonFill(
                                                          title: "Reject".tr,
                                                          height: 5.5,
                                                          color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300,
                                                          textColor: themeChange.getThem() ? AppThemeData.neutralDark500 : AppThemeData.neutral500,
                                                          onPress: () async {
                                                            controller.rejectBooking(bookingData.id.toString());
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
                                                            controller.acceptBooking(bookingData.id.toString());
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : SizedBox()
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
  }

  Widget newParcelBookingWidget(DarkThemeProvider themeChange, BookingController controller, List<ParcelBookingData> list) {
    return list.isEmpty
        ? Constant.showEmptyView(message: "Parcel Booking not Found".tr)
        : RefreshIndicator(
            onRefresh: () => controller.getBookingList(),
            child: ListView.builder(
              itemCount: list.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                ParcelBookingData parcelBookingData = list[index];
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
                                    Constant().amountShow(amount: controller.calculateParcelTotalAmountBooking(parcelBookingData)).tr,
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
                                    '${parcelBookingData.receiveDate}'.tr,
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
                        controller.userModel.value.userData!.isOwner == "true"
                            ? SizedBox()
                            : parcelBookingData.status == RideStatus.confirmed
                                ? RoundedButtonFill(
                                    title: "Pickup Parcel".tr,
                                    height: 5.5,
                                    color: themeChange.getThem() ? AppThemeData.successDefault : AppThemeData.successDefault,
                                    textColor: themeChange.getThem() ? AppThemeData.neutral50 : AppThemeData.neutral50,
                                    onPress: () async {
                                      controller.pickUpParcelBooking(parcelBookingData);
                                    },
                                  )
                                : parcelBookingData.status == "onride"
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
          );
  }

  Widget rentalBookingWidget(DarkThemeProvider themeChange, BookingController controller, List<RentalBookingData> list) {
    return list.isEmpty
        ? Constant.showEmptyView(message: "Rental Booking not Found")
        : RefreshIndicator(
            onRefresh: () => controller.getBookingList(),
            child: ListView.builder(
              itemCount: list.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                RentalBookingData rentalBookingData = list[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: InkWell(
                    onTap: () {
                      Get.to(RentalDetailsScreen(), arguments: {"rentalBookingData": rentalBookingData});
                    },
                    child: Container(
                      width: Responsive.width(100, context),
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
                          controller.userModel.value.userData!.isOwner == "true"
                              ? SizedBox()
                              : rentalBookingData.status == RideStatus.confirmed
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
                                      : rentalBookingData.status == RideStatus.onRide
                                          ? RoundedButtonFill(
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
                                          : SizedBox()
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
  }

  void showVerifyRentalPassengerDialog(BuildContext context, DarkThemeProvider themeChange, BookingController controller, RentalBookingData rentalBookingData) {
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

  void conformCashRentalPayment(BuildContext context, DarkThemeProvider themeChange, BookingController controller, RentalBookingData rentalBookingData) {
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
                      (value) {
                        if (value != null) {
                          if (value['success'] == "Failed" || value['success'] == "ailed") {
                            ShowToastDialog.showToast(value['error']);
                            return null;
                          } else {
                            controller.getBookingList();
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

  void setFinalKilometerDialog(BuildContext context, DarkThemeProvider themeChange, BookingController controller, RentalBookingData rentalBookingData) {
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

  void showVerifyPassengerDialog(BuildContext context, DarkThemeProvider themeChange, BookingController controller, BookingData bookingData) {
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
                    controller.onRideStatus(bookingData);
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

  void conformCashPayment(BuildContext context, DarkThemeProvider themeChange, BookingController controller, BookingData bookingData) {
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
                    controller.completeBooking(bookingData);
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

  void showOverlay(BuildContext context, BookingController controller) {
    final OverlayState overlayState = Overlay.of(context);
    final RenderBox renderBox = controller.overlayKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () => entry.remove(),
              child: Container(color: Colors.transparent),
            ),
          ),
          Positioned(
            top: offset.dy + size.height + 10,
            right: 16,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 200,
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Obx(() {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: controller.types.map((type) {
                      bool selected = controller.bookingType.value == type;
                      return GestureDetector(
                        onTap: () {
                          controller.selectType(type);
                          controller.getBookingList();
                          entry.remove();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  type,
                                  style: TextStyle(
                                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                                    color: selected ? Colors.amber : Colors.black,
                                  ),
                                ),
                              ),
                              Icon(
                                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                                color: selected ? Colors.amber : Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );

    overlayState.insert(entry);
  }
}
