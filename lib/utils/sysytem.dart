import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

void keepPortrait() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

Future<bool> haveCameraPermission() async => await Permission.camera.isGranted;

Future<bool> requestCameraPermission() async =>
    await Permission.camera.request() == PermissionStatus.granted;

Future<bool> openAppSetting() => openAppSettings();
