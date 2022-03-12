import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:trash/utils/screen/screen_tool.dart';
import 'package:trash/widgets/base.dart';

Widget lTextField(
  String hint, {
  double? width,
  double? height,
  TextInputType? keyboardType,
  TextEditingController? controller,
  void Function(String)? onSubmitted,
  void Function(String)? onChanged,
  List<TextInputFormatter>? inputFormatters,
  int? maxLength,
  TextInputAction? textInputAction,
  FocusNode? focusNode,
  void Function()? onTap,
  TextAlign? textAlign,
  bool? isDense = true,
}) {
  height ??= 48.px;
  keyboardType ??= TextInputType.text;
  return lRoundContainer(
    width: width,
    height: height,
    alignment: Alignment.center,
    padding: EdgeInsets.symmetric(horizontal: 18.px),
    child: LTextField(
      focusNode: focusNode,
      controller: controller,
      keyboardType: keyboardType,
      hintText: hint,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textInputAction: textInputAction,
      inputStyle: lTextStyle(
        size: 14.px,
        height: 17.px,
        light: true,
        color: Colors.black,
      ),
      hintStyle: lTextStyle(
        size: 14.px,
        height: 17.px,
        light: true,
        color: Colors.grey,
      ),
      cursorWidth: 1.px,
      cursorHeight: 19.px,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      onTap: onTap,
      maxLines: 1,
      textAlign: textAlign,
      isDense: isDense,
    ),
  );
}

class LTextField extends StatefulWidget {
  final String? hintText;
  final String? initValue;
  final bool? autofocus;
  final TextAlign? textAlign;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;
  final int? maxLines;
  final bool? canEnter; //回车
  final bool? secret; //密码
  final TextEditingController? controller;
  final int? minLines;

  //提示文字样式
  final TextStyle? inputStyle;
  //输入文字样式
  final TextStyle? hintStyle;
  //光标样式
  final Color? cursorColor;
  final double? cursorRadius;
  final double? cursorWidth;
  final double? cursorHeight;
  final bool? showCursor;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final FocusNode? focusNode;
  final void Function()? onTap;

  final bool? isDense;

  LTextField({
    this.canEnter,
    this.maxLines,
    this.secret,
    this.controller,
    this.hintText,
    this.textAlign,
    this.autofocus,
    this.initValue,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.textInputAction,
    //提示文字样式
    this.hintStyle,
    //输入文字样式
    this.inputStyle,
    //光标样式
    this.cursorColor,
    this.cursorRadius,
    this.cursorWidth,
    this.cursorHeight,
    this.showCursor,
    this.inputFormatters,
    this.maxLength,
    this.focusNode,
    this.onTap,
    this.isDense,
    this.minLines,
  });

  @override
  _LTextFieldState createState() => _LTextFieldState(
        canEnter: canEnter,
        maxLines: maxLines,
        secret: secret,
        controller: controller,
        hintText: hintText,
        textAlign: textAlign,
        autofocus: autofocus,
        initValue: initValue,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        //提示文字样式
        hintStyle: hintStyle,
        //输入文字样式
        inputStyle: inputStyle,
        //光标样式
        cursorColor: cursorColor,
        cursorRadius: cursorRadius,
        cursorWidth: cursorWidth,
        cursorHeight: cursorHeight,
        showCursor: showCursor,
        maxLength: maxLength,
        focusNode: focusNode,
        onTap: onTap,
        inputFormatters: inputFormatters,
        isDense: isDense,
        minLines: minLines,
      );
}

class _LTextFieldState extends State<LTextField> {
  String? hintText;
  String? initValue;
  bool? autofocus;
  TextAlign? textAlign;
  TextInputType? keyboardType;
  TextInputAction? textInputAction;
  void Function(String)? onSubmitted;
  void Function(String)? onChanged;
  int? maxLines;
  bool? canEnter; //回车
  bool? secret; //密码
  TextEditingController? controller;
  bool? isDense;
  int? minLines;

  //提示文字样式
  TextStyle? inputStyle;
  //输入文字样式
  TextStyle? hintStyle;
  //光标样式
  Color? cursorColor;
  double? cursorRadius;
  double? cursorWidth;
  double? cursorHeight;
  bool? showCursor;
  List<TextInputFormatter>? inputFormatters;
  int? maxLength;
  FocusNode? focusNode;
  void Function()? onTap;

  _LTextFieldState({
    this.canEnter,
    this.maxLines,
    this.secret,
    this.controller,
    this.hintText,
    this.textAlign,
    this.autofocus,
    this.initValue,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.textInputAction,
    //提示文字样式
    this.hintStyle,
    //输入文字样式
    this.inputStyle,
    //光标样式
    this.cursorColor,
    this.cursorRadius,
    this.cursorWidth,
    this.cursorHeight,
    this.showCursor,
    this.inputFormatters,
    this.maxLength,
    this.focusNode,
    this.onTap,
    this.isDense,
    this.minLines,
  }) {
    hintText ??= '请输入...';
    textAlign ??= TextAlign.left;
    autofocus ??= false;
    keyboardType ??= TextInputType.text;
    textInputAction ??= TextInputAction.done;
    secret ??= false;
    //文字样式
    if (hintStyle == null && inputStyle == null) {
      hintStyle = lTextStyle();
      inputStyle = lTextStyle();
    } else if (hintStyle == null && inputStyle != null) {
      hintStyle = inputStyle;
    } else if (hintStyle != null && inputStyle == null) {
      inputStyle = hintStyle;
    }
    //光标样式
    cursorColor ??= Colors.black;
    cursorRadius ??= 0;
    cursorWidth ??= 2;
    cursorHeight ??= inputStyle!.fontSize;
    showCursor ??= true;
    //处理回车
    canEnter ??= false;
    if (canEnter!) {
      keyboardType = TextInputType.multiline;
    }
    isDense ??= Platform.isAndroid;
    minLines ??= 1;
  }

  bool innerController = true;

  @override
  void initState() {
    super.initState();
    if (controller == null) {
      controller = TextEditingController();
      innerController = true;
    } else {
      innerController = false;
    }
    if (initValue?.isNotEmpty ?? false) {
      controller!.text = initValue!;
    }
  }

  @override
  void dispose() {
    if (innerController) {
      controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      controller: controller,
      textAlign: textAlign!,
      textAlignVertical: TextAlignVertical.center,
      autofocus: autofocus!,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      keyboardType: keyboardType,
      obscureText: secret!,
      textInputAction: textInputAction,
      style: inputStyle,
      decoration: InputDecoration(
        isDense: isDense,
        border: InputBorder.none,
        hintText: hintText,
        hintStyle: hintStyle,
      ),
      //光标颜色
      cursorColor: cursorColor,
      cursorRadius: Radius.circular(cursorRadius!),
      cursorWidth: cursorWidth!,
      cursorHeight: cursorHeight,
      showCursor: showCursor,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      onTap: onTap,
      minLines: minLines,
      maxLines: maxLines,
    );
  }
}
