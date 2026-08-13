
import 'package:cabme_driver/themes/app_them_data.dart';
import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: isDarkTheme ? AppThemeData.neutralDark50 : AppThemeData.neutral50,
        elevation: 0,
      ),
      scaffoldBackgroundColor: isDarkTheme ? AppThemeData.neutralDark50 : AppThemeData.neutral50,
      primaryColor: isDarkTheme ? AppThemeData.primaryDarkDefault : AppThemeData.primaryDefault,
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      timePickerTheme: TimePickerThemeData(
        backgroundColor: isDarkTheme ? AppThemeData.neutralDark50 : AppThemeData.neutral50,
        dialTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: isDarkTheme ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
        ),
        dialTextColor: isDarkTheme ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
        hourMinuteTextColor: isDarkTheme ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
        dayPeriodTextColor: isDarkTheme ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
      ),
    );
  }
}
