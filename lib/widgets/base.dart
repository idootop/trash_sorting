import 'package:flutter/material.dart';

Widget lContainer({
  Widget? child,
  double? width,
  double? height,
  Color? color,
  EdgeInsetsGeometry? padding,
  EdgeInsetsGeometry? margin,
  AlignmentGeometry? alignment,
  BorderRadiusGeometry? borderRadius,
  BoxBorder? border,
  BoxShadow? boxShadow,
  BoxShape? shape,
  DecorationImage? image,
  Gradient? gradient,
}) {
  child ??= Container();
  shape ??= BoxShape.rectangle;
  return Container(
    width: width,
    height: height,
    margin: margin,
    padding: padding,
    alignment: alignment,
    decoration: BoxDecoration(
      color: color,
      borderRadius: borderRadius,
      border: border,
      boxShadow: boxShadow == null
          ? null
          : [
              boxShadow,
            ],
      shape: shape,
      image: image,
      gradient: gradient,
    ),
    child: child,
  );
}

Widget lRoundContainer({
  Widget? child,
  double? width,
  double? height,
  Color? color,
  EdgeInsetsGeometry? padding,
  EdgeInsetsGeometry? margin,
  AlignmentGeometry? alignment,
  BoxBorder? border,
  BoxShadow? boxShadow,
  DecorationImage? image,
  Gradient? gradient,
  double? borderRadius,
}) {
  child ??= Container();
  return lContainer(
    width: width,
    height: height,
    margin: margin,
    padding: padding,
    alignment: alignment,
    color: color,
    border: border,
    borderRadius: BorderRadius.all(
      Radius.circular(borderRadius ?? (height ?? 48) / 2),
    ),
    boxShadow: boxShadow,
    shape: BoxShape.rectangle,
    image: image,
    gradient: gradient,
    child: child,
  );
}

TextStyle lTextStyle({
  Color? color,
  double? size,
  double? height,
  double? wordSpacing,
  double? letterSpacing,
  String? fontFamily,
  bool? light,
  bool? normal,
  bool? medium,
  bool? bold,
  bool? heavy,
  FontWeight? weight,
  TextBaseline? textBaseline,
  List<Shadow>? shadows,
  TextDecoration? decoration,
  double? decorationThickness,
  Color? backgroundColor,
}) {
  size ??= 14;
  color ??= Colors.black;
  wordSpacing ??= 0;
  letterSpacing ??= 0;
  if (height != null) height = height / size;
  light ??= false;
  medium ??= false;
  bold ??= false;
  heavy ??= false;
  if (!light && !medium && !bold && !heavy) {
    normal ??= true;
  }
  weight ??= bold
      ? FontWeight.bold
      : light
          ? FontWeight.w300
          : medium
              ? FontWeight.w500
              : heavy
                  ? FontWeight.w800
                  : FontWeight.normal;
  return height == null
      ? TextStyle(
          color: color,
          fontSize: size,
          textBaseline: textBaseline,
          fontWeight: weight,
          wordSpacing: wordSpacing,
          letterSpacing: letterSpacing,
          fontFamily: fontFamily,
          shadows: shadows,
          decoration: decoration ?? TextDecoration.none,
          decorationThickness: decorationThickness,
          backgroundColor: backgroundColor,
        )
      : TextStyle(
          color: color,
          height: height,
          fontSize: size,
          textBaseline: textBaseline,
          fontWeight: weight,
          wordSpacing: wordSpacing,
          letterSpacing: letterSpacing,
          fontFamily: fontFamily,
          shadows: shadows,
          decoration: decoration ?? TextDecoration.none,
          decorationThickness: decorationThickness,
          backgroundColor: backgroundColor,
        );
}

Widget lText(
  String? text, {
  Color? color,
  double? size,
  double? height,
  int? maxLines,
  bool? light,
  bool? normal,
  bool? medium,
  bool? bold,
  bool? heavy,
  double? wordSpacing,
  double? letterSpacing,
  String? fontFamily,
  TextOverflow? overflow,
  TextAlign? textAlign,
  TextWidthBasis? textWidthBasis,
  TextBaseline? textBaseline,
  TextStyle? style,
  List<Shadow>? shadows,
  TextDecoration? decoration,
  double? decorationThickness,
  Color? backgroundColor,
}) {
  size ??= 14;
  color ??= Colors.black;
  light ??= false;
  medium ??= false;
  bold ??= false;
  heavy ??= false;
  if (!light && !medium && !bold && !heavy) {
    normal ??= true;
  }
  final weight = bold
      ? FontWeight.bold
      : light
          ? FontWeight.w300
          : medium
              ? FontWeight.w500
              : heavy
                  ? FontWeight.w800
                  : FontWeight.normal;
  return Text(
    '$text',
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: overflow,
    textWidthBasis: textWidthBasis,
    textScaleFactor: 1.0, //不跟随系统字体大小设置
    style: style ??
        lTextStyle(
          color: color,
          height: height,
          size: size,
          weight: weight,
          textBaseline: textBaseline,
          wordSpacing: wordSpacing,
          letterSpacing: letterSpacing,
          fontFamily: fontFamily,
          shadows: shadows,
          decoration: decoration,
          decorationThickness: decorationThickness,
          backgroundColor: backgroundColor,
        ),
  );
}

Widget lTapableText(
  String text, {
  TextStyle? style,
  Function? onTap,
  EdgeInsetsGeometry padding = EdgeInsets.zero,
}) =>
    GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onTap?.call(),
      child: Padding(
        padding: padding,
        child: lText(text, style: style),
      ),
    );

Widget lHeight(double height) {
  return SizedBox(height: height);
}

Widget lWidth(double width) {
  return SizedBox(width: width);
}

Widget lBlank() {
  return Container();
}

Widget lExpanded({int? flex, Widget? child}) {
  flex ??= 1;
  child ??= Container();
  return Expanded(flex: flex, child: Center(child: child));
}
