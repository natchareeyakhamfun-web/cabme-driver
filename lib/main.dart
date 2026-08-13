import 'dart:convert';

import 'package:cabme_driver/controller/settings_controller.dart';
import 'package:cabme_driver/firebase_options.dart';
import 'package:cabme_driver/model/language_model.dart';
import 'package:cabme_driver/page/splash_screen.dart';
import 'package:cabme_driver/themes/styles.dart';
import 'package:cabme_driver/utils/dark_theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'constant/constant.dart';
import 'service/localization_service.dart';
import 'utils/Preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Preferences.initPref();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    getCurrentAppTheme();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Preferences.getString(Preferences.languageCodeKey).toString().isNotEmpty) {
        LanguageData languageModel = Constant.getLanguage();
        LocalizationService().changeLocale(languageModel.code.toString());
      } else {
        LanguageData languageModel = LanguageData(code: "en", isRtl: "no", language: "English");
        Preferences.setString(Preferences.languageCodeKey, jsonEncode(languageModel.toJson()));
      }
    });
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme = await themeChangeProvider.darkThemePreference.getTheme();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_) {
      return themeChangeProvider;
    }, child: Consumer<DarkThemeProvider>(builder: (context, value, child) {
      return GetMaterialApp(
        title: 'CabMe Driver',
        debugShowCheckedModeBanner: false,
        theme: Styles.themeData(
            themeChangeProvider.darkTheme == 0
                ? true
                : themeChangeProvider.darkTheme == 1
                    ? false
                    : themeChangeProvider.getSystemThem(),
            context),
        locale: LocalizationService.locale,
        fallbackLocale: LocalizationService.locale,
        translations: LocalizationService(),
        builder: (context, child) {
          return SafeArea(
            bottom: true,
            top: false,
            child: EasyLoading.init()(context, child),
          );
        },
        home: GetX(
            init: SettingsController(),
            builder: (controller) {
              return controller.isLoading.value ? Constant.loader(context) : SplashScreen();
            }),
      );
    }));
  }
}
