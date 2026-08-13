import 'package:cabme_driver/themes/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_them_data.dart';

class RoundedButtonBorder extends StatelessWidget {
  final String title;
  final double? width;
  final double? height;
  final double? fontSizes;
  final Color? color;
  final Color? borderColor;
  final Color? textColor;
  final Widget? icon;
  final bool? isRight;
  final bool? isCenter;
  final Function()? onPress;

  const RoundedButtonBorder({
    super.key,
    required this.title,
    this.height,
    required this.onPress,
    this.width,
    this.color,
    this.icon,
    this.fontSizes,
    this.textColor,
    this.isRight,
    this.borderColor,
    this.isCenter,
  });

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
          color: color ?? Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(color: borderColor ?? AppThemeData.neutral900),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            (isRight == false) ? Padding(padding: const EdgeInsets.only(right: 5, left: 20), child: icon) : const SizedBox(),
            isCenter == true
                ? Text(
                    title.toString().tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppThemeData.semibold,
                      color: textColor ?? AppThemeData.neutral900,
                      fontSize: fontSizes ?? 14,
                    ),
                  )
                : Expanded(
                    child: Text(
                      title.toString().tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppThemeData.semibold,
                        color: textColor ?? AppThemeData.neutral900,
                        fontSize: fontSizes ?? 14,
                      ),
                    ),
                  ),
            (isRight == true) ? Padding(padding: const EdgeInsets.only(left: 0, right: 20), child: icon) : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
