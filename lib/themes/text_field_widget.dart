import 'package:cabme_driver/themes/app_them_data.dart';
import 'package:cabme_driver/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class TextFieldWidget extends StatelessWidget {
  final String? title;
  final String hintText;
  final TextEditingController? controller;
  final Widget? prefix;
  final Widget? suffix;
  final bool? enable;
  final bool? readOnly;
  final bool? obscureText;
  final int? maxLine;
  final double? radius;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onchange;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final Function()? onPress;


  const TextFieldWidget({
    super.key,
    this.textInputType,
    this.enable,
    this.readOnly,
    this.obscureText,
    this.prefix,
    this.suffix,
    this.title,
    required this.hintText,
    required this.controller,
    this.maxLine,
    this.radius,
    this.inputFormatters,
    this.onchange,
    this.textInputAction,
    this.focusNode,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: title != null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title == null ? '' : title!.tr,
                    style: AppThemeData.semiBoldTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark700 : AppThemeData.neutral700)),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
          TextFormField(
            keyboardType: textInputType ?? TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            controller: controller,
            maxLines: maxLine ?? 1,
            focusNode: focusNode,
            textInputAction: textInputAction ?? TextInputAction.done,
            inputFormatters: inputFormatters,
            obscureText: obscureText ?? false,
            obscuringCharacter: '●',
            onChanged: onchange,
            readOnly: readOnly ?? false,
            onTap: onPress,
            style: TextStyle(color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900, fontFamily: AppThemeData.medium),
            decoration: InputDecoration(
                errorStyle: const TextStyle(color: Colors.red),
                filled: true,
                enabled: enable ?? true,
                contentPadding: EdgeInsets.symmetric(
                    vertical: title == null
                        ? 15
                        : enable == false
                            ? 14
                            : 14,
                    horizontal: 10),
                fillColor: themeChange.getThem() ? AppThemeData.neutralDark100 : AppThemeData.neutral100,
                prefixIcon: prefix,
                suffixIcon: suffix,
                suffixIconConstraints: BoxConstraints(minHeight: 20, minWidth: 20),
                prefixIconConstraints: BoxConstraints(minHeight: 20, minWidth: 20),
                disabledBorder: OutlineInputBorder(
                  borderRadius:  BorderRadius.all(Radius.circular(radius??40)),
                  borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius:  BorderRadius.all(Radius.circular(radius??40)),
                  borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.primaryDarkDefault : AppThemeData.primaryDefault, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:  BorderRadius.all(Radius.circular(radius??40)),
                  borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300, width: 1),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius:  BorderRadius.all(Radius.circular(radius??40)),
                  borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300, width: 1),
                ),
                border: OutlineInputBorder(
                  borderRadius:  BorderRadius.all(Radius.circular(radius??40)),
                  borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300, width: 1),
                ),
                hintText: hintText.tr,
                hintStyle: AppThemeData.mediumTextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.neutralDark500 : AppThemeData.neutral500)),
          ),
        ],
      ),
    );
  }
}
