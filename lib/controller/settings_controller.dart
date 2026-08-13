import 'package:cabme_driver/service/notification_service.dart';

import 'package:get/get.dart';

class SettingsController extends GetxController {
  @override
  void onInit() {
    notificationInit();
    super.onInit();
  }

  RxBool isLoading = true.obs;

  NotificationService notificationService = NotificationService();

  void notificationInit() {
    notificationService.initInfo();
    isLoading.value = false;
    update();
  }
}
