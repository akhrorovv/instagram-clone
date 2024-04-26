import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../controllers/feed_controller.dart';
import '../views/item_of_post.dart';

class FeedPage extends StatefulWidget {
  final PageController? pageController;

  const FeedPage({super.key, this.pageController});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final feedController = Get.find<FeedController>();

  @override
  void initState() {
    super.initState();
    feedController.apiLoadFeeds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Instagram",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Billabong',
            fontSize: 30,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              widget.pageController!.animateToPage(
                2,
                duration: const Duration(microseconds: 200),
                curve: Curves.easeIn,
              );
            },
            icon: const Icon(Iconsax.gallery_add),
            color: const Color.fromRGBO(193, 53, 132, 1),
          ),
        ],
      ),
      body: GetBuilder<FeedController>(
        builder: (feedController) {
          return RefreshIndicator(
            onRefresh: feedController.handleRefresh,
            child: Stack(
              children: [
                ListView.builder(
                  itemCount: feedController.items.length,
                  itemBuilder: (ctx, index) {
                    return itemOfPost(
                        feedController.items[index], feedController);
                  },
                ),
                feedController.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          );
        },
      ),
    );
  }
}
