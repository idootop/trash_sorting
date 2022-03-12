import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:trash/pages/home.dart';
import 'package:trash/utils/navigator.dart';
import 'package:trash/utils/screen/screen_tool.dart';
import 'package:trash/utils/sysytem.dart';
import 'package:trash/widgets/base.dart';
import 'package:trash/widgets/fancy_plasma.dart';

class SplashPage extends HookWidget {
  init() async {
    if (await haveCameraPermission()) {
      router.replace(HomePage());
    }
  }

  askPermission() async {
    if (await requestCameraPermission()) {
      router.replace(HomePage());
    } else {
      // 打开设置
      openAppSetting();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 初始化
    useEffect(() {
      init();
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          FancyPlasma(color: Colors.blue.withOpacity(0.4)),
          Column(
            children: [
              lExpanded(),
              Text(
                '🚮 这是什么垃圾？',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32.px,
                  fontWeight: FontWeight.bold,
                ),
              ),
              lExpanded(),
              _bottomButton(),
              SizedBox(height: 20.vw),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bottomButton() => GestureDetector(
        onTap: askPermission,
        child: Container(
          width: 276.px,
          height: 48.px,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(
              Radius.circular(100.vw),
            ),
          ),
          child: Center(
            child: Text(
              '开始使用',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.px,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
}
