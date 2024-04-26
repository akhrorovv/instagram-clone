import 'package:get/get.dart';

import '../models/post_model.dart';
import '../services/db_service.dart';
import '../services/utils_service.dart';

class LikesController extends GetxController {
  bool isLoading = false;
  List<Post> items = [];

  void apiLoadLikes() {
    isLoading = true;
    update();
    DBService.loadLikes().then((value) => {
          resLoadPost(value),
        });
  }

  void resLoadPost(List<Post> posts) {
    items = posts;
    isLoading = false;
    update();
  }

  void apiPostUnLike(Post post) async {
    isLoading = true;
    update();

    await DBService.likePost(post, false);
    apiLoadLikes();
  }

  dialogRemovePost(Post post) async {
    var result = await Utils.dialogCommon("Instagram", "Do you want to delete this post?", false);

    if (result) {
      isLoading = true;
      update();
      DBService.removePost(post).then((value) => {apiLoadLikes()});
    }
  }
}
