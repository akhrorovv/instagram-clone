import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:instagram_clone/pages/home_page.dart';
import 'package:instagram_clone/pages/signin_page.dart';

import '../services/auth_service.dart';
import '../services/log_service.dart';
import '../services/notif_service.dart';
import '../services/pref_service.dart';

class SplashController extends GetxController{
  static final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  callNextPage() {
    if (AuthService.isLoggedIn()) {
      Get.to(const HomePage());
    } else {
      Get.to(const SignInPage());
    }
  }

  initNotification() async{
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      LogService.i('User granted permission');
    }else{
      LogService.e('User declined or has not accepted permission');
    }

    firebaseMessaging.getToken().then((value) async{
      String fcmToken = value.toString();
      Prefs.saveFCM(fcmToken);
      String token = await Prefs.loadFCM();
      LogService.i("FCM Token: $token");
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      String title = message.notification!.title.toString();
      String body = message.notification!.body.toString();
      LogService.i(title);
      LogService.i(body);
      LogService.i(message.data.toString());
      NotifService().showLocalNotification(title,body);
    });
  }

  initTimer() {
    Timer(const Duration(seconds: 2), () {
      callNextPage();
    });
  }
}