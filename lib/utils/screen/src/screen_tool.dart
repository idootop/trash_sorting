import 'dart:ui' as ui;
import 'dart:math';
import 'package:flutter/material.dart';

class ScreenTool {
  factory ScreenTool() => _instance;
  ScreenTool._();
  static final ScreenTool _instance = ScreenTool._();

  static const Size defaultSize = Size(375, 812); 

  /// 设计稿尺寸，单位px
  Size uiSize = defaultSize;

  double _pixelRatio = 1;
  double _screenWidth = 0;
  double _screenHeight = 0;
  double _statusBarHeight = 0;
  double _bottomBarHeight = 0;

  void init(
    BoxConstraints constraints, {
    Size? designSize,
  }) {
    uiSize = designSize??defaultSize;
    _screenWidth = constraints.maxWidth; //此处是当前组件的最大宽度
    _screenHeight = constraints.maxHeight; //此处是当前组件的最大高度度

    var window = WidgetsBinding.instance?.window ?? ui.window;

    _pixelRatio = window.devicePixelRatio;
    _statusBarHeight = window.padding.top;
    _bottomBarHeight = window.padding.bottom;
  }

  /// 根据UI设计的设备宽度适配
  double width(num width) => width * scaleWidth;

  /// 设备的像素密度
  double get pixelRatio => _pixelRatio;

  /// 当前设备宽度 dp
  double get screenWidth => _screenWidth;

  /// 当前设备高度 dp
  double get screenHeight => _screenHeight;

  /// 状态栏高度 dp 刘海屏会更高
  double get statusBarHeight => _statusBarHeight / _pixelRatio;

  /// 底部安全区距离 dp
  double get bottomBarHeight => _bottomBarHeight / _pixelRatio;

  /// 实际宽度与设计宽度的比例
  double get scaleWidth => _screenWidth / uiSize.width;
}
