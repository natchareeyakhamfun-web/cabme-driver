import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/controller/document_status_contoller.dart';
import 'package:cabme_driver/model/uploaded_document_model.dart';
import 'package:cabme_driver/themes/app_them_data.dart';
import 'package:cabme_driver/themes/responsive.dart';
import 'package:cabme_driver/utils/dark_theme_provider.dart';
import 'package:cabme_driver/utils/network_image_widget.dart';
import 'package:cabme_driver/widget/custom_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../widget/round_button_fill.dart';

class DocumentStatusScreen extends StatelessWidget {
  DocumentStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return GetX<DocumentStatusController>(
      init: DocumentStatusController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            leading: InkWell(
              onTap: () {
                Get.back();
              },
              child: Icon(Icons.arrow_back),
            ),
            centerTitle: false,
          ),
          body: controller.isLoading.value
              ? Constant.loader(context)
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Upload Your Documents'.tr,
                        textAlign: TextAlign.center,
                        style: AppThemeData.boldTextStyle(
                            fontSize: 22, color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'We need to verify your identity.'.tr,
                        textAlign: TextAlign.center,
                        style: AppThemeData.mediumTextStyle(
                            fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark500 : AppThemeData.neutral500),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ListView.builder(
                        itemCount: controller.documentList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          UploadedDocumentData document = controller.documentList[index];
                          return InkWell(
                            onTap: () {
                              if (document.documentStatus == "Pending" || document.documentStatus == "Disapprove") {
                                buildBottomSheet(themeChange, context, controller, index, document.id.toString());
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 14),
                              padding: controller.documentList[index].documentPath!.isEmpty
                                  ? EdgeInsets.symmetric(vertical: 40, horizontal: 10)
                                  : EdgeInsets.zero,
                              decoration: BoxDecoration(
                                color: themeChange.getThem() ? AppThemeData.neutralDark100 : AppThemeData.neutral100,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: themeChange.getThem() ? AppThemeData.neutralDark300 : AppThemeData.neutral300,
                                ),
                              ),
                              child: controller.documentList[index].documentPath?.isEmpty == true
                                  ? Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset("assets/icons/ic_documenr.svg"),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'uploadDocument'.trParams({
                                            'title': document.title.toString(),
                                          }),
                                          textAlign: TextAlign.center,
                                          style: AppThemeData.semiBoldTextStyle(
                                              fontSize: 14,
                                              color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          'documentInstructions'.trParams({
                                            'title': document.title.toString(),
                                          }),
                                          textAlign: TextAlign.center,
                                          style: AppThemeData.mediumTextStyle(
                                              fontSize: 12,
                                              color: themeChange.getThem() ? AppThemeData.neutralDark500 : AppThemeData.neutral500),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          child: Stack(
                                            children: [
                                              NetworkImageWidget(
                                                height: Responsive.height(25, context),
                                                width: Responsive.width(90, context),
                                                fit: BoxFit.cover,
                                                imageUrl: controller.documentList[index].documentPath!,
                                              ),
                                              Positioned(
                                                right: 10,
                                                top: 10,
                                                child: Row(
                                                  children: [
                                                    RoundedButtonFill(
                                                      title: "${document.documentStatus}".tr,
                                                      height: 4.5,
                                                      width: 28,
                                                      color: document.documentStatus == "Pending" || document.documentStatus == "Disapprove"
                                                          ? AppThemeData.errorLight
                                                          : AppThemeData.successLight,
                                                      textColor:
                                                          document.documentStatus == "Pending" || document.documentStatus == "Disapprove"
                                                              ? AppThemeData.errorDefault
                                                              : AppThemeData.successDefault,
                                                      onPress: () async {},
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    document.documentStatus == "Disapprove"
                                                        ? RoundedButtonFill(
                                                            title: "".tr,
                                                            height: 4.5,
                                                            width: 11,
                                                            isCenter: false,
                                                            icon: Icon(
                                                              Icons.info,
                                                              color: AppThemeData.errorDefault,
                                                            ),
                                                            color: AppThemeData.errorLight,
                                                            textColor: AppThemeData.errorDefault,
                                                            isRight: true,
                                                            onPress: () async {
                                                              showDialog(
                                                                barrierColor: Colors.black26,
                                                                context: context,
                                                                builder: (context) {
                                                                  return CustomAlertDialog(
                                                                    title:
                                                                        "${'reason'.tr} ${controller.documentList[index].comment!.isEmpty ? 'underVerification'.tr : controller.documentList[index].comment!}",
                                                                    negativeButtonEnable: false,
                                                                    onPressPositive: () {
                                                                      Get.back();
                                                                    },
                                                                    onPressNegative: () {},
                                                                  );
                                                                },
                                                              );
                                                            },
                                                          )
                                                        : SizedBox(),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Future buildBottomSheet(themeChange, BuildContext context, DocumentStatusController controller, int index, String documentId) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return SizedBox(
              height: Responsive.height(22, context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 10),
                    child: Text(
                      'Please Select'.tr,
                      textAlign: TextAlign.center,
                      style: AppThemeData.boldTextStyle(
                          fontSize: 18, color: themeChange.getThem() ? AppThemeData.neutralDark500 : AppThemeData.neutral500),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () => pickFile(controller, source: ImageSource.camera, index: index, documentId: documentId),
                                icon: const Icon(
                                  Icons.camera_alt,
                                  size: 32,
                                )),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text(
                                'Camera'.tr,
                                textAlign: TextAlign.center,
                                style: AppThemeData.mediumTextStyle(
                                    fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark500 : AppThemeData.neutral500),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () => pickFile(controller, source: ImageSource.gallery, index: index, documentId: documentId),
                              icon: Icon(
                                Icons.photo_library_sharp,
                                size: 32,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text(
                                'Gallery'.tr,
                                textAlign: TextAlign.center,
                                style: AppThemeData.mediumTextStyle(
                                    fontSize: 16, color: themeChange.getThem() ? AppThemeData.neutralDark500 : AppThemeData.neutral500),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          });
        });
  }

  final ImagePicker _imagePicker = ImagePicker();

  Future pickFile(DocumentStatusController controller,
      {required ImageSource source, required int index, required String documentId}) async {
    try {
      XFile? image = await _imagePicker.pickImage(source: source);
      if (image == null) return;
      Get.back();
      controller.updateDocument(documentId, image.path);
    } on PlatformException catch (e) {
      ShowToastDialog.showToast("${"Failed to Pick".tr}: \n $e");
    }
  }

  Future buildAlertSendInformation(BuildContext context) {
    return Get.defaultDialog(
      radius: 6,
      title: "",
      titleStyle: const TextStyle(fontSize: 0.0),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "assets/images/green_checked.png",
                height: 100,
                width: 100,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                "${"Your information send well. We will treat them and inform you after the treatment.".tr} ${"Your account will be active after validation of your information.".tr}",
                textAlign: TextAlign.center,
                softWrap: true,
                style: const TextStyle(color: Colors.black54),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            RoundedButtonFill(
              title: "Close".tr,
              height: 5.5,
              color: AppThemeData.primaryDefault,
              textColor: AppThemeData.neutral50,
              onPress: () async {
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}
