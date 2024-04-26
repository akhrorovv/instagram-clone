import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../controllers/home_controller.dart';
import 'feed_page.dart';
import 'likes_page.dart';
import 'profile_page.dart';
import 'search_page.dart';
import 'upload_page.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  static const String id = "home_page";

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final homeController = Get.find<HomeController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homeController.pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<HomeController>(
        builder: (homeController) {
          return PageView(
            controller: homeController.pageController,
            children: [
              FeedPage(pageController: homeController.pageController),
              const SearchPage(),
              UploadPage(pageController: homeController.pageController),
              const LikesPage(),
              const ProfilePage(),
            ],
            onPageChanged: (int index) {
              homeController.currentPage = index;
              homeController.update();
            },
          );
        },
      ),
      bottomNavigationBar: CupertinoTabBar(
        onTap: (int index) {
          setState(() {
            homeController.currentPage = index;
            homeController.pageController!.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          });
        },
        currentIndex: homeController.currentPage,
        // activeColor: const Color.fromRGBO(12, 35, 229, 1.0),
        activeColor: Colors.black,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Iconsax.home, size: 30),
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.search_normal, size: 30),
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.add_square, size: 30),
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.heart, size: 30),
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.profile_circle, size: 30),
          )
        ],
      ),
    );
  }
}
