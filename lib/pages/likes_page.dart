import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_clone/controllers/feed_controller.dart';
import '../controllers/likes_controller.dart';
import '../models/post_model.dart';
import '../services/db_service.dart';
import '../services/utils_service.dart';
import '../views/item_of_post.dart';

class LikesPage extends StatefulWidget {
  const LikesPage({super.key});

  @override
  State<LikesPage> createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {
  final likesController = Get.find<LikesController>();
  final feedController = Get.find<FeedController>();

  @override
  void initState() {
    super.initState();
    likesController.apiLoadLikes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Likes",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Billabong',
            fontSize: 30,
          ),
        ),
      ),
      body: GetBuilder<LikesController>(
        builder: (likesController) {
          return Stack(
            children: [
              ListView.builder(
                itemCount: likesController.items.length,
                itemBuilder: (ctx, index) {
                  return itemOfPost(
                      likesController.items[index], FeedController());
                },
              ),
              likesController.isLoading
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
