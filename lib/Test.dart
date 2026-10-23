import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Test extends StatefulWidget {
  const Test({super.key});
  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  getToken() async {
    String? mytoken = await FirebaseMessaging.instance.getToken();
    print("==================================================");
    print("Toke = $mytoken");
  }

  myrequestpermission() async {
    // تطلب من المستخدم إذن إرسال الإشعارات، وخيار provisional يسمح للمستخدم
    // بتحديد نوع الإشعارات التي يريد استلامها (تلقائية على Android).
    final notificationSettings = await FirebaseMessaging.instance
        .requestPermission(provisional: true);

    // على أجهزة Apple (iOS) يجب التأكد من توفّر رمز APNS قبل استدعاء أي
    // وظيفة من إضافة Firebase Messaging.
    final apnsToken = await FirebaseMessaging.instance.getAPNSToken();

    // التحقق من أن رمز APNS غير فارغ، أي أن الجهاز مسجّل بنجاح لدى Apple
    // وبالإمكان الآن إرسال الإشعارات عبر FCM.
    if (apnsToken != null) {
      // رمز APNS متاح، يمكن الآن استدعاء وظائف إضافة Firebase Messaging.
    }
  }

  @override
  void initState() {
    super.initState();
    myrequestpermission();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification"),
        centerTitle: false,
        backgroundColor: Colors.blue,
        titleTextStyle: TextStyle(color: Colors.white),
      ),
      body: ListView(
        children: [
          MaterialButton(
            onPressed: () async{
              await sendMessage("Hi", "How Are You");
            },
            child: Text("Send Message"),
          ),
        ],
      ),
    );
  }
}

sendMessage(title, message) async {
  var headersList = {
    'Accept': '*/*',
    'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
    'Content-Type': 'application/json',
    'Authorization':
        'Bearer ya29.a0AX07CmtgpL9LFUbz6T58TQA8WV2lFn0bSMzCMPyCxWQfkgp4zjDsW2BcZ8l81klnQh8lCrLtPmiQhDc2yRnZRMrogKvBIXQXa34eHTeHpDUbA-gT_A3NbBkL0ANcasbe5s-RRZIZyqtIVmzvRcmS3MWad1nVdB4NC2zs1RJpjHeCDtPFAlk-51IPZukBtkGQaTEdhskaCgYKARcSARESFQHGX2MiMyX6ENvq7cmybvDdZVR65Q0206',
  };
  var url = Uri.parse(
    'https://fcm.googleapis.com/v1/projects/flutter-24740/messages:send',
  );

  var body = {
    "message": {
      "token":
          "e2Xz1sBbRcW6qNWyLNtD4e:APA91bFV2nOwNEhrXbfgZwxhAqabHCEBhtP2FcTv7GiNe9vO9H-ryg6WhnWhLxN00CcTZ8TLu8g8ZslBHg9b2nPX-NQY-EZmx6_3yFnvMtDPTwPC0RwtHS0",
      "notification": {"title": title, "body": message},
    },
  };

  var req = http.Request('POST', url);
  req.headers.addAll(headersList);
  req.body = json.encode(body);

  var res = await req.send();
  final resBody = await res.stream.bytesToString();

  if (res.statusCode >= 200 && res.statusCode < 300) {
    print(resBody);
  } else {
    print(res.reasonPhrase);
  }
}
