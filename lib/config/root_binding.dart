import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../controllers/splash_controller.dart';

class RootBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController(), fenix: true);
    Get.lazyPut(() => HomeController(), fenix: true);
  }
}
