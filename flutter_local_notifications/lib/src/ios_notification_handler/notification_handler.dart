
import 'package:flutter/services.dart';
import 'method_channel.dart';
import 'method_channel_helper.dart';

typedef AlarmTriggerListener = void Function(dynamic msg);

const _connectedStream = EventChannel('alarm_listener');
MethodChannelCall _channelCall = MethodChannelCall();

class NotificationHandler {
  static void onAlarmTriggerSubscription(
      AlarmTriggerListener alarmTriggerListener) {
    _connectedStream
        .receiveBroadcastStream('lister')
        .listen(alarmTriggerListener);
  }

  static void initAlarm({required Function onAlarmTrigger}) async {
    MethodChannelHelper.channel.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case 'alarmTrigger':
          onAlarmTrigger(call.arguments);
      }
    });
  }

  static Future<Map> handleLocalNotification (
      {required Map<String, dynamic> data,
        required String actionIdentifier,
        required String appState}) async {
    var result = await _channelCall.handleLocalNotification(
        data: data, actionIdentifier: actionIdentifier, appState: appState);
    return result;
  }
}