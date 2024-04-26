import 'package:get/get.dart';
import '../models/member_model.dart';
import '../models/post_model.dart';
import '../services/db_service.dart';
import '../services/http_service.dart';
import '../services/utils_service.dart';

class FeedController extends GetxController {
  bool isLoading = false;
  List<Post> items = [];

  void apiPostLike(Post post) async {
    isLoading = true;
    update();

    await DBService.likePost(post, true);

    isLoading = false;
    post.liked = true;
    update();

    var owner = await DBService.getOwner(post.uid);
    sendNotificationToLikedMember(owner);
  }

  void sendNotificationToLikedMember(Member someone) async {
    Member me = await DBService.loadMember();
    await Network.POST(
        Network.API_SEND_NOTIF, Network.paramsLikesNotify(me, someone));
  }

  void apiPostUnLike(Post post) async {
    isLoading = true;
    update();

    await DBService.likePost(post, false);

    isLoading = false;
    post.liked = false;
    update();
  }

  apiLoadFeeds() {
    isLoading = true;
    update();
    DBService.loadFeeds().then((value) => {resLoadFeeds(value)});
  }

  resLoadFeeds(List<Post> posts) {
    items = posts;
    isLoading = false;
    update();
  }

  dialogRemovePost(Post post) async {
    var result = await Utils.dialogCommon(
        "Instagram", "Do you want to delete this post?", false);

    if (result) {
      isLoading = true;
      update();
      DBService.removePost(post).then((value) => {apiLoadFeeds()});
    }
  }

  Future<void> handleRefresh() async {
    apiLoadFeeds();
  }
}
