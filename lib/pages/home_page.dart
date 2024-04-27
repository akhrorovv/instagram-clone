import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'my_feed_page.dart';
import 'my_likes_page.dart';
import 'my_profile_page.dart';
import 'my_search_page.dart';
import 'my_upload_page.dart';

class HomePage extends StatefulWidget {
  static const String id = "home_page";

  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
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
    return GetBuilder<HomeController>(
      builder: (_) {
        return Scaffold(
          body: PageView(
            controller: homeController.pageController,
            children: [
              MyFeedPage(
                pageController: homeController.pageController,
              ),
              const MySearchPage(),
              MyUploadPage(
                pageController: homeController.pageController,
              ),
              const MyLikesPage(),
              const MyProfilePage(),
            ],
            onPageChanged: (int index) {
              homeController.onPageChanged(index);
            },
          ),
          bottomNavigationBar: CupertinoTabBar(
            onTap: (int index) {
              homeController.animateToPage(index);
            },
            currentIndex: homeController.currentTap,
            activeColor: const Color.fromRGBO(193, 53, 132, 1),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 32),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search, size: 32),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_box, size: 32),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite, size: 32),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle, size: 32),
              )
            ],
          ),
        );
      },
    );
  }
}
