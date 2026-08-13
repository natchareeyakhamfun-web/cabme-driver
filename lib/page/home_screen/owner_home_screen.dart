import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/controller/owner_home_controller.dart';
import 'package:cabme_driver/model/get_vehicle_data_model.dart';
import 'package:cabme_driver/model/user_model.dart';
import 'package:cabme_driver/page/add_driver_screen/add_driver_screen.dart';
import 'package:cabme_driver/page/add_vehicle_screen/add_vehicle_screen.dart';
import 'package:cabme_driver/page/document_status/document_status_screen.dart';
import 'package:cabme_driver/page/home_screen/view_all_driver.dart';
import 'package:cabme_driver/page/home_screen/view_all_vehicle.dart';
import 'package:cabme_driver/themes/app_them_data.dart';
import 'package:cabme_driver/utils/dark_theme_provider.dart';
import 'package:cabme_driver/utils/network_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../widget/round_button_fill.dart';

class OwnerHomeScreen extends StatelessWidget {
  const OwnerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: OwnerHomeController(),
        builder: (controller) {
          return Scaffold(
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
                    'Manage your fleet, bookings, and drivers in one place.'.tr,
                    style: AppThemeData.mediumTextStyle(
                      fontSize: 12,
                      color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                    ),
                  )
                ],
              ),
            ),
            body: controller.isLoading.value
                ? Constant.loader(context)
                : controller.userModel.value.userData!.isVerified == "no"
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset("assets/images/document_not_verified.svg"),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Verification Required to Access Dashboard',
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
                              'First, please verify your identity and vehicle details to access the owner dashboard and manage Drivers and Bookings.',
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
                              title: "Upload Documents".tr,
                              height: 5.5,
                              color: AppThemeData.primaryDefault,
                              textColor: AppThemeData.neutral50,
                              onPress: () async {
                                Get.to(DocumentStatusScreen())!.then((value) {
                                  if (value == true) {
                                    controller.getData();
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppThemeData.homePageGradiant[0],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset("assets/icons/ic_ride.svg"),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              'rideCount'.trParams({
                                                'count': controller.ownerDashBoardData.value.totalBookings.toString(),
                                              }),
                                              textAlign: TextAlign.center,
                                              style: AppThemeData.boldTextStyle(
                                                fontSize: 16,
                                                color: AppThemeData.neutral900,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'Total Bookings'.tr,
                                              textAlign: TextAlign.center,
                                              style: AppThemeData.mediumTextStyle(
                                                fontSize: 12,
                                                color: AppThemeData.neutral900,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppThemeData.homePageGradiant[1],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset("assets/icons/ic_total_ride.svg"),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              '${controller.ownerDashBoardData.value.totalDrivers} ',
                                              textAlign: TextAlign.center,
                                              style: AppThemeData.boldTextStyle(
                                                fontSize: 16,
                                                color: AppThemeData.neutral900,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'Total Drivers'.tr,
                                              textAlign: TextAlign.center,
                                              style: AppThemeData.mediumTextStyle(
                                                fontSize: 12,
                                                color: AppThemeData.neutral900,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
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
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppThemeData.homePageGradiant[2],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset("assets/icons/ic_total_vihivle.svg"),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              '${controller.ownerDashBoardData.value.totalVehicles}',
                                              textAlign: TextAlign.center,
                                              style: AppThemeData.boldTextStyle(
                                                fontSize: 16,
                                                color: AppThemeData.neutral900,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'Total Vehicles'.tr,
                                              textAlign: TextAlign.center,
                                              style: AppThemeData.mediumTextStyle(
                                                fontSize: 12,
                                                color: AppThemeData.neutral900,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppThemeData.homePageGradiant[3],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset("assets/icons/ic_earning.svg"),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              '${controller.ownerDashBoardData.value.totalEarnings} ',
                                              textAlign: TextAlign.center,
                                              style: AppThemeData.boldTextStyle(
                                                fontSize: 16,
                                                color: AppThemeData.neutral900,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'Earnings'.tr,
                                              textAlign: TextAlign.center,
                                              style: AppThemeData.mediumTextStyle(
                                                fontSize: 12,
                                                color: AppThemeData.neutral900,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              controller.driverList.isEmpty
                                  ? SizedBox()
                                  : Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Your Available Drivers'.tr,
                                                    textAlign: TextAlign.center,
                                                    style: AppThemeData.boldTextStyle(
                                                      fontSize: 16,
                                                      color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Real-time status and earnings summary'.tr,
                                                    textAlign: TextAlign.center,
                                                    style: AppThemeData.mediumTextStyle(
                                                      fontSize: 12,
                                                      color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Get.to(ViewAllDriver())!.then(
                                                  (value) {
                                                    controller.getDriverList();
                                                  },
                                                );
                                              },
                                              child: Text(
                                                'View all'.tr,
                                                textAlign: TextAlign.center,
                                                style: AppThemeData.mediumTextStyle(
                                                    fontSize: 16,
                                                    color: themeChange.getThem() ? AppThemeData.accentDefault : AppThemeData.accentDefault,
                                                    decoration: TextDecoration.underline),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(
                                              color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300,
                                            ),
                                          ),
                                          child: ListView.builder(
                                            itemCount: controller.driverList.length,
                                            physics: NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              UserData driverModel = controller.driverList[index];
                                              return Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(10),
                                                      child: NetworkImageWidget(
                                                        imageUrl: driverModel.photoPath.toString(),
                                                        height: 50,
                                                        width: 50,
                                                        fit: BoxFit.fill,
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
                                                            '${driverModel.prenom} ${driverModel.nom}',
                                                            textAlign: TextAlign.center,
                                                            style: AppThemeData.semiBoldTextStyle(
                                                              fontSize: 16,
                                                              color: themeChange.getThem()
                                                                  ? AppThemeData.neutralDark900
                                                                  : AppThemeData.neutral900,
                                                            ),
                                                          ),
                                                          Text(
                                                            '${driverModel.countryCode} ${driverModel.phone}',
                                                            textAlign: TextAlign.center,
                                                            style: AppThemeData.mediumTextStyle(
                                                              fontSize: 12,
                                                              color: themeChange.getThem()
                                                                  ? AppThemeData.neutralDark700
                                                                  : AppThemeData.neutral700,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    RoundedButtonFill(
                                                      title: driverModel.online == "no" ? "Offline" : "Online".tr,
                                                      height: 3.5,
                                                      width: 18,
                                                      borderRadius: 10,
                                                      color: driverModel.online == "no"
                                                          ? AppThemeData.errorDefault
                                                          : AppThemeData.successDefault,
                                                      textColor: AppThemeData.neutral50,
                                                      onPress: () async {},
                                                    ),
                                                    PopupMenuButton<String>(
                                                      padding: EdgeInsets.zero,
                                                      onSelected: (value) {
                                                        if (value == 'Edit Driver') {
                                                          Get.to(AddDriverScreen(), arguments: {"driverModel": driverModel})!.then(
                                                            (value0) {
                                                              if (value0 == true) {
                                                                controller.getDriverList();
                                                              }
                                                            },
                                                          );
                                                        } else if (value == 'Delete Driver') {
                                                          controller.deleteDriver(driverModel.id.toString());
                                                        }
                                                      },
                                                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                                        PopupMenuItem<String>(
                                                          value: 'Edit Driver',
                                                          child: Text('Edit Driver'.tr),
                                                        ),
                                                        PopupMenuItem<String>(
                                                          value: 'Delete Driver',
                                                          child: Text('Delete Driver'.tr),
                                                        ),
                                                      ],
                                                      color: themeChange.getThem() ? AppThemeData.neutralDark50 : AppThemeData.neutral50,
                                                      icon: Icon(Icons.more_vert), // Three dots icon
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                              SizedBox(
                                height: 30,
                              ),
                              controller.vehicleList.isEmpty
                                  ? SizedBox()
                                  : Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Vehicles Summary'.tr,
                                                    textAlign: TextAlign.center,
                                                    style: AppThemeData.boldTextStyle(
                                                      fontSize: 16,
                                                      color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Your Registered Vehicles'.tr,
                                                    textAlign: TextAlign.center,
                                                    style: AppThemeData.mediumTextStyle(
                                                      fontSize: 12,
                                                      color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Get.to(ViewAllVehicle())!.then(
                                                  (value) {
                                                    controller.getDriverList();
                                                  },
                                                );
                                              },
                                              child: Text(
                                                'View all'.tr,
                                                textAlign: TextAlign.center,
                                                style: AppThemeData.mediumTextStyle(
                                                    fontSize: 16,
                                                    color: themeChange.getThem() ? AppThemeData.accentDefault : AppThemeData.accentDefault,
                                                    decoration: TextDecoration.underline),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(
                                              color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300,
                                            ),
                                          ),
                                          child: ListView.builder(
                                            itemCount: controller.vehicleList.length,
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              VehicleData vehicleData = controller.vehicleList[index];
                                              return Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(10),
                                                      child: NetworkImageWidget(
                                                        imageUrl: vehicleData.vehicleImage.toString(),
                                                        height: 50,
                                                        width: 50,
                                                        fit: BoxFit.fill,
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
                                                            '${vehicleData.vehicleName} | ${vehicleData.brand}',
                                                            textAlign: TextAlign.center,
                                                            style: AppThemeData.semiBoldTextStyle(
                                                              fontSize: 16,
                                                              color: themeChange.getThem()
                                                                  ? AppThemeData.neutralDark900
                                                                  : AppThemeData.neutral900,
                                                            ),
                                                          ),
                                                          Text(
                                                            '${vehicleData.numberplate}',
                                                            textAlign: TextAlign.center,
                                                            style: AppThemeData.mediumTextStyle(
                                                              fontSize: 12,
                                                              color: themeChange.getThem()
                                                                  ? AppThemeData.neutralDark700
                                                                  : AppThemeData.neutral700,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    PopupMenuButton<String>(
                                                      padding: EdgeInsets.zero,
                                                      onSelected: (value) {
                                                        if (value == 'Edit Vehicle') {
                                                          Get.to(AddVehicleScreen(), arguments: {"vehicleData": vehicleData})!.then(
                                                            (value0) {
                                                              if (value0 == true) {
                                                                controller.getDriverList();
                                                              }
                                                            },
                                                          );
                                                        } else if (value == 'Delete Vehicle') {
                                                          controller.removeVehicle(vehicleData.id.toString());
                                                        }
                                                      },
                                                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                                        PopupMenuItem<String>(
                                                          value: 'Edit Vehicle',
                                                          child: Text('Edit Vehicle'.tr),
                                                        ),
                                                        PopupMenuItem<String>(
                                                          value: 'Delete Vehicle',
                                                          child: Text('Delete Vehicle'.tr),
                                                        ),
                                                      ],
                                                      color: themeChange.getThem() ? AppThemeData.neutralDark50 : AppThemeData.neutral50,
                                                      icon: Icon(Icons.more_vert), // Three dots icon
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                        ),
                      ),
            floatingActionButton: controller.userModel.value.userData!.isVerified == "yes"
                ? FloatingActionButton(
                    key: controller.overlayKey,
                    onPressed: () {
                      showOverlay(context, controller);
                    },
                    backgroundColor: AppThemeData.primaryDefault,
                    // Solid color
                    foregroundColor: Colors.white,
                    // Icon color
                    elevation: 8,
                    // Shadow
                    shape: CircleBorder(),
                    // Ensures roundness
                    child: Icon(Icons.add, size: 28),
                  )
                : SizedBox(),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          );
        });
  }

  void showOverlay(BuildContext context, OwnerHomeController controller) {
    final OverlayState overlayState = Overlay.of(context);
    final RenderBox renderBox = controller.overlayKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    // ignore: unused_local_variable
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
            top: offset.dy - 130, // ✏️ Move overlay above the button (adjust as needed)
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: controller.types.map((type) {
                    return GestureDetector(
                      onTap: () {
                        entry.remove();
                        if (type == "Add Driver") {
                          Get.to(AddDriverScreen())!.then(
                            (value) {
                              if (value == true) {
                                controller.getDriverList();
                              }
                            },
                          );
                        } else {
                          Get.to(AddVehicleScreen())!.then(
                            (value) {
                              if (value == true) {
                                controller.getDriverList();
                              }
                            },
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                type.tr,
                                style: AppThemeData.semiBoldTextStyle(color: AppThemeData.neutral900),
                              ),
                            ),
                            SvgPicture.asset(
                              type == "Add Driver" ? "assets/icons/ic_add_driver.svg" : "assets/icons/ic_add_vehicle.svg",
                              width: 40,
                              height: 40,
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    overlayState.insert(entry);
  }
}
