import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nineteenfive_admin_panel/firebase/notification/server_key.dart';

class NotificationService {
  static Future<void> sendNotification(String userId, String title, String body,
      Map<String, dynamic> externalData) async {
    final postUrl = 'https://fcm.googleapis.com/fcm/send';

    externalData.addAll({
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "1",
      "sound": 'default',
      "android_channel_id": "high_importance_channel",
    });
    final data = {
      "notification": {
        "body": body,
        "title": title,
      },
      "priority": "high",
      "data": externalData,
      "to": '/topics/$userId'
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization': 'key=$FCM_SERVER_KEY'
    };

    final response = await http.post(Uri.parse(postUrl),
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);

    if (response.statusCode == 200) {
// on success do
      print("Notification sent successfully");
    } else {
// on failure do
      print("Error" + response.body);
    }
  }
}
