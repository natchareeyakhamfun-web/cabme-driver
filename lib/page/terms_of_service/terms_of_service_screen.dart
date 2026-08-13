import 'package:cabme_driver/controller/terms_of_service_controller.dart';
import 'package:cabme_driver/themes/app_them_data.dart';
import 'package:cabme_driver/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<TermsOfServiceController>(
        init: TermsOfServiceController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Terms & Conditions'.tr,
                textAlign: TextAlign.center,
                style: AppThemeData.boldTextStyle(fontSize: 18, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
              ),
              titleSpacing: 0,
              centerTitle: false,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: controller.termsData.value.isNotEmpty
                    ? Html(
                  data: controller.termsData.value,
                )
                    : const SizedBox(),
              ),
            ),
          );
        });
  }
}
