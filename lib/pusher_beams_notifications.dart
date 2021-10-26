
import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

import 'model/remote_message_model.dart';

class PusherBeamsNotifications {
  static const MethodChannel _channel = MethodChannel('pusher_beams_notifications');
//  static const EventChannel _eventChannel =  EventChannel('pusher_beams_message_remote');


  static final BehaviorSubject _eventCallbacks = BehaviorSubject<RemoteMessage>();

  static Future<void> start(String instanceId) async {
    // _eventChannel.receiveBroadcastStream(instanceId).listen((event) {
    //   _eventCallbacks.add(RemoteMessage.fromJson(jsonDecode(event)));
    // });

    await _channel.invokeMethod('start', instanceId);
  }

  static Future<void> addDeviceInterest(String interest) async {
    await _channel.invokeMethod('addDeviceInterest', interest);
  }

  static Future<void> removeDeviceInterest(String interest) async {
    await _channel.invokeMethod('removeDeviceInterest', interest);
  }

  static Future<dynamic> getDeviceInterests() async {
    final List<String>? interests =
    await _channel.invokeListMethod('getDeviceInterests');

    return Future.value(interests);
  }

  static Future<void> setDeviceInterests(List<String> interests) async {
    await _channel.invokeMethod('setDeviceInterests', interests);
  }

  static Future<void> clearDeviceInterests() async {
    await _channel.invokeMethod('clearDeviceInterests');
  }

  static Future<bool> setUserId(String userId, tokenProvider) {
    throw UnimplementedError('This method is still unimplemented');
  }

  static Future<void> clearAllState() async {
    await _channel.invokeMethod('clearAllState');
  }

  static Future<void> stop() async {
    await _channel.invokeMethod('stop');
  }

  static Future setOnMessageReceivedListener(Function(RemoteMessage) remoteMessage) async {
    _eventCallbacks.listen((value) {
      remoteMessage(value);
    });
    await _channel.invokeMethod('setOnMessageReceivedListener');
  }
}
