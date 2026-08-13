import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/controller/vehicle_info_controller.dart';
import 'package:cabme_driver/model/brand_model.dart';
import 'package:cabme_driver/model/get_vehicle_getegory.dart';
import 'package:cabme_driver/model/model.dart';
import 'package:cabme_driver/themes/app_them_data.dart';
import 'package:cabme_driver/themes/responsive.dart';
import 'package:cabme_driver/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../themes/text_field_widget.dart';
import '../../widget/round_button_fill.dart';

class VehicleInfoScreen extends StatelessWidget {
  const VehicleInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: VehicleInfoController(),
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
            ),
            body: controller.isLoading.value
                ? Constant.loader(context)
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tell Us About Your Vehicle'.tr,
                            textAlign: TextAlign.center,
                            style: AppThemeData.boldTextStyle(fontSize: 22, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Enter your vehicle details accurately.'.tr,
                            textAlign: TextAlign.center,
                            style: AppThemeData.mediumTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark500 : AppThemeData.neutral500),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Text(
                              'Vehicle Type'.tr,
                              style: AppThemeData.semiBoldTextStyle(
                                fontSize: 14,
                                color: themeChange.getThem() ? AppThemeData.neutralDark700 : AppThemeData.neutral700,
                              ),
                            ),
                          ),
                          DropdownButtonFormField<VehicleCategoryData>(
                            hint: Text("Select Vehicle Type"),
                            initialValue: controller.selectedVehicleCategory.value.id == null ? null : controller.selectedVehicleCategory.value,
                            onChanged: controller.userModel.value.userData!.ownerId != null && controller.userModel.value.userData!.ownerId!.isNotEmpty
                                ? null
                                : (VehicleCategoryData? newValue) {
                                    controller.selectedVehicleCategory.value = newValue!;
                                  },
                            items: controller.vehicleCategoryList.map((VehicleCategoryData reason) {
                              return DropdownMenuItem<VehicleCategoryData>(
                                value: reason,
                                child: Text(reason.libelle.toString()),
                              );
                            }).toList(),
                            style: TextStyle(color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900, fontFamily: AppThemeData.medium),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: themeChange.getThem() ? AppThemeData.neutralDark100 : AppThemeData.neutral100,
                              contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(40)),
                                borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(40)),
                                borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.primaryDarkDefault : AppThemeData.primaryDefault, width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(40)),
                                borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300, width: 1),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(40)),
                                borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300, width: 1),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(40)),
                                borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300, width: 1),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5, top: 12),
                            child: Text(
                              'Brand'.tr,
                              style: AppThemeData.semiBoldTextStyle(
                                fontSize: 14,
                                color: themeChange.getThem() ? AppThemeData.neutralDark700 : AppThemeData.neutral700,
                              ),
                            ),
                          ),
                          DropdownButtonFormField<BrandData>(
                            hint: Text("Select Brand"),
                            initialValue: controller.selectedBrand.value.id == null ? null : controller.selectedBrand.value,
                            onChanged: controller.userModel.value.userData!.ownerId != null && controller.userModel.value.userData!.ownerId!.isNotEmpty
                                ? null
                                : (BrandData? newValue) async {
                                    controller.selectedBrand.value = newValue!;
                                    await controller.getModel();
                                  },
                            items: controller.brandList.map((BrandData reason) {
                              return DropdownMenuItem<BrandData>(
                                value: reason,
                                child: Text(reason.name.toString()),
                              );
                            }).toList(),
                            style: TextStyle(color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900, fontFamily: AppThemeData.medium),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: themeChange.getThem() ? AppThemeData.neutralDark100 : AppThemeData.neutral100,
                              contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(40)),
                                borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(40)),
                                borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.primaryDarkDefault : AppThemeData.primaryDefault, width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(40)),
                                borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300, width: 1),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(40)),
                                borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300, width: 1),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(40)),
                                borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300, width: 1),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: Text(
                                        'Model'.tr,
                                        style: AppThemeData.semiBoldTextStyle(
                                          fontSize: 14,
                                          color: themeChange.getThem() ? AppThemeData.neutralDark700 : AppThemeData.neutral700,
                                        ),
                                      ),
                                    ),
                                    DropdownButtonFormField<ModelData>(
                                      hint: Text("Select Model"),
                                      initialValue: controller.selectedModel.value.id == null ? null : controller.selectedModel.value,
                                      onChanged: controller.userModel.value.userData!.ownerId != null && controller.userModel.value.userData!.ownerId!.isNotEmpty
                                          ? null
                                          : (ModelData? newValue) async {
                                              controller.selectedModel.value = newValue!;
                                            },
                                      items: controller.modelList.map((ModelData reason) {
                                        return DropdownMenuItem<ModelData>(
                                          value: reason,
                                          child: Text(reason.name.toString()),
                                        );
                                      }).toList(),
                                      style: TextStyle(color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900, fontFamily: AppThemeData.medium),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: themeChange.getThem() ? AppThemeData.neutralDark100 : AppThemeData.neutral100,
                                        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(40)),
                                          borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300, width: 1),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(40)),
                                          borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.primaryDarkDefault : AppThemeData.primaryDefault, width: 1),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(40)),
                                          borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300, width: 1),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(40)),
                                          borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300, width: 1),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(40)),
                                          borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300, width: 1),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child: TextFieldWidget(
                                  controller: controller.colorController.value,
                                  hintText: 'Enter Color',
                                  title: 'Color',
                                  enable: controller.userModel.value.userData!.ownerId != null && controller.userModel.value.userData!.ownerId!.isNotEmpty ? false : true,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          TextFieldWidget(
                            textInputType: TextInputType.number,
                            controller: controller.carMakeController.value,
                            hintText: 'Enter Select Registration Year',
                            title: 'Registration Year',
                            readOnly: false,
                            enable: true,
                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly], //,
                          ),
                          TextFieldWidget(
                            controller: controller.numberPlateController.value,
                            hintText: 'Enter Number Plate',
                            title: 'Number Plate',
                            enable: controller.userModel.value.userData!.ownerId != null && controller.userModel.value.userData!.ownerId!.isNotEmpty ? false : true,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFieldWidget(
                                  controller: controller.millageController.value,
                                  hintText: 'Enter Mileage'.tr,
                                  title: 'Mileage'.tr,
                                  enable: controller.userModel.value.userData!.ownerId != null && controller.userModel.value.userData!.ownerId!.isNotEmpty ? false : true,
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child: TextFieldWidget(
                                  controller: controller.kmDrivenController.value,
                                  hintText: 'Enter KM',
                                  title: 'KM Driven',
                                  enable: controller.userModel.value.userData!.ownerId != null && controller.userModel.value.userData!.ownerId!.isNotEmpty ? false : true,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Passenger Capacity'.tr,
                                  textAlign: TextAlign.start,
                                  style: AppThemeData.semiBoldTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark700 : AppThemeData.neutral700),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: themeChange.getThem() ? AppThemeData.neutralDark100 : AppThemeData.neutral100,
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                  child: Row(
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            if (controller.userModel.value.userData!.ownerId != null && controller.userModel.value.userData!.ownerId!.isNotEmpty) {
                                            } else {
                                              if (controller.passenger.value > 1) {
                                                controller.passenger.value -= 1;
                                              } else {
                                                ShowToastDialog.showToast("Passenger capacity cannot be less than 1".tr);
                                              }
                                            }
                                          },
                                          child: Icon(Icons.remove, color: themeChange.getThem() ? AppThemeData.neutralDark700 : AppThemeData.neutral700)),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Text(
                                          controller.passenger.value.toString(),
                                          textAlign: TextAlign.start,
                                          style: AppThemeData.semiBoldTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                        ),
                                      ),
                                      InkWell(
                                          onTap: () {
                                            if (controller.userModel.value.userData!.ownerId != null && controller.userModel.value.userData!.ownerId!.isNotEmpty) {
                                            } else {
                                              controller.passenger.value += 1;
                                            }
                                          },
                                          child: Icon(Icons.add, color: themeChange.getThem() ? AppThemeData.neutralDark700 : AppThemeData.neutral700)),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 12),
                          InkWell(
                            onTap: () async {
                              if (controller.userModel.value.userData!.ownerId != null && controller.userModel.value.userData!.ownerId!.isNotEmpty) {
                              } else {
                                zoneDialog(themeChange, context, controller);
                              }
                            },
                            child: TextFieldWidget(
                              controller: controller.zoneNameController.value,
                              hintText: 'Select Operating Zone'.tr,
                              title: 'Operating Zone'.tr,
                              readOnly: true,
                              enable: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            bottomNavigationBar: controller.userModel.value.userData!.ownerId != null && controller.userModel.value.userData!.ownerId!.isNotEmpty
                ? SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 30, right: 16, left: 16, top: 10),
                    child: RoundedButtonFill(
                      title: "Save".tr,
                      height: 5.5,
                      color: AppThemeData.primaryDefault,
                      textColor: AppThemeData.neutral50,
                      onPress: () async {
                        if (controller.userModel.value.userData!.ownerId != null && controller.userModel.value.userData!.ownerId!.isNotEmpty) {
                        } else {
                          if (controller.selectedVehicleCategory.value.id == null) {
                            ShowToastDialog.showToast("Please select vehicle type");
                          } else if (controller.selectedBrand.value.id == null) {
                            ShowToastDialog.showToast("Please select brand");
                          } else if (controller.selectedModel.value.id == null) {
                            ShowToastDialog.showToast("Please select model");
                          } else if (controller.colorController.value.text.isEmpty) {
                            ShowToastDialog.showToast("Please enter color");
                          } else if (controller.carMakeController.value.text.isEmpty) {
                            ShowToastDialog.showToast("Please select registration year");
                          } else if (controller.numberPlateController.value.text.isEmpty) {
                            ShowToastDialog.showToast("Please enter number plate");
                          } else if (controller.millageController.value.text.isEmpty) {
                            ShowToastDialog.showToast("Please enter mileage");
                          } else if (controller.kmDrivenController.value.text.isEmpty) {
                            ShowToastDialog.showToast("Please enter km driven");
                          } else if (controller.zoneNameController.value.text.isEmpty) {
                            ShowToastDialog.showToast("Please select operating zone");
                          } else {
                            controller.saveVehicle();
                          }
                        }
                      },
                    ),
                  ),
          );
        });
  }

  void zoneDialog(themeChange, BuildContext context, VehicleInfoController vehicleInfoController) {
    Widget cancelButton = RoundedButtonFill(
      title: "Cancel".tr,
      height: 5,
      color: AppThemeData.neutral300,
      textColor: AppThemeData.neutral900,
      onPress: () async {
        FocusScope.of(context).unfocus();
        if(vehicleInfoController.selectedZone.isEmpty){
          vehicleInfoController.zoneNameController.value.clear();
        }
        Get.back();
      },
    );
    Widget continueButton = RoundedButtonFill(
      title: "Add".tr,
      height: 5,
      color: AppThemeData.primaryDefault,
      textColor: AppThemeData.neutral50,
      onPress: () async {
        FocusScope.of(context).unfocus();
        if (vehicleInfoController.selectedZone.isEmpty) {
          ShowToastDialog.showToast("Please select zone");
        } else {
          String nameValue = "";
          for (var element in vehicleInfoController.selectedZone) {
            if (vehicleInfoController.zoneList.where((p0) => p0.id == element).isNotEmpty) {
              nameValue = "$nameValue${nameValue.isEmpty ? "" : ","} ${vehicleInfoController.zoneList.where((p0) => p0.id == element).first.name}";
            }
          }
          vehicleInfoController.zoneNameController.value.text = nameValue;
          Get.back();
        }
      },
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Zone list'.tr,
              style: AppThemeData.boldTextStyle(fontSize: 18, color: AppThemeData.primaryDefault),
            ),
            backgroundColor: themeChange.getThem() ? AppThemeData.neutralDark50 : AppThemeData.neutral50,
            content: SizedBox(
              width: Responsive.width(100, context), // Change as per your requirement
              child: vehicleInfoController.zoneList.isEmpty
                  ? Container()
                  : Obx(
                      () => ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: vehicleInfoController.zoneList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Obx(
                            () => CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              // Removes left/right space
                              dense: true,
                              // Reduces overall vertical padding
                              visualDensity: VisualDensity.compact,
                              // Controls vertical & horizontal density
                              value: vehicleInfoController.selectedZone.contains(vehicleInfoController.zoneList[index].id),
                              onChanged: (value) {
                                if (vehicleInfoController.selectedZone.contains(vehicleInfoController.zoneList[index].id)) {
                                  vehicleInfoController.selectedZone.remove(vehicleInfoController.zoneList[index].id); // unselect
                                } else {
                                  vehicleInfoController.selectedZone.add(vehicleInfoController.zoneList[index].id); // select
                                }
                              },
                              title: Text(
                                vehicleInfoController.zoneList[index].name.toString(),
                                style: AppThemeData.mediumTextStyle(
                                  fontSize: 16,
                                  color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
            actions: [
              Row(
                children: [
                  Expanded(child: cancelButton),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(child: continueButton),
                ],
              )
            ],
          );
        });
  }

  Future<String?> selectYear(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      // Open in year mode
      helpText: 'Select Year'.tr,
    );

    if (picked != null) {
      return DateFormat('dd-MM-yyyy').format(picked);
    }
    return null;
  }
}
