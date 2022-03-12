import 'screen_tool.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

extension SizeExtension on num {
  double get vw => ScreenTool().screenWidth * this * 0.01;
  double get vh => ScreenTool().screenHeight * this * 0.01;
  double get px => ScreenTool().width(this); //px2dp
}

extension ContextExtensionss on BuildContext {
  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;
}
