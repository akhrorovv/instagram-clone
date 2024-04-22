import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import '../models/member_model.dart';
import '../models/notification_model.dart';
import 'log_service.dart';

class Network {
  static String SERVER_FCM = "fcm.googleapis.com";

  static Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization':
    'key=AAAAfiq-E7g:APA91bFnKVoomBvqSowMwXQxQ2sFTmOaSVB8hldHsIzHfkAGglGdejeUxWODq5f3ZmeUq_ogvqyIO8PLygZGzIp5otDShVzFBzCZayZxVGKI9NteYcdT4EkKEMwohxhIQFD_ylXayR7d'
  };

  /* Http Requests */

  static Future<String?> POST(String api, Map<String, dynamic> params) async {
    var uri = Uri.https(SERVER_FCM, api);
    var response = await post(uri, headers: headers, body: jsonEncode(params));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    }
    return null;
  }

  /* Http Apis*/
  static String API_SEND_NOTIF = "/fcm/send";

  /* Http Params */
  static Map<String, dynamic> paramsNotify(Member sender, Member receiver) {
    var notification = Notification(title: "Followed", body: "${sender.fullname} has just been followed");
    var registrationIds = [receiver.device_token];
    var notificationModel = NotificationModel(notification: notification, registrationIds: registrationIds);

    LogService.i(notificationModel.toJson().toString());
    return notificationModel.toJson();
  }

  static Map<String, dynamic> paramsLikesNotify(Member sender, Member receiver) {
    var notification = Notification(title: "Liked", body: "${sender.fullname} has just been liked your post");
    var registrationIds = [receiver.device_token];
    var notificationModel = NotificationModel(notification: notification, registrationIds: registrationIds);

    LogService.i(notificationModel.toJson().toString());
    return notificationModel.toJson();
  }
}