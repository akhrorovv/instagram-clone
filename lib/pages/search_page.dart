import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/search_controller.dart';
import '../models/member_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final searchController = Get.find<SearchPageController>();

  @override
  void initState() {
    super.initState();
    searchController.apiSearchMembers('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Search",
          style: TextStyle(
            color: Colors.black,
            fontFamily: "Billabong",
            fontSize: 25,
          ),
        ),
      ),
      body: GetBuilder<SearchPageController>(
        builder: (searchController){
          return RefreshIndicator(
            onRefresh: searchController.handleRefresh,
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      //#search member
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: TextField(
                          style: const TextStyle(color: Colors.black87),
                          controller: searchController.searchController,
                          decoration: const InputDecoration(
                            hintText: "Search",
                            border: InputBorder.none,
                            hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
                            icon: Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),

                      //#member list
                      Expanded(
                        child: ListView.builder(
                          itemCount: searchController.items.length,
                          itemBuilder: (ctx, index) {
                            return _itemOfMember(searchController.items[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _itemOfMember(Member member) {
    return SizedBox(
      height: 90,
      child: Row(
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
              borderRadius: BorderRadius.circular(22.5),
              child: member.img_url.isEmpty
                  ? const Image(
                      image: AssetImage("assets/images/person.jpg"),
                      width: 45,
                      height: 45,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      member.img_url,
                      width: 45,
                      height: 45,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.fullname,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 3),
                Text(
                  overflow: TextOverflow.ellipsis,
                  member.email,
                  style: const TextStyle(color: Colors.black54, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(width: 7),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  if (member.followed) {
                    searchController.apiUnFollowMember(member);
                  } else {
                    searchController.apiFollowMember(member);
                  }
                },
                child: member.followed
                    ? Container(
                        width: 100,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(width: 1, color: Colors.black),
                        ),
                        child: const Center(child: Text("Following")),
                      )
                    : Container(
                        width: 100,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(5),
                          // border: Border.all(width: 1, color: Colors.grey),
                        ),
                        child: const Center(
                          child: Text(
                            "Follow",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
