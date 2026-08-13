import 'package:flutter/material.dart';

class AppThemeData {
  static Color primaryDefault = Color(0xFF4338CA);
  static const Color primaryLight = Color(0xFFFEF08A);
  static const Color primaryDark = Color(0xFFEAB308);
  static const Color primaryHover = Color(0xFFFDE047);
  static const Color primaryPressed = Color(0xFFCA8A04);

  static const Color primaryDarkDefault = Color(0xFFFDE047);
  static const Color primaryDarkLight = Color(0xFFFDE68A);
  static const Color primaryDarkDark = Color(0xFFCA8A04);
  static const Color primaryDarkHover = Color(0xFFFACC15);
  static const Color primaryDarkPressed = Color(0xFFA16207);

  static const Color secondary200 = Color(0xFFFCA431);

  static const Color neutral50 = Color(0xFFFFFFFF);
  static const Color neutral100 = Color(0xFFF9FAFB);
  static const Color neutral200 = Color(0xFFF3F4F6);
  static const Color neutral300 = Color(0xFFE5E7EB);
  static const Color neutral500 = Color(0xFF6B7280);
  static const Color neutral700 = Color(0xFF374151);
  static const Color neutral900 = Color(0xFF111827);

  static const Color neutralDark50 = Color(0xFF0F172A);
  static const Color neutralDark100 = Color(0xFF1E293B);
  static const Color neutralDark200 = Color(0xFF334155);
  static const Color neutralDark300 = Color(0xFF475569);
  static const Color neutralDark500 = Color(0xFF94A3B8);
  static const Color neutralDark700 = Color(0xFFCBD5E1);
  static const Color neutralDark900 = Color(0xFFF8FAFC);

  static const Color accentDefault = Color(0xFF6366F1);
  static const Color accentLight = Color(0xFFE0E7FF);
  static const Color accentDark = Color(0xFF4F46E5);

  static const Color accentDarkDefault = Color(0xFF818CF8);
  static const Color accentDarkLight = Color(0xFF312E81);
  static const Color accentDarkDark = Color(0xFF4338CA);

  static const Color successDefault = Color(0xFF10B981);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color successDark = Color(0xFF047857);

  static const Color successDarkDefault = Color(0xFF34D399);
  static const Color successDarkLight = Color(0xFF064E3B);
  static const Color successDarkDark = Color(0xFF059669);

  static const Color errorDefault = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color errorDark = Color(0xFFB91C1C);

  static const Color errorDarkDefault = Color(0xFFEF4444);
  static const Color errorDarkLight = Color(0xFFFEE2E2);
  static const Color errorDarkDark = Color(0xFFB91C1C);

  static const Color warningDefault = Color(0xFFFEF3C7);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color warningDark = Color(0xFFB45309);

  static const Color warningDarkDefault = Color(0xFFFEF3C7);
  static const Color warningDarkLight = Color(0xFFFBBF24);
  static const Color warningDarkDark = Color(0xFFD97706);

  static const Color infoDefault = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);
  static const Color infoDark = Color(0xFF1D4ED8);

  static const Color infoDarkDefault = Color(0xFF60A5FA);
  static const Color infoDarkLight = Color(0xFFDBEAFE);
  static const Color infoDarkDark = Color(0xFF3B82F6);

  static List<dynamic> get homePageGradiant => [Color(0xFFF5F7FF), Color(0xFFFFF5F5), Color(0xFFF1FEF7), Color(0xFFF5F7FF)];

  // Dodger Blue (Primary)
  static const String regular = 'Manrope-Regular';
  static const String medium = 'Manrope-Medium';
  static const String bold = 'Manrope-Bold';
  static const String semibold = 'Manrope-SemiBold';
  static const String light = 'Manrope-Light';
  static const String extraBold = 'Manrope-ExtraBold';
  static const String extraLight = 'Manrope-ExtraLight';

  static TextStyle regularTextStyle({double? fontSize, Color? color, TextDecoration? decoration}) {
    return TextStyle(
      color: color ?? AppThemeData.neutral900,
      fontSize: fontSize ?? 14,
      fontFamily: regular,
      decoration: decoration ?? TextDecoration.none,
      decorationColor: color,
    );
  }

  static TextStyle semiBoldTextStyle({double? fontSize, Color? color, TextDecoration? decoration, FontStyle? fontStyle}) {
    return TextStyle(
      color: color ?? AppThemeData.neutral900,
      fontSize: fontSize ?? 14,
      fontFamily: semibold,
      fontStyle: fontStyle ?? FontStyle.normal,
      decoration: decoration ?? TextDecoration.none,
      decorationColor: color,
    );
  }

  static TextStyle boldTextStyle({double? fontSize, Color? color, TextDecoration? decoration}) {
    return TextStyle(
      color: color ?? AppThemeData.neutral900,
      fontSize: fontSize ?? 14,
      fontFamily: bold,
      decoration: decoration ?? TextDecoration.none,
      decorationColor: color,
    );
  }

  static TextStyle mediumTextStyle({double? fontSize, Color? color, TextDecoration? decoration}) {
    return TextStyle(
      color: color ?? AppThemeData.neutral900,
      fontSize: fontSize ?? 14,
      fontFamily: medium,
      decoration: decoration ?? TextDecoration.none,
      decorationColor: color,
    );
  }
}
