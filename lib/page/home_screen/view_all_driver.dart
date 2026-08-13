import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/controller/view_all_driver_controller.dart';
import 'package:cabme_driver/model/user_model.dart';
import 'package:cabme_driver/page/add_driver_screen/add_driver_screen.dart';
import 'package:cabme_driver/themes/app_them_data.dart';
import 'package:cabme_driver/utils/dark_theme_provider.dart';
import 'package:cabme_driver/utils/network_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../widget/round_button_fill.dart';

class ViewAllDriver extends StatelessWidget {
  const ViewAllDriver({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: ViewAllDriverController(),
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
                      itemCount: controller.driverList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        UserData driverModel = controller.driverList[index];
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
                                            color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                                          ),
                                        ),
                                        Text(
                                          '${driverModel.countryCode} ${driverModel.phone}',
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
                                  RoundedButtonFill(
                                    title: driverModel.online == "no" ? "Offline" : "Online".tr,
                                    height: 3.5,
                                    width: 18,
                                    borderRadius: 10,
                                    color: driverModel.online == "no" ? AppThemeData.errorDefault : AppThemeData.successDefault,
                                    textColor: AppThemeData.neutral50,
                                    onPress: () async {},
                                  ),
                                  PopupMenuButton<String>(
                                    padding: EdgeInsets.zero,
                                    onSelected: (value) {
                                      if (value == 'Edit Driver') {
                                        Get.to(AddDriverScreen(), arguments: {"driverModel": driverModel})!.then((value) {
                                          if (value != null && value) {
                                            controller.getDriverList();
                                          }
                                        });
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
