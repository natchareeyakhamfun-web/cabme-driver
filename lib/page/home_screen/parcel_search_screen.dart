import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/ride_satatus.dart';
import 'package:cabme_driver/controller/parcel_search_controller.dart';
import 'package:cabme_driver/model/parcel_bokking_model.dart';
import 'package:cabme_driver/page/booking_details_screens/parcel_details_screen.dart';
import 'package:cabme_driver/themes/app_them_data.dart';
import 'package:cabme_driver/themes/responsive.dart';
import 'package:cabme_driver/utils/dark_theme_provider.dart';
import 'package:cabme_driver/utils/network_image_widget.dart';
import 'package:cabme_driver/widget/dotted_line.dart';
import 'package:cabme_driver/widget/osm_map/map_picker_page.dart';
import 'package:cabme_driver/widget/osm_map/place_model.dart';
import 'package:cabme_driver/widget/place_picker/location_picker_screen.dart';
import 'package:cabme_driver/widget/place_picker/selected_location_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as latlong;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timelines_plus/timelines_plus.dart';

import '../../themes/text_field_widget.dart';
import '../../widget/round_button_fill.dart';

class ParcelSearchScreen extends StatelessWidget {
  const ParcelSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: ParcelSearchController(),
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
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFieldWidget(
                                readOnly: true,
                                controller: controller.sourceTextEditController.value,
                                onPress: () async {
                                  if (Constant.selectedMapType == 'osm') {
                                    PlaceModel? result = await Get.to(() => MapPickerPage());
                                    if (result != null) {
                                      controller.sourceTextEditController.value.text = '';
                                      final firstPlace = result;
                                      final lat = firstPlace.coordinates.latitude;
                                      final lng = firstPlace.coordinates.longitude;

                                      controller.sourceTextEditController.value.text = result.city.toString();
                                      controller.departureLatLongOsm.value = latlong.LatLng(lat, lng);
                                    }
                                  } else {
                                    Get.to(LocationPickerScreen())!.then(
                                      (value) async {
                                        if (value != null) {
                                          SelectedLocationModel selectedLocationModel = value;
                                          controller.sourceTextEditController.value.text =
                                              selectedLocationModel.address!.locality.toString();
                                          controller.departureLatLong.value =
                                              LatLng(selectedLocationModel.latLng!.latitude, selectedLocationModel.latLng!.longitude);
                                        }
                                      },
                                    );
                                  }
                                },
                                hintText: 'Where you want to go?',
                                prefix: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: SvgPicture.asset("assets/icons/ic_source.svg"),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextFieldWidget(
                                readOnly: true,
                                controller: controller.destinationTextEditController.value,
                                onPress: () async {
                                  if (Constant.selectedMapType == 'osm') {
                                    PlaceModel? result = await Get.to(() => MapPickerPage());
                                    if (result != null) {
                                      controller.destinationTextEditController.value.text = '';
                                      final firstPlace = result;
                                      final lat = firstPlace.coordinates.latitude;
                                      final lng = firstPlace.coordinates.longitude;
                                      // ignore: unused_local_variable
                                      final address = firstPlace.address;
                                      controller.destinationTextEditController.value.text = result.city.toString();
                                      controller.destinationLatLongOsm.value = latlong.LatLng(lat, lng);
                                    }
                                  } else {
                                    Get.to(LocationPickerScreen())!.then(
                                      (value) async {
                                        if (value != null) {
                                          SelectedLocationModel selectedLocationModel = value;

                                          controller.destinationTextEditController.value.text =
                                              selectedLocationModel.address!.locality.toString();

                                          controller.destinationLatLong.value =
                                              LatLng(selectedLocationModel.latLng!.latitude, selectedLocationModel.latLng!.longitude);
                                        }
                                      },
                                    );
                                  }
                                },
                                hintText: 'Where to?',
                                prefix: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: SvgPicture.asset("assets/icons/ic_destination.svg"),
                                ),
                              ),
                            ),
                          ],
                        ),
                        TextFieldWidget(
                          controller: controller.dateTimeTextEditController.value,
                          hintText: 'Select Date',
                          readOnly: true,
                          onPress: () async {
                            controller.pickDateTime();
                          },
                          prefix: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: SvgPicture.asset("assets/images/ic_data.svg"),
                          ),
                        ),
                        RoundedButtonFill(
                          title: "Search Parcel".tr,
                          height: 5.5,
                          color: AppThemeData.primaryDefault,
                          textColor: AppThemeData.neutral50,
                          onPress: () async {
                            FocusScope.of(context).unfocus();
                            controller.searchParcel();
                          },
                        ),
                        Expanded(
                          child: controller.parcelList.isEmpty
                              ? Constant.showEmptyView(message: "Parcel Booking not found".tr)
                              : ListView.builder(
                                  itemCount: controller.parcelList.length,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
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
                                                        color:
                                                            themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300,
                                                        gap: 4,
                                                      );
                                                    },
                                                    contentsBuilder: (context, index) {
                                                      return Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                                        child: Text(
                                                          index == 0 ? "${parcelBookingData.source}" : "${parcelBookingData.destination}",
                                                          style: AppThemeData.mediumTextStyle(
                                                              fontSize: 14,
                                                              color: themeChange.getThem()
                                                                  ? AppThemeData.neutralDark900
                                                                  : AppThemeData.neutral900),
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
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        '${parcelBookingData.user!.prenom} ${parcelBookingData.user!.nom}'.tr,
                                                        textAlign: TextAlign.start,
                                                        style: AppThemeData.boldTextStyle(
                                                            fontSize: 16,
                                                            color: themeChange.getThem()
                                                                ? AppThemeData.neutralDark900
                                                                : AppThemeData.neutral900),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Container(
                                                        width: 75,
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(30),
                                                            color: themeChange.getThem()
                                                                ? AppThemeData.successLight
                                                                : AppThemeData.successLight),
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Icons.star_half,
                                                                size: 14,
                                                                color: themeChange.getThem()
                                                                    ? AppThemeData.successDefault
                                                                    : AppThemeData.successDefault,
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                "${parcelBookingData.user!.averageRating}",
                                                                style: AppThemeData.mediumTextStyle(
                                                                    fontSize: 14,
                                                                    color: themeChange.getThem()
                                                                        ? AppThemeData.successDefault
                                                                        : AppThemeData.successDefault),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
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
                                                        style: AppThemeData.semiBoldTextStyle(
                                                            fontSize: 12,
                                                            color: themeChange.getThem()
                                                                ? AppThemeData.neutralDark900
                                                                : AppThemeData.neutral900),
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
                                                        style: AppThemeData.semiBoldTextStyle(
                                                            fontSize: 12,
                                                            color: themeChange.getThem()
                                                                ? AppThemeData.neutralDark900
                                                                : AppThemeData.neutral900),
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
                                                        style: AppThemeData.semiBoldTextStyle(
                                                            fontSize: 12,
                                                            color: themeChange.getThem()
                                                                ? AppThemeData.neutralDark900
                                                                : AppThemeData.neutral900),
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
                                                    color:
                                                        themeChange.getThem() ? AppThemeData.successDefault : AppThemeData.successDefault,
                                                    textColor: themeChange.getThem() ? AppThemeData.neutral50 : AppThemeData.neutral50,
                                                    onPress: () async {},
                                                  )
                                                : parcelBookingData.status == RideStatus.onRide
                                                    ? RoundedButtonFill(
                                                        title: "Payment Pending".tr,
                                                        height: 5.5,
                                                        color:
                                                            themeChange.getThem() ? AppThemeData.errorDefault : AppThemeData.errorDefault,
                                                        textColor: themeChange.getThem() ? AppThemeData.neutral50 : AppThemeData.neutral50,
                                                        onPress: () async {},
                                                      )
                                                    : RoundedButtonFill(
                                                        title: "Accept".tr,
                                                        height: 5.5,
                                                        color: AppThemeData.successDefault,
                                                        textColor: AppThemeData.neutral50,
                                                        onPress: () async {
                                                          controller.acceptParcelBooking(parcelBookingData);
                                                        },
                                                      )
                                          ],
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
}
