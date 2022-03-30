
import 'dart:io';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:instagram/services/pref_service.dart';
import 'package:intl/intl.dart';

class Utils {
  // FireSnackBar
  static fireSnackBar(String msg, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.grey.shade400.withOpacity(0.975),
        content: Text(
          msg,
          style: TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        duration: const Duration(milliseconds: 2500),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
        elevation: 10,
        behavior: SnackBarBehavior.floating,
        shape: const StadiumBorder(),
      ),
    );
  }

  static String getMonthDayYear(String date) {
    final DateTime now = DateTime.parse(date);
    final String formatted = DateFormat.yMMMMd().format(now);
    return formatted;
  }

  static Future<bool> dialogCommon(
      BuildContext context, String title, String messege, bool isSingle) async {
    return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Text(messege),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cencel")),
                TextButton(onPressed: () {}, child: Text("Confirm")),
              ],
            ));
  }
///Device Info
  static Future<Map<String, String>> deviceParams() async {
    Map<String, String> params = {};

    var deviceInfo = DeviceInfoPlugin();
    String fmc_token = (await Prefs.load(StorageKeys.TOKEN))!;
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      params.addAll({
        'device_id': iosDeviceInfo.identifierForVendor!,
        'device_type': "I",
        'device_token': fmc_token,
      });
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      params.addAll({
        'device_id': androidDeviceInfo.androidId!,
        'device_type': "A",
        'device_token': fmc_token,
      });
    }
    return params;
  }

  static Future<void> showLocalNotification(RemoteMessage message, BuildContext context) async {
    String title = message.notification!.title!;
    String body = message.notification!.body!;

    var android = const AndroidNotificationDetails('channelId', 'channelName', channelDescription: 'channelDescription');
    var iOS = const IOSNotificationDetails();
    var platform = NotificationDetails(android: android, iOS: iOS);

    int id = Random().nextInt((pow(2, 31) - 1).toInt());
    await FlutterLocalNotificationsPlugin().show(id, title, body, platform);
  }


}
