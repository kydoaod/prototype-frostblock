import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class AwesomeNotificationService {
  static Future<bool> initAwesomeNotification(BuildContext context) async {
    List<NotificationChannel> channels = [
      NotificationChannel(
          channelGroupKey: 'scheduled_basic_channel_group',
          channelKey: 'scheduled_basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.High),
      NotificationChannel(
          channelGroupKey: 'scheduled_mute_channel_group',
          channelKey: 'scheduled_mute_channel',
          channelName: 'No sound notifications',
          channelDescription: 'Notification channel for no sound tests',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          playSound: false,
          importance: NotificationImportance.High)
    ];
    List<NotificationChannelGroup> channelGroups = [
      NotificationChannelGroup(
          channelGroupKey: 'scheduled_basic_channel_group',
          channelGroupName: 'Basic group'),
      NotificationChannelGroup(
          channelGroupKey: 'scheduled_mute_channel_group',
          channelGroupName: 'Mute group')
    ];

    final initValue = await AwesomeNotifications().initialize(
        // set the icon to null if you want to use the default app icon
        // 'resource://drawable/res_app_icon',
        'resource://drawable/tagg_awake_icon',
        channels,
        // Channel groups are only visual and are not required
        channelGroups: channelGroups,
        debug: true);

    await AwesomeNotifications()
        .isNotificationAllowed()
        .then((isAllowed) async {
      if (!isAllowed) {
        // This is just a basic example. For real apps, you must show some
        // friendly dialog box before call the request method.
        // This is very important to not harm the user experience
        await AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    return initValue;
  }

  setListeners() {
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod);
  }

  static Future<bool> createNotification(int id, String alarmKey, String title, String body, {bool hasPayload = false}) async {
    return await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: id,
            channelKey: 'scheduled_$alarmKey',
            title: title,
            body: body,
            actionType: ActionType.Default,
            payload: hasPayload? {
              "id": "$id",
              "channelKey": 'scheduled_$alarmKey',
              "title": "$title",
              "body": "$body",
            }: null));
  }

  Future<void> cancelNotification(int id) async{
    await AwesomeNotifications().cancel(id);
  }


  Future<bool> createScheduledNotification(
      {int id = 0,
      String? title,
      String? body,
      required DateTime scheduledDate,
      List<String>? days,
      String? alarmIdAsPayLoad,
      String? soundPath,
      bool? isVibrate = false,
      double? volume = 1,
      bool? isFromBg = false}) async {
      String? channelKey = soundPath;
      // if(channelKey!.contains("/")){
      //   channelKey = channelKey
      //               .split('/')
      //               .last
      //               .toString().replaceAll(".wav","");
      // }
      // if(isVibrate!){
      //   channelKey = "${channelKey}_vibrate";
      // }
      await AwesomeNotifications().cancel(id);
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: "scheduled_mute_channel",
          title: title,
          body: body,
          payload: {
            'id': id.toString(),
            'alarmId': alarmIdAsPayLoad,
            'soundPath': channelKey,
            'title': title,
            'body': body,
            'volume': volume.toString(),
            'isVibrate': (isVibrate).toString()
          }
        ),
        schedule: NotificationCalendar.fromDate(date: scheduledDate, allowWhileIdle: true)
      );
    
    return true;
  }

  Future<void> scheduleNotificationSpecificHour({int id = 0,
      String? title,
      String? body,
      int? hour,
      int? minute,
      int? seconds
  }) async {
      await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: id,
            channelKey: 'scheduled_basic_channel',
            title: title,
            body: body,
            wakeUpScreen: true,
          ),
          schedule: NotificationCalendar(hour: hour, minute: minute, second: seconds, millisecond: 0, repeats: true)
      );
  }
}

class NotificationController {
  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    //int notificationId = receivedNotification.id ?? 0;
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    print("Dismissed ${receivedAction.id} ${receivedAction.actionType}");
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
  }
}
