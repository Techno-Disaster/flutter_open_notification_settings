import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

import 'notification_details.dart';

class NotificationSetting {
  static const _channel = MethodChannel('open_noti_settings');

  static Future<void> open() async {
    final String version = await _channel.invokeMethod('open');
    return version;
  }

  /// Configures channel on android. This is no-op on ios.
  static Future<void> configureChannel(
    NotificationDetails notificationDetails,
  ) async {
    if (Platform.isIOS) {
      return;
    }

    var serializedPlatformSpecifics =
        _retrievePlatformSpecificNotificationDetails(notificationDetails);
    await _channel.invokeMethod('configureChannel', <String, dynamic>{
      'platformSpecifics': serializedPlatformSpecifics,
    });
  }

  static Map<String, dynamic> _retrievePlatformSpecificNotificationDetails(
      NotificationDetails notificationDetails) {
    Map<String, dynamic> serializedPlatformSpecifics;
    if (Platform.isAndroid) {
      serializedPlatformSpecifics = notificationDetails?.android?.toMap();
    } else if (Platform.isIOS) {
      serializedPlatformSpecifics = notificationDetails?.iOS?.toMap();
    }
    return serializedPlatformSpecifics;
  }
}