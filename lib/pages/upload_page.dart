import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../controllers/upload_controller.dart';

class UploadPage extends StatefulWidget {
  final PageController? pageController;

  const UploadPage({super.key, this.pageController});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final uploadController = Get.find<UploadController>();
  PageController? pageController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Upload",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {
              uploadController.uploadNewPost();
            },
            icon: const Icon(
              Iconsax.gallery_export,
              color: Color.fromRGBO(193, 53, 132, 1),
            ),
          ),
        ],
      ),
      body: GetBuilder<UploadController>(
        builder: (uploadController) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          uploadController.showPicker(context);
                        },
                        child: Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.width,
                          color: Colors.grey.withOpacity(0.4),
                          child: uploadController.imageFile == null
                              ? const Center(
                                  child: Icon(
                                    Iconsax.gallery_add,
                                    size: 60,
                                    color: Colors.grey,
                                  ),
                                )
                              : Stack(
                                  children: [
                                    Image.file(
                                      uploadController.imageFile!,
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                    Container(
                                      width: double.infinity,
                                      color: Colors.black12,
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                uploadController.imageFile =
                                                    null;
                                              });
                                            },
                                            icon: const Icon(
                                                Icons.highlight_remove),
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: TextField(
                          controller: uploadController.captionController,
                          style: const TextStyle(color: Colors.black),
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            hintText: "Caption",
                            hintStyle:
                                TextStyle(fontSize: 17, color: Colors.black38),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              uploadController.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : const SizedBox.shrink(),
            ],
          );
        },
      ),
    );
  }
}
