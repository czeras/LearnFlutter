import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StringUtil {
  static String removeHideSpace(String value) {
    ///尾部不加空格会导致截断部分 暂时没有更好办法
    return Characters('$value  ').join('\u200B');
  }

  static bool equalIgnoreCase(String? left, String? right) {
    if (left == right) return true;
    if ((left ?? '').toLowerCase() == (right ?? '').toLowerCase()) {
      return true;
    }
    return false;
  }

  static String formatAudioTime(int timeS) {
    int min = timeS ~/ 60;
    int sec = timeS % 60;

    return '${'$min'.padLeft(2, '0')}:${'$sec'.padLeft(2, '0')}';
  }

  // static String formatImgUrl(String? url, {int? size, bool circle = false}) {
  //   if (url == null) return '';
  //
  //   var rUl = url;
  //
  //   // 添加图片域名
  //   if (!rUl.startsWith('http')) {
  //     rUl = '${UrlConfig.cdnDomain}$rUl';
  //   }
  //
  //   // 添加裁剪参数
  //   var uri = Uri.parse(rUl);
  //   if (size != null) {
  //     var resizeParams = 'image/resize,w_$size,m_lfit';
  //     if (circle) {
  //       resizeParams = 'image/circle,r_$size/format,png';
  //     }
  //     uri = uri.withParam('x-tos-process', resizeParams);
  //   }
  //   return uri.toString();
  // }

  static String formatCDNUrl(String? path) {
    if (path?.isNotEmpty != true) return '';
    return 'https://cdn.yay.chat/ugc-media/static/$path';
  }

  /// 将大于11000 的数字转换成 1.1W的格式
  static String getContributionStr(int contribution) {
    if (contribution < 10000) {
      return "$contribution";
    }
    return "${contribution ~/ 10000}.${contribution % 10000 ~/ 1000}W";
  }

  static String appendParamsIfAbsent(
      String uriStr, Map<String, String>? params) {
    var uri = Uri.tryParse(uriStr);
    if (uri == null) {
      return uriStr;
    }
    if (params == null) {
      return uriStr;
    }
    var queryP = {...uri.queryParameters};
    for (var p in params.keys) {
      queryP.putIfAbsent(p, () => params[p]!);
    }
    return uri.replace(queryParameters: queryP).toString();
  }

  // static Color parseColor(String colorStr, [Color defColor = Colors.white]) {
  //   String resultStr = '';
  //   try {
  //     if (colorStr.length >= 8) {
  //       resultStr = '0x${colorStr.safeSubstring(colorStr.length - 8)}';
  //     } else {
  //       resultStr = '0xff${colorStr.safeSubstring(colorStr.length - 6)}';
  //     }
  //     return Color(int.parse(resultStr));
  //   } catch (e) {
  //     return defColor;
  //   }
  // }

  // static List<Color> parseColors(dynamic colorData,
  //     [Color defColor = Colors.white]) {
  //   List<Color> colors = [];
  //   List colorStrs = [];
  //   if (colorData is String) {
  //     colorStrs = colorData.split(',');
  //   } else if (colorData is List) {
  //     colorStrs = colorData;
  //   }
  //   for (var element in colorStrs) {
  //     colors.add(parseColor(element, defColor));
  //   }
  //   return colors;
  // }
  //
  // static String toWStr(dynamic num, {int decimalPlaces = 2}) {
  //   int value = NumUtil.parseInt(num);
  //   String string = '';
  //   int per = 10000;
  //   if (value < per) {
  //     string = value.toString();
  //   } else {
  //     double temp = value / per;
  //     string = '${temp.toStringAsFixed(decimalPlaces)}w';
  //   }
  //   return string;
  // }

  // static String toKStr(dynamic num, {int decimalPlaces = 2}) {
  //   int value = NumUtil.parseInt(num);
  //   String string = '';
  //   int per = 1000;
  //   if (value < per) {
  //     string = value.toString();
  //   } else {
  //     double temp = value / per;
  //     string = '${temp.toStringAsFixed(decimalPlaces)}k';
  //   }
  //   return string;
  // }

  static bool isMobile(String phone, {String areaCode = '86'}) {
    if (areaCode == '86') {
      return phone.isNotEmpty &&
          RegExp("^(13|14|15|16|17|18|19)\\d{9}\$").hasMatch(phone);
    } else {
      return phone.isNotEmpty && phone.length >= 6 && phone.length <= 13;
    }
  }

  static int getPhoneMaxLen(String areaCode) {
    if (areaCode == '86') return 11;
    return 100;
  }

  // static String sha256ByString(String input) {
  //   final bytes = utf8.encode(input);
  //   final digest = sha256.convert(bytes);
  //   return digest.toString();
  // }

  static bool isValidEmail(String email) {
    // 正则表达式用于匹配有效的邮箱地址
    final RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegex.hasMatch(email);
  }

  static bool isEmpty(String? str) {
    return str == null || str.isEmpty;
  }
}
