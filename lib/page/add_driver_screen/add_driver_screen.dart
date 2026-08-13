import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/controller/add_driver_controller.dart';
import 'package:cabme_driver/model/get_vehicle_data_model.dart';
import 'package:cabme_driver/model/zone_model.dart';
import 'package:cabme_driver/themes/app_them_data.dart';
import 'package:cabme_driver/themes/responsive.dart';
import 'package:cabme_driver/themes/text_field_widget.dart';
import 'package:cabme_driver/utils/dark_theme_provider.dart';
import 'package:cabme_driver/widget/multi_select_dropdown.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../widget/round_button_fill.dart';

class AddDriverScreen extends StatelessWidget {
  const AddDriverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: AddDriverController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              leading: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(Icons.arrow_back)),
            ),
            body: controller.isLoading.value
                ? Constant.loader(context)
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            controller.driverModel.value.id != null ? 'Edit Driver'.tr : 'Add New Driver'.tr,
                            textAlign: TextAlign.center,
                            style: AppThemeData.boldTextStyle(fontSize: 22, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Set up driver details and assign a vehicle.'.tr,
                            textAlign: TextAlign.center,
                            style: AppThemeData.mediumTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark500 : AppThemeData.neutral500),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text("Assign Vehicle".tr, style: AppThemeData.semiBoldTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark700 : AppThemeData.neutral700)),
                          SizedBox(
                            height: 5,
                          ),
                          DropdownButtonFormField<VehicleData>(
                            hint: Text("Select Vehicle Type"),
                            initialValue: controller.selectedVehicle.value.id == null ? null : controller.selectedVehicle.value,
                            onChanged: (VehicleData? newValue) {
                              controller.selectedVehicle.value = newValue!;
                            },
                            items: controller.vehicleList.map((VehicleData reason) {
                              return DropdownMenuItem<VehicleData>(
                                value: reason,
                                child: Text("${reason.vehicleName.toString()} (${reason.numberplate.toString()})"),
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
                            height: 10,
                          ),
                          TextFieldWidget(
                            controller: controller.firstNameController.value,
                            hintText: 'Enter First Name',
                            title: 'First Name',
                            prefix: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18),
                              child: SvgPicture.asset("assets/icons/ic_user.svg"),
                            ),
                          ),
                          TextFieldWidget(
                            controller: controller.lastNameController.value,
                            hintText: 'Enter Last Name',
                            title: 'Last Name',
                            prefix: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18),
                              child: SvgPicture.asset("assets/icons/ic_user.svg"),
                            ),
                          ),
                          TextFieldWidget(
                            controller: controller.emailController.value,
                            hintText: 'Enter Email Address',
                            title: 'Email Address',
                            enable: controller.driverModel.value.id != null ? false : true,
                            prefix: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18),
                              child: SvgPicture.asset("assets/icons/ic_email_login.svg"),
                            ),
                          ),
                          TextFieldWidget(
                            controller: controller.phoneNumber.value,
                            hintText: 'Enter Mobile Number',
                            title: 'Mobile Number',
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                            ],
                            prefix: CountryCodePicker(
                              onInit: (value) {
                                controller.countryCodeController.value.text = value?.dialCode ?? Constant.defaultCountryCode ?? '';
                                controller.countryISOCodeController.value.text = value?.code ?? Constant.defaultCountryCode ?? '';
                              },
                              onChanged: (value) {
                                controller.countryCodeController.value.text = value.dialCode.toString();
                                controller.countryISOCodeController.value.text = value.code ?? Constant.defaultCountryCode ?? '';
                              },
                              dialogTextStyle: TextStyle(
                                color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                                fontWeight: FontWeight.w500,
                                fontFamily: AppThemeData.medium,
                              ),
                              dialogBackgroundColor: themeChange.getThem() ? AppThemeData.neutralDark50 : AppThemeData.neutral50,
                              initialSelection: controller.countryISOCodeController.value.text,
                              comparator: (a, b) => b.name!.compareTo(a.name.toString()),
                              flagDecoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(2)),
                              ),
                              textStyle: TextStyle(
                                color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                                fontWeight: FontWeight.w500,
                                fontFamily: AppThemeData.medium,
                              ),
                              searchDecoration: InputDecoration(
                                iconColor: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                              ),
                              searchStyle: TextStyle(
                                color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                                fontWeight: FontWeight.w500,
                                fontFamily: AppThemeData.medium,
                              ),
                            ),
                          ),
                          TextFieldWidget(
                            controller: controller.passwordController.value,
                            hintText: 'Enter Password',
                            title: 'Password',
                            obscureText: controller.isPasswordShow.value,
                            prefix: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18),
                              child: SvgPicture.asset("assets/icons/ic_lock_login.svg"),
                            ),
                            suffix: InkWell(
                              onTap: () {
                                if (controller.isPasswordShow.value) {
                                  controller.isPasswordShow.value = false;
                                } else {
                                  controller.isPasswordShow.value = true;
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 18),
                                child: Obx(
                                  () => controller.isPasswordShow.value ? SvgPicture.asset("assets/icons/ic_hide.svg") : SvgPicture.asset("assets/icons/ic_show.svg"),
                                ),
                              ),
                            ),
                          ),
                          TextFieldWidget(
                            controller: controller.conformPasswordController.value,
                            hintText: 'Enter Confirm Password',
                            title: 'Confirm Password',
                            obscureText: controller.isConformPasswordShow.value,
                            prefix: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18),
                              child: SvgPicture.asset("assets/icons/ic_lock_login.svg"),
                            ),
                            suffix: InkWell(
                              onTap: () {
                                if (controller.isConformPasswordShow.value) {
                                  controller.isConformPasswordShow.value = false;
                                } else {
                                  controller.isConformPasswordShow.value = true;
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 18),
                                child: Obx(
                                  () => controller.isConformPasswordShow.value ? SvgPicture.asset("assets/icons/ic_hide.svg") : SvgPicture.asset("assets/icons/ic_show.svg"),
                                ),
                              ),
                            ),
                          ),
                          Text("Select Operating Zone".tr, style: AppThemeData.semiBoldTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark700 : AppThemeData.neutral700)),
                          const SizedBox(
                            height: 5,
                          ),
                          MultiSelectDropdown<ZoneData>(
                            items: controller.zoneList,
                            selectedItems: controller.selectedZone,
                            hintText: "Select Operating Zone".tr,
                            dialogTitle: "Select Zone".tr,
                            initialSelectedItems: controller.selectedZone,
                            labelSelector: (item) => item.name.toString().capitalizeString(),
                          ),
                          SizedBox(height: 12),
                          Text("Select driver service types".tr,
                              style: AppThemeData.semiBoldTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark700 : AppThemeData.neutral700)),
                          const SizedBox(
                            height: 5,
                          ),
                          MultiSelectDropdown<dynamic>(
                            dialogTitle: "Select Service Types".tr,
                            items: controller.ownerModel.value.userData!.serviceType!,
                            selectedItems: controller.selectedService,
                            hintText: "Select Service Types".tr,
                            initialSelectedItems: controller.selectedService,
                            labelSelector: (item) => item.toString().capitalizeString(),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 16, right: 16, top: 10),
              child: RoundedButtonFill(
                title: "Saves driver profile".tr,
                height: 5.5,
                color: AppThemeData.primaryDefault,
                textColor: AppThemeData.neutral50,
                onPress: () async {
                  if (controller.firstNameController.value.text.isEmpty) {
                    ShowToastDialog.showToast("Please enter a first name");
                  } else if (controller.lastNameController.value.text.isEmpty) {
                    ShowToastDialog.showToast("Please enter a last name");
                  } else if (controller.emailController.value.text.isEmpty) {
                    ShowToastDialog.showToast("Please enter a email");
                  } else if (controller.phoneNumber.value.text.isEmpty) {
                    ShowToastDialog.showToast("Please enter a phone number");
                  } else if (Get.arguments == null && controller.passwordController.value.text.isEmpty) {
                    ShowToastDialog.showToast("Please enter a password");
                  } else if (Get.arguments == null && controller.passwordController.value.text.trim() != controller.conformPasswordController.value.text.trim()) {
                    ShowToastDialog.showToast("Password and conform password not match");
                  } else {
                    controller.saveDetails();
                  }
                },
              ),
            ),
          );
        });
  }

  void zoneDialog(themeChange, BuildContext context, AddDriverController vehicleInfoController) {
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
            nameValue = "$nameValue${nameValue.isEmpty ? "" : ","} ${vehicleInfoController.zoneList.where((p0) => p0.id == element).first.name}";
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
                                  // vehicleInfoController.selectedZone.add(vehicleInfoController.zoneList[index].id); // select
                                }
                              },
                              title: Text(
                                vehicleInfoController.zoneList[index].name.toString(),
                                style: AppThemeData.mediumTextStyle(fontSize: 16),
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
}
