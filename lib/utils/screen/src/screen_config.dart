import 'package:flutter/widgets.dart';

import 'screen_tool.dart';

class ScreenConfig extends StatelessWidget {
  ScreenConfig({
    required this.builder,
    this.designSize = ScreenTool.defaultSize,
    Key? key,
  }) : super(key: key);

  final Widget Function() builder;

  /// 设计稿尺寸，单位px
  final Size designSize;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) {
        if (constraints.maxWidth != 0) {
          ScreenTool().init(
            constraints,
            designSize: designSize,
          );
        }
        return builder();
      },
    );
  }
}
