import 'dart:convert';

import 'package:flutter/foundation.dart';

///解码json
///
///出错时返回null
Future<dynamic> jsonDecode(String str) async {
  _jsonDecode(String str) {
    try {
      // 加载
      return json.decode(str);
    } catch (_) {
      return null;
    }
  }

  // 使用单独 isolate 解析
  return await compute(_jsonDecode, str);
}
