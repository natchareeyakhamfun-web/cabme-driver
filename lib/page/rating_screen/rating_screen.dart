import 'package:cabme_driver/controller/rating_controller.dart';
import 'package:cabme_driver/themes/app_them_data.dart';
import 'package:cabme_driver/themes/round_button_fill.dart';
import 'package:cabme_driver/utils/dark_theme_provider.dart';
import 'package:cabme_driver/widget/flutter_rating_bar/src/rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../themes/text_field_widget.dart';

class RatingScreen extends StatelessWidget {
  const RatingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: RatingController(),
        builder: (controller) {
          return Scaffold(
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(themeChange.getThem() ? "assets/images/rating_bg_dark.png" : "assets/images/rating_bg.png"),
                  fit: BoxFit.fill,
                ),
              ),
              child: Center(
                child: controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : Column(
                        children: [
                          AppBar(
                            backgroundColor: Colors.transparent,
                            leading: InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Icon(Icons.close)),
                          ),
                          const SizedBox(height: 50),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset("assets/images/rating_image.svg"),
                                    const SizedBox(height: 20),
                                    Text(
                                      'How was your ride?'.tr,
                                      textAlign: TextAlign.center,
                                      style: AppThemeData.boldTextStyle(
                                        fontSize: 24,
                                        color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Your feedback helps us improve and provide a better experience. Rate your driver and leave a comment!'.tr,
                                      textAlign: TextAlign.center,
                                      style: AppThemeData.regularTextStyle(
                                        fontSize: 16,
                                        color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    RatingBar.builder(
                                      initialRating: controller.rating.value,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) {
                                        controller.rating.value = rating;
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    TextFieldWidget(
                                      controller: controller.ratingController.value,
                                      hintText: 'Write something here...'.tr,
                                      title: 'Leave a Notes (Optional)'.tr,
                                      radius: 10,
                                      maxLine: 5,
                                    ),
                                    const SizedBox(height: 20),
                                    RoundedButtonFill(
                                      color: AppThemeData.primaryDefault,
                                      textColor: AppThemeData.neutral50,
                                      width: 100,
                                      height: 5.5,
                                      title: 'Submit'.tr,
                                      onPress: () {
                                        controller.submitReview();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          );
        });
  }
}
