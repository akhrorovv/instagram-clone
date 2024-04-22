import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/pages/signin_page.dart';
import 'package:instagram_clone/services/auth_service.dart';

import '../models/member_model.dart';
import '../models/post_model.dart';
import '../services/db_service.dart';
import '../services/file_service.dart';
import '../services/utils_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoading = false;
  int axisCount = 2;
  List<Post> items = [];
  File? _image;
  String fullname = "", email = "", img_url = "";
  int count_posts = 0, count_followers = 0, count_following = 0;
  final ImagePicker _picker = ImagePicker();

  _imgFromGallery() async {
    XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    print(image!.path.toString());
    setState(() {
      _image = File(image.path);
    });
    _apiChangePhoto();
  }

  _imgFromCamera() async {
    XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    print(image!.path.toString());
    setState(() {
      _image = File(image.path);
    });
    _apiChangePhoto();
  }

  _apiChangePhoto() {
    if (_image == null) return;
    setState(() {
      isLoading = true;
    });
    FileService.uploadUserImage(_image!).then((downloadUrl) => {
          _apiUpdateMember(downloadUrl),
        });
  }

  _apiUpdateMember(String downloadUrl) async {
    Member member = await DBService.loadMember();
    member.img_url = downloadUrl;
    await DBService.updateMember(member);
    _apiLoadMember();
  }

  _showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Pick Photo'),
                  onTap: () {
                    _imgFromGallery();
                    Navigator.of(context).pop();
                  }),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take Photo'),
                onTap: () {
                  _imgFromCamera();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  _dialogRemovePost(Post post) async {
    var result = await Utils.dialogCommon(
        context, "Instagram", "Do you want to detele this post?", false);

    if (result) {
      setState(() {
        isLoading = true;
      });
      DBService.removePost(post).then((value) => {
            _apiLoadPosts(),
          });
    }
  }

  _dialogLogout() async {
    var result = await Utils.dialogCommon(
        context, "Instagram", "Do you want to logout?", false);
    if (result) {
      setState(() {
        isLoading = true;
      });
      _signOutUser();
    }
  }

  _signOutUser() {
    AuthService.signOutUser(context);
    Navigator.pushReplacementNamed(context, SignInPage.id);
  }

  void _apiLoadMember() {
    setState(() {
      isLoading = true;
    });
    DBService.loadMember().then((value) => {
          _showMemberInfo(value),
        });
  }

  void _showMemberInfo(Member member) {
    setState(() {
      isLoading = false;
      fullname = member.fullname;
      email = member.email;
      img_url = member.img_url;
      count_following = member.following_count;
      count_followers = member.followers_count;
    });
  }

  _apiLoadPosts() {
    DBService.loadPosts().then((value) => {
          _resLoadPosts(value),
        });
  }

  _resLoadPosts(List<Post> posts) {
    setState(() {
      isLoading = false;
      items = posts;
      count_posts = posts.length;
    });
  }

  @override
  void initState() {
    super.initState();
    _apiLoadMember();
    _apiLoadPosts();
  }

  Future<void> _handleRefresh() async {
    _apiLoadMember();
    // photos.clear();
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
              _dialogLogout();
            },
            icon: const Icon(Iconsax.logout),
            color: const Color.fromRGBO(193, 53, 132, 1),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
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
                      _showPicker(context);
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
                            child: img_url.isEmpty
                                ? const Image(
                                    image:
                                        AssetImage("assets/images/person.jpg"),
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    img_url,
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
                    fullname.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    email,
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
                                  count_posts.toString(),
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
                                  count_followers.toString(),
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
                                  count_following.toString(),
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
                                axisCount = 2;
                              });
                            },
                            icon: axisCount == 2
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
                                axisCount = 1;
                              });
                            },
                            icon: axisCount == 1
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
                          crossAxisCount: axisCount),
                      itemCount: items.length,
                      itemBuilder: (ctx, index) {
                        return _itemOfPost(items[index]);
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
        _dialogRemovePost(post);
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
