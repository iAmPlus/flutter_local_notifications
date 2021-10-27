import 'method_channel_helper.dart';

class NotificationChannel {
  
  Future<Map> handleLocalNotification(
      {required Map<String, dynamic> data,
        required String actionIdentifier,
        required String appState}) async {
    var result = await MethodChannelHelper.channel
        .invokeMethod('handle_local_notification', {
      'data': data,
      'actionIdentifier': actionIdentifier,
      'app_state': appState,
    });
    return result;
  }
}