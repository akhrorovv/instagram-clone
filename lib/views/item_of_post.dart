import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_clone/controllers/feed_controller.dart';
import 'package:share_plus/share_plus.dart';
import '../models/post_model.dart';

Widget itemOfPost(Post post, FeedController feedController) {
  return GestureDetector(
    onDoubleTap: () {
      if (!post.liked) {
        feedController.apiPostLike(post);
      } else {
        feedController.apiPostUnLike(post);
      }
    },
    child: Container(
      color: Colors.white,
      child: Column(
        children: [
          const Divider(),
          //#user info
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: post.img_user.isEmpty
                          ? const Image(
                              image: AssetImage("assets/images/person.jpg"),
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              post.img_user,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.fullName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          post.date,
                          style: const TextStyle(fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ],
                ),
                post.mine
                    ? IconButton(
                        icon: const Icon(Icons.more_horiz),
                        onPressed: () {
                          feedController.dialogRemovePost(post);
                        },
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),

          //#post image
          const SizedBox(height: 8),
          CachedNetworkImage(
            width: Get.context!.mediaQuery.size.width,
            imageUrl: post.img_post,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.cover,
          ),

          //#like share
          Row(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (!post.liked) {
                        feedController.apiPostLike(post);
                      } else {
                        feedController.apiPostUnLike(post);
                      }
                    },
                    icon: post.liked
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.favorite_border,
                          ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await Share.share(post.img_post);
                    },
                    icon: const Icon(Icons.share),
                  ),
                ],
              )
            ],
          ),

          //#caption
          Container(
            width: Get.context!.mediaQuery.size.width,
            margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: RichText(
              softWrap: true,
              overflow: TextOverflow.visible,
              text: TextSpan(
                text: post.caption,
                style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
