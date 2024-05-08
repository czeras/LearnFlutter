// The MIT License (MIT)
//
// Copyright (c) 2020 nslogx
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.

import 'package:flutter/material.dart';

import 'animations/animation.dart';
import 'animations/offset_animation.dart';
import 'animations/opacity_animation.dart';
import 'animations/scale_animation.dart';
import 'global_notice.dart';

class GlobalNoticeTheme {
  /// color of indicator
  static Color get indicatorColor =>
      GlobalNotice.instance.loadingStyle == GlobalNoticeStyle.custom
          ? GlobalNotice.instance.indicatorColor!
          : GlobalNotice.instance.loadingStyle == GlobalNoticeStyle.dark
              ? Colors.white
              : Colors.black;

  /// progress color of loading
  static Color get progressColor =>
      GlobalNotice.instance.loadingStyle == GlobalNoticeStyle.custom
          ? GlobalNotice.instance.progressColor!
          : GlobalNotice.instance.loadingStyle == GlobalNoticeStyle.dark
              ? Colors.white
              : Colors.black;

  /// background color of loading
  static Color get backgroundColor =>
      GlobalNotice.instance.loadingStyle == GlobalNoticeStyle.custom
          ? GlobalNotice.instance.backgroundColor!
          : GlobalNotice.instance.loadingStyle == GlobalNoticeStyle.dark
              ? Colors.black.withOpacity(0.9)
              : Colors.white;

  /// boxShadow color of loading
  static List<BoxShadow>? get boxShadow =>
      GlobalNotice.instance.loadingStyle == GlobalNoticeStyle.custom
          ? GlobalNotice.instance.boxShadow ?? [BoxShadow()]
          : null;

  /// font color of status
  static Color get textColor =>
      GlobalNotice.instance.loadingStyle == GlobalNoticeStyle.custom
          ? GlobalNotice.instance.textColor!
          : GlobalNotice.instance.loadingStyle == GlobalNoticeStyle.dark
              ? Colors.white
              : Colors.black;

  /// mask color of loading
  static Color maskColor(GlobalNoticeMaskType? maskType) {
    maskType ??= GlobalNotice.instance.maskType;
    return maskType == GlobalNoticeMaskType.custom
        ? GlobalNotice.instance.maskColor!
        : maskType == GlobalNoticeMaskType.black
            ? Colors.black.withOpacity(0.5)
            : Colors.transparent;
  }

  /// loading animation
  static GlobalNoticeAnimation get loadingAnimation {
    GlobalNoticeAnimation _animation;
    switch (GlobalNotice.instance.animationStyle) {
      case GlobalNoticeAnimationStyle.custom:
        _animation = GlobalNotice.instance.customAnimation!;
        break;
      case GlobalNoticeAnimationStyle.offset:
        _animation = OffsetAnimation();
        break;
      case GlobalNoticeAnimationStyle.scale:
        _animation = ScaleAnimation();
        break;
      default:
        _animation = OpacityAnimation();
        break;
    }
    return _animation;
  }

  /// font size of status
  static double get fontSize => GlobalNotice.instance.fontSize;

  /// size of indicator
  static double get indicatorSize => GlobalNotice.instance.indicatorSize;

  /// width of progress indicator
  static double get progressWidth => GlobalNotice.instance.progressWidth;

  /// width of indicator
  static double get lineWidth => GlobalNotice.instance.lineWidth;

  /// loading indicator type
  static GlobalNoticeIndicatorType get indicatorType =>
      GlobalNotice.instance.indicatorType;

  /// toast position
  static GlobalNoticeToastPosition get toastPosition =>
      GlobalNotice.instance.toastPosition;

  /// toast position
  static AlignmentGeometry alignment(GlobalNoticeToastPosition? position) =>
      position == GlobalNoticeToastPosition.bottom
          ? AlignmentDirectional.bottomCenter
          : (position == GlobalNoticeToastPosition.top
              ? AlignmentDirectional.topCenter
              : AlignmentDirectional.center);

  /// display duration
  static Duration get displayDuration => GlobalNotice.instance.displayDuration;

  /// animation duration
  static Duration get animationDuration =>
      GlobalNotice.instance.animationDuration;

  /// contentPadding of loading
  static EdgeInsets get contentPadding => GlobalNotice.instance.contentPadding;

  /// padding of status
  static EdgeInsets get textPadding => GlobalNotice.instance.textPadding;

  /// textAlign of status
  static TextAlign get textAlign => GlobalNotice.instance.textAlign;

  /// textStyle of status
  static TextStyle? get textStyle => GlobalNotice.instance.textStyle;

  /// radius of loading
  static double get radius => GlobalNotice.instance.radius;

  /// should dismiss on user tap
  static bool? get dismissOnTap => GlobalNotice.instance.dismissOnTap;

  static bool ignoring(GlobalNoticeMaskType? maskType) {
    maskType ??= GlobalNotice.instance.maskType;
    return GlobalNotice.instance.userInteractions ??
        (maskType == GlobalNoticeMaskType.none ? true : false);
  }
}
