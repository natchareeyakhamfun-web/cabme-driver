
import 'package:cabme_driver/themes/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../themes/app_them_data.dart';

class RoundedButtonFill extends StatelessWidget {
  final String title;
  final double? width;
  final double? height;
  final double? fontSizes;
  final double? borderRadius;
  final Color? color;
  final Color? textColor;
  final Widget? icon;
  final bool? isRight;
  final bool? isCenter;
  final Function()? onPress;

  const RoundedButtonFill(
      {super.key,
        required this.title,
        this.borderRadius,
        this.height,
        required this.onPress,
        this.width,
        this.color,
        this.isCenter,
        this.icon,
        this.fontSizes,
        this.textColor,
        this.isRight});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        onPress!();
      },
      child: Container(
        width: Responsive.width(width ?? 100, context),
        height: Responsive.height(height ?? 6, context),
        decoration: ShapeDecoration(
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 40),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            (isRight == false) ? Padding(padding: const EdgeInsets.only(right: 26, left: 20), child: icon) : const SizedBox(),
            isCenter == true
                ? Text(
              title.toString().tr,
              textAlign: TextAlign.center,
              style: AppThemeData.boldTextStyle(fontSize: fontSizes ?? 14, color: textColor ?? AppThemeData.neutral900),
            )
                : Expanded(
              child: Text(
                title.toString().tr,
                textAlign: TextAlign.center,
                style: AppThemeData.boldTextStyle(fontSize: fontSizes ?? 14, color: textColor ?? AppThemeData.neutral900),
              ),
            ),
            (isRight == true) ? Padding(padding: EdgeInsets.only(left: 5, right: isCenter == true ? 0 : 10), child: icon) : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
