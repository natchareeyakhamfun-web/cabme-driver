import 'dart:async';
import 'dart:io';

import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/controller/conversation_controller.dart';
import 'package:cabme_driver/themes/app_them_data.dart';
import 'package:cabme_driver/themes/text_field_widget.dart';
import 'package:cabme_driver/utils/dark_theme_provider.dart';
import 'package:cabme_driver/widget/firebase_pagination/src/firestore_pagination.dart';
import 'package:cabme_driver/widget/firebase_pagination/src/models/view_type.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'FullScreenImageViewer.dart';
import 'FullScreenVideoViewer.dart';

class ConversationScreen extends StatelessWidget {
  const ConversationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<ConversationController>(
      init: ConversationController(),
      initState: (controller) {
        if (controller.controller!.scrollController.hasClients) {
          Timer(const Duration(milliseconds: 500),
              () => controller.controller!.scrollController.jumpTo(controller.controller!.scrollController.position.maxScrollExtent));
        }
      },
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            leading: InkWell(
              onTap: () {
                Get.back();
              },
              child: Icon(Icons.arrow_back),
            ),
            titleSpacing: 0,
            title: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: controller.receiverPhoto.value.isNotEmpty
                      ? CachedNetworkImageProvider(controller.receiverPhoto.value)
                      : const AssetImage("assets/images/user.png") as ImageProvider,
                ),
                const SizedBox(width: 20),
                Text(
                  controller.receiverName.value,
                  style: AppThemeData.semiBoldTextStyle(
                    color: themeChange.getThem() ? AppThemeData.neutralDark900 : AppThemeData.neutral900,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            centerTitle: false,
          ),
          body: Column(
            children: [
              Expanded(
                child: FirestorePagination(
                  controller: controller.scrollController,
                  physics: const BouncingScrollPhysics(),
                  onEmpty: Constant.showEmptyView(message: "No messages yet".tr),
                  itemBuilder: (context, documentSnapshots, index) {
                    final data = documentSnapshots[index].data() as Map?;
                    return chatItemView(data!['senderId'] == controller.senderId.value, data, controller, themeChange.getThem());
                  },
                  // orderBy is compulsory to enable pagination
                  query: Constant.conversation
                      .doc(
                          "${controller.senderId.value < controller.receiverId.value ? controller.senderId.value : controller.receiverId.value}-${controller.orderId}-${controller.senderId.value < controller.receiverId.value ? controller.receiverId.value : controller.senderId.value}")
                      .collection("thread")
                      .orderBy('created', descending: false),
                  //Change types accordingly
                  viewType: ViewType.list,
                  // to fetch real-time data
                  isLive: true,
                ),
              ),
              buildMessageInput(controller, context)
            ],
          ),
        );
      },
    );
  }

  Widget chatItemView(bool isMe, Map<dynamic, dynamic> data, ConversationController controller, bool isDarKMode) {
    return Container(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
      child: isMe
          ? Align(
              alignment: Alignment.topRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      data['type'].toString() == "text"
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                                color: AppThemeData.primaryDefault,
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              child: Text(
                                data['message'].toString(),
                                style: AppThemeData.semiBoldTextStyle(
                                    color: data['senderId'] == controller.senderId.value ? Colors.white : Colors.black),
                              ),
                            )
                          : data['type'] == "image"
                              ? ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    minWidth: 50,
                                    maxWidth: 200,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                                    child: Stack(alignment: Alignment.center, children: [
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(() => FullScreenImageViewer(
                                                imageUrl: data['url']['url'],
                                              ));
                                        },
                                        child: Hero(
                                          tag: data['url']['url'],
                                          child: CachedNetworkImage(
                                            imageUrl: data['url']['url'],
                                            placeholder: (context, url) => Constant.loader(context),
                                            errorWidget: (context, url, error) => const Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ))
                              : FloatingActionButton(
                                  mini: true,
                                  heroTag: data['id'],
                                  backgroundColor: AppThemeData.primaryDefault,
                                  onPressed: () {
                                    Get.to(FullScreenVideoViewer(
                                      heroTag: data['id'],
                                      videoUrl: data['url']['url'],
                                    ));
                                  },
                                  child: const Icon(
                                    Icons.play_arrow,
                                    color: Colors.white,
                                  ),
                                ),
                      SizedBox(height: 3),
                      Text(
                        Constant.timestampToDateTime(data['created']),
                        style: AppThemeData.mediumTextStyle(
                            color: isDarKMode ? AppThemeData.neutralDark700 : AppThemeData.neutral700, fontSize: 12),
                      )
                    ],
                  ),
                ],
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    data['type'] == "text"
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                              color: isDarKMode ? AppThemeData.neutralDark200 : AppThemeData.neutral200,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            child: Text(
                              data['message'].toString(),
                              style: AppThemeData.semiBoldTextStyle(
                                  color: data['senderId'] == controller.senderId.value
                                      ? Colors.white
                                      : isDarKMode
                                          ? AppThemeData.neutralDark900
                                          : AppThemeData.neutral900),
                            ),
                          )
                        : data['type'] == "image"
                            ? ConstrainedBox(
                                constraints: const BoxConstraints(
                                  minWidth: 50,
                                  maxWidth: 200,
                                ),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                                  child: Stack(alignment: Alignment.center, children: [
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(FullScreenImageViewer(
                                          imageUrl: data['url']['url'],
                                        ));
                                      },
                                      child: Hero(
                                        tag: data['url']['url'],
                                        child: CachedNetworkImage(
                                          imageUrl: data['url']['url'],
                                          placeholder: (context, url) => Constant.loader(context),
                                          errorWidget: (context, url, error) => const Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  ]),
                                ))
                            : FloatingActionButton(
                                mini: true,
                                heroTag: data['id'],
                                backgroundColor: AppThemeData.primaryDefault,
                                onPressed: () {
                                  Get.to(FullScreenVideoViewer(
                                    heroTag: data['id'],
                                    videoUrl: data['url']['url'],
                                  ));
                                },
                                child: const Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                ),
                              ),

                    SizedBox(height: 3),
                    Text(
                      Constant.timestampToDateTime(data['created']),
                      style: AppThemeData.mediumTextStyle(
                          color: isDarKMode ? AppThemeData.neutralDark700 : AppThemeData.neutral700, fontSize: 12),
                    )
                  ],
                ),
              ],
            ),
    );
  }

  Widget buildMessageInput(ConversationController controller, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppThemeData.primaryDefault,
                borderRadius: BorderRadius.circular(30),
              ),
              child: IconButton(
                onPressed: () async {
                  _onCameraClick(context, controller);
                },
                icon: const Icon(Icons.camera_alt),
                color: AppThemeData.neutral50,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextFieldWidget(
                controller: controller.messageController.value,
                hintText: 'Write message here...',
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              decoration: BoxDecoration(
                color: AppThemeData.primaryDefault,
                borderRadius: BorderRadius.circular(30),
              ),
              child: IconButton(
                onPressed: () async {
                  if (controller.messageController.value.text.trim().isNotEmpty) {
                    controller.sendMessage(controller.messageController.value.text.trim(), Url(mime: '', url: ''), "", "text");
                    Timer(const Duration(milliseconds: 500),
                        () => controller.scrollController.jumpTo(controller.scrollController.position.maxScrollExtent));
                    controller.messageController.value.clear();
                  } else {
                    ShowToastDialog.showToast("Please enter a message".tr);
                  }
                },
                icon: const Icon(
                  Icons.send_rounded,
                  size: 20,
                ),
                color: AppThemeData.neutral50,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onCameraClick(BuildContext context, ConversationController controller) {
    final action = CupertinoActionSheet(
      message: Text(
        'Send media'.tr,
        style: const TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          isDefaultAction: false,
          onPressed: () async {
            Get.back();
            XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
            if (image != null) {
              Url url = await Constant.uploadChatImageToFireStorage(File(image.path));
              controller.sendMessage("Sent an image".tr, url, "", 'image');
            }
          },
          child: Text('Choose image from gallery'.tr),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: false,
          onPressed: () async {
            Get.back();
            XFile? galleryVideo = await ImagePicker().pickVideo(source: ImageSource.gallery);
            if (galleryVideo != null) {
              ChatVideoContainer? videoContainer = await Constant.uploadChatVideoToFireStorage(File(galleryVideo.path));
              if (videoContainer != null) {
                controller.sendMessage('Sent an video'.tr, videoContainer.videoUrl, videoContainer.thumbnailUrl, 'video');
              }
            }
          },
          child: Text('Choose video from gallery'.tr),
        ),
        CupertinoActionSheetAction(
          isDestructiveAction: false,
          onPressed: () async {
            Get.back();
            XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
            if (image != null) {
              Url url = await Constant.uploadChatImageToFireStorage(File(image.path));
              controller.sendMessage('Sent an image'.tr, url, '', 'image');
            }
          },
          child: Text('Take a picture'.tr),
        ),
        CupertinoActionSheetAction(
          isDestructiveAction: false,
          onPressed: () async {
            Get.back();
            XFile? recordedVideo = await ImagePicker().pickVideo(source: ImageSource.camera);
            if (recordedVideo != null) {
              ChatVideoContainer? videoContainer = await Constant.uploadChatVideoToFireStorage(File(recordedVideo.path));
              if (videoContainer != null) {
                controller.sendMessage('Sent an video'.tr, videoContainer.videoUrl, videoContainer.thumbnailUrl, 'video');
              }
            }
          },
          child: Text('Record video'.tr),
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text(
          'cancel'.tr,
        ),
        onPressed: () {
          Get.back();
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }
}

class ChatVideoContainer {
  Url videoUrl;

  String thumbnailUrl;

  ChatVideoContainer({required this.videoUrl, required this.thumbnailUrl});
}
