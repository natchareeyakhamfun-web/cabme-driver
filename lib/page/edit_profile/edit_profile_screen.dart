import 'dart:io';

import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/controller/edit_profile_controllr.dart';
import 'package:cabme_driver/themes/responsive.dart';
import 'package:cabme_driver/utils/dark_theme_provider.dart';
import 'package:cabme_driver/utils/network_image_widget.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../themes/app_them_data.dart';
import '../../themes/text_field_widget.dart';
import '../../widget/round_button_fill.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: EditProfileController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Edit Profile'.tr,
                textAlign: TextAlign.center,
                style: AppThemeData.boldTextStyle(fontSize: 18, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
              ),
              titleSpacing: 0,
              centerTitle: false,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                children: [
                  Stack(
                    children: [
                      controller.profileImage.isEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: Image.asset(
                                "assets/images/placeholder_image.png",
                                height: Responsive.width(24, context),
                                width: Responsive.width(24, context),
                                fit: BoxFit.cover,
                              ),
                            )
                          : Constant().hasValidUrl(controller.profileImage.value) == false
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(60),
                                  child: Image.file(
                                    File(controller.profileImage.value),
                                    height: Responsive.width(24, context),
                                    width: Responsive.width(24, context),
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(60),
                                  child: NetworkImageWidget(
                                    width: 120,
                                    height: 120,
                                    imageUrl: controller.userModel.value.userData!.photoPath.toString(),
                                    errorWidget: Image.asset(
                                      "assets/images/placeholder_image.png",
                                      width: 120,
                                      height: 120,
                                    ),
                                  ),
                                ),
                      Positioned(
                        bottom: 0,
                        right: 5,
                        child: InkWell(
                          onTap: () {
                            buildBottomSheet(context, controller);
                          },
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: themeChange.getThem() ? AppThemeData.accentDefault : AppThemeData.accentDefault,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: SvgPicture.asset(
                                "assets/icons/ic_edit.svg",
                                height: 20,
                                colorFilter: ColorFilter.mode(themeChange.getThem() ? AppThemeData.neutral50 : AppThemeData.neutral50, BlendMode.srcIn),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
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
                    enable: controller.userModel.value.userData!.loginType == "email" ||
                            controller.userModel.value.userData!.loginType == "google" ||
                            controller.userModel.value.userData!.loginType == "apple"
                        ? false
                        : true,
                    readOnly: controller.userModel.value.userData!.loginType == "email" ||
                            controller.userModel.value.userData!.loginType == "google" ||
                            controller.userModel.value.userData!.loginType == "apple"
                        ? true
                        : false,
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
                    enable: controller.userModel.value.userData!.loginType == "phoneNumber" ? false : true,
                    readOnly: controller.userModel.value.userData!.loginType == "phoneNumber" ? true : false,
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
                  SizedBox(
                    width: 20,
                  ),
                  RoundedButtonFill(
                    title: "Save Changes".tr,
                    height: 5.5,
                    color: AppThemeData.primaryDefault,
                    textColor: AppThemeData.neutral50,
                    onPress: () async {
                      FocusScope.of(context).unfocus();
                      if (controller.firstNameController.value.text.isEmpty) {
                        ShowToastDialog.showToast('First Name cannot be empty');
                      } else if (controller.lastNameController.value.text.isEmpty) {
                        ShowToastDialog.showToast('Last Name cannot be empty');
                      } else if (controller.emailController.value.text.isEmpty) {
                        ShowToastDialog.showToast('Email cannot be empty');
                      } else if (!Constant.isValidEmail(controller.emailController.value.text)) {
                        ShowToastDialog.showToast('Please enter a valid email address');
                      } else if (controller.phoneNumber.value.text.isEmpty) {
                        ShowToastDialog.showToast('Phone Number cannot be empty');
                      } else {
                        controller.updateUser(
                            image: controller.profileImage.value,
                            name: controller.firstNameController.value.text,
                            lname: controller.lastNameController.value.text,
                            phoneNum: controller.phoneNumber.value.text,
                            email: controller.emailController.value.text);
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future buildBottomSheet(BuildContext context, EditProfileController controller) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              height: Responsive.height(22, context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text("please select".tr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () => controller.pickFile(source: ImageSource.camera),
                                icon: const Icon(
                                  Icons.camera_alt,
                                  size: 32,
                                )),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text(
                                "camera".tr,
                                style: const TextStyle(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () => controller.pickFile(source: ImageSource.gallery),
                              icon: const Icon(
                                Icons.photo_library_sharp,
                                size: 32,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text(
                                "gallery".tr,
                                style: const TextStyle(),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
