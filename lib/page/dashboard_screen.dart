import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/controller/dashboard_screen_controller.dart';
import 'package:cabme_driver/themes/app_them_data.dart';
import 'package:cabme_driver/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: DashBoardScreenController(),
        builder: (controller) {
          return Scaffold(
            body: controller.isLoading.value ? Constant.loader(context) : controller.pageList[controller.selectedIndex.value],
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: true,
              showSelectedLabels: true,
              selectedFontSize: 12,
              selectedLabelStyle: const TextStyle(fontFamily: AppThemeData.bold),
              unselectedLabelStyle: const TextStyle(fontFamily: AppThemeData.bold),
              currentIndex: controller.selectedIndex.value,
              backgroundColor: themeChange.getThem() ? AppThemeData.neutralDark50 : AppThemeData.neutral50,
              selectedItemColor: themeChange.getThem() ? AppThemeData.primaryDefault : AppThemeData.primaryDefault,
              unselectedItemColor: themeChange.getThem() ? AppThemeData.neutralDark500 : AppThemeData.neutral500,
              onTap: (int index) {
                controller.selectedIndex.value = index;
              },
              items: controller.userModel.value.userData!.isOwner == "false" &&
                      (controller.userModel.value.userData!.ownerId != null && controller.userModel.value.userData!.ownerId!.isNotEmpty)
                  ? [
                      navigationBarItem(
                        themeChange,
                        index: 0,
                        assetIcon: "assets/icons/ic_home.svg",
                        label: 'Home'.tr,
                        controller: controller,
                      ),
                      navigationBarItem(
                        themeChange,
                        index: 1,
                        assetIcon: "assets/icons/ic_booking.svg",
                        label: 'Booking'.tr,
                        controller: controller,
                      ),
                      navigationBarItem(
                        themeChange,
                        index: 2,
                        assetIcon: "assets/icons/ic_user.svg",
                        label: 'Profile'.tr,
                        controller: controller,
                      ),
                    ]
                  : [
                      navigationBarItem(
                        themeChange,
                        index: 0,
                        assetIcon: "assets/icons/ic_home.svg",
                        label: 'Home'.tr,
                        controller: controller,
                      ),
                      navigationBarItem(
                        themeChange,
                        index: 1,
                        assetIcon: "assets/icons/ic_booking.svg",
                        label: 'Booking'.tr,
                        controller: controller,
                      ),
                      navigationBarItem(
                        themeChange,
                        index: 2,
                        assetIcon: "assets/icons/ic_wallet.svg",
                        label: 'Wallet'.tr,
                        controller: controller,
                      ),
                      navigationBarItem(
                        themeChange,
                        index: 3,
                        assetIcon: "assets/icons/ic_user.svg",
                        label: 'Profile'.tr,
                        controller: controller,
                      ),
                    ],
            ),
          );
        });
  }

  BottomNavigationBarItem navigationBarItem(themeChange, {required int index, required String label, required String assetIcon, required DashBoardScreenController controller}) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: SvgPicture.asset(
          assetIcon,
          height: 22,
          width: 22,
          colorFilter: ColorFilter.mode(
              controller.selectedIndex.value == index
                  ? themeChange.getThem()
                      ? AppThemeData.primaryDefault
                      : AppThemeData.primaryDefault
                  : themeChange.getThem()
                      ? AppThemeData.neutralDark500
                      : AppThemeData.neutral500,
              BlendMode.srcIn),
        ),
      ),
      label: label,
    );
  }
}
