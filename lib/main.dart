import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:trash/pages/home.dart';
import 'package:trash/pages/splash.dart';
import 'package:trash/utils/labels.dart';
import 'package:trash/utils/navigator.dart';
import 'package:trash/utils/screen/screen_tool.dart';
import 'package:trash/utils/sysytem.dart';
import 'package:trash/utils/tflite.dart';

void main() {
  runApp(MyApp());
  keepPortrait();
  // 初始化模型
  TFLite.init();
  // 初始化标签
  Labels.init();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenConfig(
      builder: () => MaterialApp(
        title: '垃圾分类',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashPage(),
        navigatorObservers: [router],
      ),
    );
  }
}
