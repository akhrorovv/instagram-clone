import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../controllers/profile_controller.dart';
import '../models/post_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final profileController = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    profileController.apiLoadMember();
    profileController.apiLoadPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.black,
            fontFamily: "Billabong",
            fontSize: 25,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              profileController.dialogLogout();
            },
            icon: const Icon(Iconsax.logout),
            color: const Color.fromRGBO(193, 53, 132, 1),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: profileController.handleRefresh,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  //#myphoto
                  GestureDetector(
                    onTap: () {
                      profileController.showPicker(context);
                    },
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(70),
                            border: Border.all(
                              width: 1.5,
                              color: const Color.fromRGBO(193, 53, 132, 1),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(35),
                            child: profileController.img_url.isEmpty
                                ? const Image(
                                    image:
                                        AssetImage("assets/images/person.jpg"),
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    profileController.img_url,
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        const SizedBox(
                          width: 80,
                          height: 80,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.add_circle,
                                color: Colors.purple,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  //#myinfos
                  const SizedBox(height: 10),
                  Text(
                    profileController.fullname.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    profileController.email,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),

                  //#mycounts
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    height: 80,
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  profileController.count_posts.toString(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                const Text(
                                  "POSTS",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  profileController.count_followers.toString(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                const Text(
                                  "FOLLOWERS",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  profileController.count_following.toString(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                const Text(
                                  "FOLLOWING",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //list or grid
                  Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                profileController.axisCount = 2;
                              });
                            },
                            icon: profileController.axisCount == 2
                                ? const Icon(Iconsax.category5)
                                : const Icon(Iconsax.category),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                profileController.axisCount = 1;
                              });
                            },
                            icon: profileController.axisCount == 1
                                ? const Icon(Iconsax.document5)
                                : const Icon(Iconsax.document),
                          ),
                        ),
                      ),
                    ],
                  ),

                  //#myposts
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: profileController.axisCount),
                      itemCount: profileController.items.length,
                      itemBuilder: (ctx, index) {
                        return _itemOfPost(profileController.items[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
            // isLoading
            //     ? const Center(
            //         child: CircularProgressIndicator(),
            //       )
            //     : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _itemOfPost(Post post) {
    return GestureDetector(
      onLongPress: () {
        profileController.dialogRemovePost(post);
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        child: Column(
          children: [
            Expanded(
              child: CachedNetworkImage(
                width: double.infinity,
                imageUrl: post.img_post,
                placeholder: (context, url) =>
                    Container(color: Colors.grey[200]),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              post.caption,
              style: TextStyle(color: Colors.black87.withOpacity(0.7)),
              maxLines: 2,
            )
          ],
        ),
      ),
    );
  }
}
