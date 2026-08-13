import 'dart:developer' show log;

import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/controller/profile_controller.dart';
import 'package:cabme_driver/model/user_model.dart';
import 'package:cabme_driver/page/auth_screens/vehicle_info_screen.dart';
import 'package:cabme_driver/page/bank_details_add/bank_details_add.dart';
import 'package:cabme_driver/page/change_password_screen/change_password_screen.dart';
import 'package:cabme_driver/page/document_status/document_status_screen.dart';
import 'package:cabme_driver/page/edit_profile/edit_profile_screen.dart';
import 'package:cabme_driver/page/localization_screens/localization_screen.dart';
import 'package:cabme_driver/page/privacy_policy/privacy_policy_screen.dart';
import 'package:cabme_driver/page/subscription_plan_screen/subscription_history_screen.dart';
import 'package:cabme_driver/page/subscription_plan_screen/subscription_plan_screen.dart';
import 'package:cabme_driver/page/terms_of_service/terms_of_service_screen.dart';
import 'package:cabme_driver/themes/responsive.dart';
import 'package:cabme_driver/themes/round_button_fill.dart';
import 'package:cabme_driver/utils/dark_theme_provider.dart';
import 'package:cabme_driver/utils/network_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../themes/app_them_data.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: ProfileController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'My Profile'.tr,
                textAlign: TextAlign.center,
                style: AppThemeData.boldTextStyle(fontSize: 22, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
              ),
              centerTitle: false,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: ClipOval(
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
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "${controller.userModel.value.userData!.prenom} ${controller.userModel.value.userData!.nom}",
                      style: AppThemeData.boldTextStyle(fontSize: 18, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                    ),
                    Text(
                      "${controller.userModel.value.userData!.email}",
                      style: AppThemeData.mediumTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                    ),
                    Text(
                      "${controller.userModel.value.userData!.countryCode} ${controller.userModel.value.userData!.phone}",
                      style: AppThemeData.mediumTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                    ),
                    const SizedBox(height: 20),
                    controller.userModel.value.userData!.ownerId != null && controller.userModel.value.userData!.ownerId!.isNotEmpty
                        ? SizedBox()
                        : controller.userModel.value.userData!.subscriptionPlan == null
                            ? SizedBox()
                            : Container(
                                width: Responsive.width(100, context),
                                decoration: BoxDecoration(
                                  color: themeChange.getThem() ? AppThemeData.neutralDark700 : AppThemeData.neutral900,
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          NetworkImageWidget(
                                            imageUrl: controller.userModel.value.userData!.subscriptionPlan!.image.toString(),
                                            width: 40,
                                            height: 40,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${controller.userModel.value.userData!.subscriptionPlan!.name}'.tr,
                                                  textAlign: TextAlign.start,
                                                  style: AppThemeData.boldTextStyle(fontSize: 18, color: themeChange.getThem() ? AppThemeData.neutralDark50 : AppThemeData.neutral50),
                                                ),
                                                Text(
                                                  '${controller.userModel.value.userData!.subscriptionPlan!.description}'.tr,
                                                  textAlign: TextAlign.start,
                                                  style: AppThemeData.boldTextStyle(fontSize: 12, color: themeChange.getThem() ? AppThemeData.neutralDark500 : AppThemeData.neutral500),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      RoundedButtonFill(
                                        title: "Activated".tr,
                                        height: 5.5,
                                        color: AppThemeData.primaryDefault,
                                        textColor: AppThemeData.neutral50,
                                        onPress: () async {},
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: themeChange.getThem() ? AppThemeData.neutralDark100 : AppThemeData.neutral100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Get.to(EditProfileScreen())!.then((value) {
                                  if (value == true) {
                                    controller.getUserData();
                                  }
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(height: 24, "assets/icons/ic_user_icon.svg"),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Edit Profile'.tr,
                                        style: AppThemeData.semiBoldTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(ChangePasswordScreen());
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(height: 24, "assets/icons/ic_lock.svg"),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Change Password'.tr,
                                        style: AppThemeData.semiBoldTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            controller.userModel.value.userData!.isOwner == "true"
                                ? SizedBox()
                                : InkWell(
                                    onTap: () {
                                      Get.to(VehicleInfoScreen());
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(height: 24, "assets/icons/car-fill.svg"),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                            child: Text(
                                              'Vehicle Information\'s'.tr,
                                              style: AppThemeData.semiBoldTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            size: 16,
                                            color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                            _shouldShowDocumentStatus(controller.userModel.value.userData!)
                                ? InkWell(
                                    onTap: () {
                                      Get.to(DocumentStatusScreen());
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(height: 24, "assets/icons/car-fill.svg"),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                            child: Text(
                                              'Document Status'.tr,
                                              style: AppThemeData.semiBoldTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            size: 16,
                                            color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                            controller.userModel.value.userData!.isOwner == "false" &&
                                    (controller.userModel.value.userData!.ownerId != null && controller.userModel.value.userData!.ownerId!.isNotEmpty)
                                ? SizedBox()
                                : Constant.subscriptionModel == false
                                    ? SizedBox()
                                    : InkWell(
                                        onTap: () {
                                          Get.to(SubscriptionPlanScreen())!.then(
                                            (value) {
                                              if (value == true) {
                                                controller.getUserData();
                                              }
                                            },
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 10),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(height: 24, "assets/icons/vip-crown-2-fill.svg"),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  'Subscription Plan'.tr,
                                                  style: AppThemeData.semiBoldTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                                ),
                                              ),
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                size: 16,
                                                color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                            controller.userModel.value.userData!.isOwner == "false" &&
                                    (controller.userModel.value.userData!.ownerId != null && controller.userModel.value.userData!.ownerId!.isNotEmpty)
                                ? SizedBox()
                                : InkWell(
                                    onTap: () {
                                      Get.to(SubscriptionHistoryScreen());
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(height: 24, "assets/icons/hourglass-line.svg", colorFilter: ColorFilter.mode(AppThemeData.primaryDark, BlendMode.srcIn)),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                            child: Text(
                                              'Subscription History'.tr,
                                              style: AppThemeData.semiBoldTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            size: 16,
                                            color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),

                            controller.userModel.value.userData!.isOwner == "false" &&
                                    (controller.userModel.value.userData!.ownerId != null && controller.userModel.value.userData!.ownerId!.isNotEmpty)
                                ? SizedBox()
                                : InkWell(
                                    onTap: () {
                                      Get.to(BankDetailsAdd());
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            height: 24,
                                            "assets/icons/ic_bank.svg",
                                            colorFilter: ColorFilter.mode(AppThemeData.warningDark, BlendMode.srcIn),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                            child: Text(
                                              'Bank Details'.tr,
                                              style: AppThemeData.semiBoldTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            size: 16,
                                            color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                            // controller.userModel.value.userData!.isOwner == "false" ||
                            //         (controller.userModel.value.userData!.ownerId != null &&
                            //             controller.userModel.value.userData!.ownerId!.isNotEmpty)
                            //     ? SizedBox()
                            //     : InkWell(
                            //         onTap: () {
                            //           Get.to(DocumentStatusScreen());
                            //         },
                            //         child: Padding(
                            //           padding: const EdgeInsets.symmetric(vertical: 10),
                            //           child: Row(
                            //             children: [
                            //               SvgPicture.asset(height: 24, "assets/icons/file-paper-fill.svg"),
                            //               SizedBox(
                            //                 width: 20,
                            //               ),
                            //               Expanded(
                            //                 child: Text(
                            //                   'My Documents',
                            //                   style: AppThemeData.semiBoldTextStyle(
                            //                       fontSize: 16,
                            //                       color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                            //                 ),
                            //               ),
                            //               Icon(
                            //                 Icons.arrow_forward_ios,
                            //                 size: 16,
                            //                 color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                            //               )
                            //             ],
                            //           ),
                            //         ),
                            //       ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: themeChange.getThem() ? AppThemeData.neutralDark100 : AppThemeData.neutral100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Get.to(LocalizationScreens(
                                  intentType: 'dashBoard',
                                ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(height: 24, "assets/icons/globe-fill.svg"),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Change Language'.tr,
                                        style: AppThemeData.semiBoldTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(TermsOfServiceScreen());
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(height: 24, "assets/icons/book-2-fill.svg"),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Terms & Conditions'.tr,
                                        style: AppThemeData.semiBoldTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(PrivacyPolicyScreen());
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(height: 24, "assets/icons/shield-flash-fill.svg"),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Privacy & Policy'.tr,
                                        style: AppThemeData.semiBoldTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {},
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(height: 24, "assets/icons/moon-clear-fill.svg"),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Dark Mode'.tr,
                                        style: AppThemeData.semiBoldTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 25,
                                      child: Switch(
                                        trackOutlineColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                                          return Colors.transparent;
                                        }),
                                        inactiveTrackColor: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300,
                                        activeTrackColor: AppThemeData.successDefault,
                                        thumbColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                                          return themeChange.getThem() ? AppThemeData.neutralDark50 : AppThemeData.neutral50;
                                        }),
                                        value: themeChange.getThem(),
                                        onChanged: (value) => (themeChange.darkTheme = value == true ? 0 : 1),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: themeChange.getThem() ? AppThemeData.neutralDark100 : AppThemeData.neutral100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: InkWell(
                          onTap: () async {
                            try {
                              if (await controller.inAppReview.isAvailable()) {
                                controller.inAppReview.requestReview();
                              } else {
                                controller.inAppReview.openStoreListing();
                              }
                            } catch (e) {
                              log("Error triggering in-app review: $e");
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                SvgPicture.asset(height: 24, "assets/icons/star-smile-fill.svg"),
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Text(
                                    'Rate the app'.tr,
                                    style: AppThemeData.semiBoldTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: themeChange.getThem() ? AppThemeData.neutralDark100 : AppThemeData.neutral100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                logoutBottomSheet(themeChange, context, controller);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(height: 24, "assets/icons/ic_logout.svg"),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Log out'.tr,
                                        style: AppThemeData.semiBoldTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                deleteBottomSheet(themeChange, context, controller);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(height: 24, "assets/icons/ic_delete.svg"),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Delete Account'.tr,
                                        style: AppThemeData.semiBoldTextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.errorDefault : AppThemeData.errorDefault),
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future deleteBottomSheet(themeChange, BuildContext context, ProfileController controller) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.38,
          // Open at 50% of the screen
          minChildSize: 0.38,
          // Minimum height 50%
          maxChildSize: 0.8,
          // Maximum height full screen
          expand: false,
          builder: (context, scrollController) {
            return SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color: themeChange.getThem() ? AppThemeData.neutralDark50 : AppThemeData.neutral50,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        'Delete Account'.tr,
                        textAlign: TextAlign.center,
                        style: AppThemeData.boldTextStyle(
                          fontSize: 24,
                          color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Permanently remove your account and all associated data from our system. This action is irreversible. Once deleted, your profile, settings, and any saved information will no longer be accessible. Please ensure you have backed up any important data before proceeding.'
                            .tr,
                        textAlign: TextAlign.start,
                        style: AppThemeData.mediumTextStyle(
                          fontSize: 16,
                          color: themeChange.getThem() ? AppThemeData.neutralDark500 : AppThemeData.neutral500,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: RoundedButtonFill(
                              title: "Delete".tr,
                              height: 5.5,
                              color: AppThemeData.errorDefault,
                              textColor: AppThemeData.neutral50,
                              onPress: () async {
                                controller.deleteDriver();
                              },
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: RoundedButtonFill(
                              title: "Cancel".tr,
                              height: 5.5,
                              color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300,
                              textColor: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                              onPress: () async {
                                Get.back();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future logoutBottomSheet(themeChange, BuildContext context, ProfileController controller) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.3,
          // Open at 50% of the screen
          minChildSize: 0.3,
          // Minimum height 50%
          maxChildSize: 0.8,
          // Maximum height full screen
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: themeChange.getThem() ? AppThemeData.neutralDark50 : AppThemeData.neutral50,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      '⚠️ Log Out?'.tr,
                      textAlign: TextAlign.center,
                      style: AppThemeData.boldTextStyle(
                        fontSize: 24,
                        color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Are you sure you want to log out from your account? You’ll need to log in again to access your profile and ride history.'.tr,
                      textAlign: TextAlign.start,
                      style: AppThemeData.mediumTextStyle(
                        fontSize: 16,
                        color: themeChange.getThem() ? AppThemeData.neutralDark500 : AppThemeData.neutral500,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: RoundedButtonFill(
                            title: "Log out".tr,
                            height: 5.5,
                            color: AppThemeData.errorDefault,
                            textColor: AppThemeData.neutral50,
                            onPress: () async {
                              await controller.logout();
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: RoundedButtonFill(
                            title: "Cancel".tr,
                            height: 5.5,
                            color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300,
                            textColor: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                            onPress: () async {
                              Get.back();
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
        );
      },
    );
  }

  bool _shouldShowDocumentStatus(UserData user) {
    // Document verification must be enabled for either owner or driver
    final isVerificationEnabled = Constant.ownerDocVerification == "yes" || Constant.driverDocVerification == "yes";

    // If user is a sub-owner, then skip
    final isSubOwner = user.isOwner == "false" && user.ownerId != null && user.ownerId!.isNotEmpty;

    return isVerificationEnabled && !isSubOwner;
  }
}
