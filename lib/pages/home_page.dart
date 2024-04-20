import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:instagram_clone/pages/profile_page.dart';
import 'package:instagram_clone/pages/search_page.dart';
import 'package:instagram_clone/pages/upload_page.dart';

import 'feed_page.dart';
import 'likes_page.dart';

class HomePage extends StatefulWidget {
  static const String id = "home_page";

  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController? _pageController;
  int _currentTap = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          FeedPage(
            pageController: _pageController,
          ),
          const SearchPage(),
          UploadPage(
            pageController: _pageController,
          ),
          const LikesPage(),
          const ProfilePage(),
        ],
        onPageChanged: (int index) {
          setState(() {
            _currentTap = index;
          });
        },
      ),
      bottomNavigationBar: CupertinoTabBar(
        onTap: (int index) {
          setState(() {
            _currentTap = index;
            _pageController!.animateToPage(index,
                duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
          });
        },
        currentIndex: _currentTap,
        activeColor: const Color.fromRGBO(193, 53, 132, 1),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Iconsax.home,
              size: 30,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Iconsax.search_normal,
              size: 30,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Iconsax.add_square,
              size: 30,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Iconsax.heart,
              size: 30,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Iconsax.profile_circle,
              size: 30,
            ),
          )
        ],
      ),
    );
  }
}
