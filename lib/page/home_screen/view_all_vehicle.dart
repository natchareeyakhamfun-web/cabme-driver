import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/controller/view_all_vehicle_controller.dart';
import 'package:cabme_driver/model/get_vehicle_data_model.dart';
import 'package:cabme_driver/page/add_vehicle_screen/add_vehicle_screen.dart';
import 'package:cabme_driver/themes/app_them_data.dart';
import 'package:cabme_driver/utils/dark_theme_provider.dart';
import 'package:cabme_driver/utils/network_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ViewAllVehicle extends StatelessWidget {
  const ViewAllVehicle({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: ViewAllVehicleController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              titleSpacing: 0,
              centerTitle: false,
            ),
            body: controller.isLoading.value
                ? Constant.loader(context)
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: ListView.builder(
                      itemCount: controller.vehicleList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        VehicleData vehicleData = controller.vehicleList[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300,
                              ),
                            ),
                            child: Padding(
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
                                            color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                                          ),
                                        ),
                                        Text(
                                          '${vehicleData.numberplate}',
                                          textAlign: TextAlign.center,
                                          style: AppThemeData.mediumTextStyle(
                                            fontSize: 12,
                                            color: themeChange.getThem() ? AppThemeData.neutralDark700 : AppThemeData.neutral700,
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
                                        Get.to(AddVehicleScreen(), arguments: {"vehicleData": vehicleData})!.then((value) {
                                          if (value != null && value == true) {
                                            controller.getDriverList();
                                          }
                                        });
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
