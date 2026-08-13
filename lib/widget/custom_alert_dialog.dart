import 'package:cabme_driver/themes/app_them_data.dart';
import 'package:cabme_driver/themes/round_button_fill.dart';
import 'package:cabme_driver/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CustomAlertDialog extends StatefulWidget {
  final String title;
  final Function() onPressPositive;
  final Function() onPressNegative;
  final bool negativeButtonEnable;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.onPressPositive,
    required this.onPressNegative,
    required this.negativeButtonEnable,
  });

  @override
  _CustomAlertDialogState createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Stack contentBox(context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: themeChange.getThem() ? AppThemeData.neutralDark50 : AppThemeData.neutral50,
              borderRadius: BorderRadius.circular(0),
              boxShadow: const [
                BoxShadow(color: Colors.black, offset: Offset(0, 5), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: AppThemeData.semibold,
                  color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    child: RoundedButtonFill(
                      title: "Ok".tr,
                      height: 5.5,
                      color: AppThemeData.primaryDefault,
                      textColor: AppThemeData.neutral50,
                      onPress: widget.onPressPositive,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  widget.negativeButtonEnable
                      ? Expanded(
                          child: RoundedButtonFill(
                            title: "Yes".tr,
                            height: 5.5,
                            color: AppThemeData.neutral200,
                            textColor: AppThemeData.neutral50,
                            onPress: widget.onPressNegative,
                          ),
                        )
                      : SizedBox()
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
