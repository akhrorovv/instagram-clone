import 'package:get/get.dart';
import 'package:instagram_clone/controllers/feed_controller.dart';
import 'package:instagram_clone/controllers/likes_controller.dart';
import 'package:instagram_clone/controllers/profile_controller.dart';
import 'package:instagram_clone/controllers/search_controller.dart';
import 'package:instagram_clone/controllers/signin_controller.dart';
import 'package:instagram_clone/controllers/signup_controller.dart';
import 'package:instagram_clone/controllers/splash_controller.dart';
import 'package:instagram_clone/controllers/upload_controller.dart';
import '../controllers/home_controller.dart';

class RootBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController(), fenix: true);
    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => FeedController(), fenix: true);
    Get.lazyPut(() => SearchPageController(), fenix: true);
    Get.lazyPut(() => UploadController(), fenix: true);
    Get.lazyPut(() => LikesController(), fenix: true);
    Get.lazyPut(() => ProfileController(), fenix: true);
    Get.lazyPut(() => SignInController(), fenix: true);
    Get.lazyPut(() => SignUpController(), fenix: true);
  }
}