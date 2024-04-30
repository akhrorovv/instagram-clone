import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'my_feed_page.dart';
import 'my_likes_page.dart';
import 'my_profile_page.dart';
import 'my_search_page.dart';
import 'my_upload_page.dart';

class HomePage extends StatefulWidget {
  static const String id = "home_page";

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  PageController? pageController;
  int currentTap = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: [
          MyFeedPage(
            pageController: pageController,
          ),
          const MySearchPage(),
          MyUploadPage(
            pageController: pageController,
          ),
          const MyLikesPage(),
          const MyProfilePage(),
        ],
        onPageChanged: (int index) {
          setState(() {
            currentTap = index;
          });
        },
      ),
      bottomNavigationBar: CupertinoTabBar(
        onTap: (int index) {
          setState(() {
            currentTap = index;
            pageController!.animateToPage(index,
                duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
          });
        },
        currentIndex: currentTap,
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
  }
}
