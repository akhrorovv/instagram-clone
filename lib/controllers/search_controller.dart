import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/member_model.dart';
import '../services/db_service.dart';
import '../services/http_service.dart';

class SearchPageController extends GetxController {
  bool isLoading = false;
  var searchController = TextEditingController();
  List<Member> items = [];

  void apiFollowMember(Member someone) async {
    isLoading = true;
    update();

    await DBService.followMember(someone);

    someone.followed = true;
    isLoading = false;
    update();

    DBService.storePostsToMyFeed(someone);
    sendNotificationToFollowedMember(someone);
  }

  void sendNotificationToFollowedMember(Member someone) async {
    Member me = await DBService.loadMember();
    await Network.POST(
        Network.API_SEND_NOTIF, Network.paramsNotify(me, someone));
  }

  void apiUnFollowMember(Member someone) async {
    isLoading = true;
    update();

    await DBService.unfollowMember(someone);

    someone.followed = false;
    isLoading = false;
    update();

    DBService.removePostsFromMyFeed(someone);
  }

  void apiSearchMembers(String keyword) {
    isLoading = true;
    update();

    DBService.searchMembers(keyword).then((users) => {
          resSearchMembers(users),
        });
  }

  resSearchMembers(List<Member> members) {
    items = members;
    isLoading = false;
    update();
  }

  Future<void> handleRefresh() async {
    apiSearchMembers('');
  }
}
