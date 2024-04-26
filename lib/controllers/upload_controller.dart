import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/pages/feed_page.dart';
import '../models/post_model.dart';
import '../services/db_service.dart';
import '../services/file_service.dart';
import '../services/utils_service.dart';

class UploadController extends GetxController {
  bool isLoading = false;
  var captionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? imageFile;

  moveToFeed() {
    isLoading = false;
    update();

    captionController.text = "";
    imageFile = null;
    Get.to(const FeedPage());
    // pageController.animateToPage(
    //   0,
    //   duration: const Duration(microseconds: 200),
    //   curve: Curves.easeIn,
    // );
  }

  imgFromGallery() async {
    XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    imageFile = File(image!.path);
    update();
  }

  imgFromCamera() async {
    XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);

    imageFile = File(image!.path);
    update();
  }

  void showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                  leading: const Icon(Iconsax.gallery5),
                  title: const Text('Pick Photo'),
                  onTap: () {
                    imgFromGallery();
                    Navigator.of(context).pop();
                  }),
              ListTile(
                leading: const Icon(Iconsax.camera),
                title: const Text('Take Photo'),
                onTap: () {
                  imgFromCamera();
                  // Navigator.of(context).pop();
                  Get.back();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  uploadNewPost() {
    String caption = captionController.text.toString().trim();
    if (caption.isEmpty && imageFile == null) {
      Utils.fireToast('Please select image and write caption');
      return;
    }
    if (caption.isEmpty) {
      Utils.fireToast('Please enter caption');
      return;
    }
    if (imageFile == null) {
      Utils.fireToast('Please select image');
      return;
    }
    apiPostImage();
  }

  void apiPostImage() {
    isLoading = true;
    update();

    FileService.uploadPostImage(imageFile!)
        .then((downloadUrl) => {resPostImage(downloadUrl)});
  }

  void resPostImage(String downloadUrl) {
    String caption = captionController.text.toString().trim();
    Post post = Post(caption, downloadUrl);
    apiStorePost(post);
  }

  void apiStorePost(Post post) async {
    // Post to posts
    Post posted = await DBService.storePost(post);
    // Post to feeds
    DBService.storeFeed(posted).then((value) => {moveToFeed()});
  }
}
