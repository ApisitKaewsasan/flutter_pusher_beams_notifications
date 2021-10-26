import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:pusher_beams_notifications/pusher_beams_notifications.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';


  init() async {
    await PusherBeamsNotifications.start('4bf57246-d72d-4f44-bbed-1b0cde4048af');
    await PusherBeamsNotifications.addDeviceInterest("hello");
    // await PusherBeamsNotifications.setOnMessageReceivedListener((remoteMessage){
    //   print("wefvref ${remoteMessage.toJson()}");
    // });
  }

  @override
  Widget build(BuildContext context) {
    init();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
