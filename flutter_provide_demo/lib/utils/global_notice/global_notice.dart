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

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
// import 'package:lib_baseview/src/global_notice/widgets/progress.dart';
// import 'package:lib_runtime/lib_runtime.dart';
// import 'package:m_main/m_main.dart';

import './animations/animation.dart';
import './theme.dart';
import 'widgets/container.dart';
import 'widgets/indicator.dart';
import 'widgets/loading.dart';
import 'widgets/overlay_entry.dart';
import 'widgets/progress.dart';

/// loading style
enum GlobalNoticeStyle {
  light,
  dark,
  custom,
}

/// toast position
enum GlobalNoticeToastPosition {
  top,
  center,
  bottom,
}

/// loading animation
enum GlobalNoticeAnimationStyle {
  opacity,
  offset,
  scale,
  custom,
}

/// loading mask type
/// [none] default mask type, allow user interactions while loading is displayed
/// [clear] don't allow user interactions while loading is displayed
/// [black] don't allow user interactions while loading is displayed
/// [custom] while mask type is custom, maskColor should not be null
enum GlobalNoticeMaskType {
  none,
  clear,
  black,
  custom,
}

/// loading indicator type. see [https://github.com/jogboms/flutter_spinkit#-showcase]
enum GlobalNoticeIndicatorType {
  fadingCircle,
  circle,
  threeBounce,
  chasingDots,
  wave,
  wanderingCubes,
  rotatingPlain,
  doubleBounce,
  fadingFour,
  fadingCube,
  pulse,
  cubeGrid,
  rotatingCircle,
  foldingCube,
  pumpingHeart,
  dualRing,
  hourGlass,
  pouringHourGlass,
  fadingGrid,
  ring,
  ripple,
  spinningCircle,
  squareCircle,
}

/// loading status
enum GlobalNoticeStatus {
  show,
  dismiss,
}

typedef GlobalNoticeStatusCallback = void Function(GlobalNoticeStatus status);

class GlobalNotice {
  /// loading style, default [GlobalNoticeStyle.dark].
  late GlobalNoticeStyle loadingStyle;

  /// loading indicator type, default [GlobalNoticeIndicatorType.fadingCircle].
  late GlobalNoticeIndicatorType indicatorType;

  /// loading mask type, default [GlobalNoticeMaskType.none].
  late GlobalNoticeMaskType maskType;

  /// toast position, default [GlobalNoticeToastPosition.center].
  late GlobalNoticeToastPosition toastPosition;

  /// loading animationStyle, default [GlobalNoticeAnimationStyle.opacity].
  late GlobalNoticeAnimationStyle animationStyle;

  /// textAlign of status, default [TextAlign.center].
  late TextAlign textAlign;

  /// content padding of loading.
  late EdgeInsets contentPadding;

  /// padding of [status].
  late EdgeInsets textPadding;

  /// size of indicator, default 40.0.
  late double indicatorSize;

  /// radius of loading, default 5.0.
  late double radius;

  /// fontSize of loading, default 15.0.
  late double fontSize;

  /// width of progress indicator, default 2.0.
  late double progressWidth;

  /// width of indicator, default 4.0, only used for [GlobalNoticeIndicatorType.ring, GlobalNoticeIndicatorType.dualRing].
  late double lineWidth;

  /// display duration of [showSuccess] [showError] [showInfo] [showToast], default 2000ms.
  late Duration displayDuration;

  /// animation duration of indicator, default 200ms.
  late Duration animationDuration;

  /// loading custom animation, default null.
  GlobalNoticeAnimation? customAnimation;

  /// textStyle of status, default null.
  TextStyle? textStyle;

  /// color of loading status, only used for [GlobalNoticeStyle.custom].
  Color? textColor;

  /// color of loading indicator, only used for [GlobalNoticeStyle.custom].
  Color? indicatorColor;

  /// progress color of loading, only used for [GlobalNoticeStyle.custom].
  Color? progressColor;

  /// background color of loading, only used for [GlobalNoticeStyle.custom].
  Color? backgroundColor;

  /// boxShadow of loading, only used for [GlobalNoticeStyle.custom].
  List<BoxShadow>? boxShadow;

  /// mask color of loading, only used for [GlobalNoticeMaskType.custom].
  Color? maskColor;

  /// should allow user interactions while loading is displayed.
  bool? userInteractions;

  /// should dismiss on user tap.
  bool? dismissOnTap;

  /// indicator widget of loading
  Widget? indicatorWidget;

  /// success widget of loading
  Widget? successWidget;

  /// error widget of loading
  Widget? errorWidget;

  /// info widget of loading
  Widget? infoWidget;

  Widget? _w;

  GlobalNoticeOverlayEntry? overlayEntry;
  GlobalKey<GlobalNoticeContainerState>? _key;
  GlobalKey<GlobalNoticeProgressState>? _progressKey;
  Timer? _timer;

  Widget? get w => _w;
  GlobalKey<GlobalNoticeContainerState>? get key => _key;
  GlobalKey<GlobalNoticeProgressState>? get progressKey => _progressKey;

  final List<GlobalNoticeStatusCallback> _statusCallbacks =
      <GlobalNoticeStatusCallback>[];

  factory GlobalNotice() => _instance;
  static final GlobalNotice _instance = GlobalNotice._internal();

  GlobalNotice._internal() {
    /// set deafult value
    loadingStyle = GlobalNoticeStyle.dark;
    indicatorType = GlobalNoticeIndicatorType.fadingCircle;
    maskType = GlobalNoticeMaskType.none;
    toastPosition = GlobalNoticeToastPosition.center;
    animationStyle = GlobalNoticeAnimationStyle.opacity;
    textAlign = TextAlign.center;
    indicatorSize = 40.0;
    radius = 5.0;
    fontSize = 15.0;
    progressWidth = 2.0;
    lineWidth = 4.0;
    displayDuration = const Duration(milliseconds: 2000);
    animationDuration = const Duration(milliseconds: 200);
    textPadding = const EdgeInsets.only(bottom: 10.0);
    contentPadding = const EdgeInsets.symmetric(
      vertical: 15.0,
      horizontal: 20.0,
    );
  }

  static GlobalNotice get instance => _instance;
  static bool get isShow => _instance.w != null;

  /// init GlobalNotice
  static TransitionBuilder init({
    TransitionBuilder? builder,
  }) {
    return (BuildContext context, Widget? child) {
      if (builder != null) {
        return builder(context, FlutterGlobalNotice(child: child));
      } else {
        return FlutterGlobalNotice(child: child);
      }
    };
  }

  /// show loading with [status] [indicator] [maskType]
  static Future<void> show({
    String? status,
    Widget? indicator,
    GlobalNoticeMaskType? maskType,
    bool? dismissOnTap,
  }) {
    Widget w = indicator ?? (_instance.indicatorWidget ?? LoadingIndicator());
    return _instance._show(
      status: status,
      maskType: maskType,
      dismissOnTap: dismissOnTap,
      w: w,
    );
  }

  /// show progress with [value] [status] [maskType], value should be 0.0 ~ 1.0.
  static Future<void> showProgress(
    double value, {
    String? status,
    GlobalNoticeMaskType? maskType,
  }) async {
    assert(
      value >= 0.0 && value <= 1.0,
      'progress value should be 0.0 ~ 1.0',
    );

    if (_instance.loadingStyle == GlobalNoticeStyle.custom) {
      assert(
        _instance.progressColor != null,
        'while loading style is custom, progressColor should not be null',
      );
    }

    if (_instance.w == null || _instance.progressKey == null) {
      if (_instance.key != null) await dismiss(animation: false);
      GlobalKey<GlobalNoticeProgressState> _progressKey =
          GlobalKey<GlobalNoticeProgressState>();
      Widget w = GlobalNoticeProgress(
        key: _progressKey,
        value: value,
      );
      _instance._show(
        status: status,
        maskType: maskType,
        dismissOnTap: false,
        w: w,
      );
      _instance._progressKey = _progressKey;
    }
    // update progress
    _instance.progressKey?.currentState?.updateProgress(min(1.0, value));
    // update status
    if (status != null) _instance.key?.currentState?.updateStatus(status);
  }

  /// showSuccess [status] [duration] [maskType]
  static Future<void> showSuccess(
    String status, {
    Duration? duration,
    GlobalNoticeMaskType? maskType,
    bool? dismissOnTap,
  }) {
    Widget w = _instance.successWidget ??
        Icon(
          Icons.done,
          color: GlobalNoticeTheme.indicatorColor,
          size: GlobalNoticeTheme.indicatorSize,
        );
    return _instance._show(
      status: status,
      duration: duration ?? GlobalNoticeTheme.displayDuration,
      maskType: maskType,
      dismissOnTap: dismissOnTap,
      w: w,
    );
  }

  /// showError [status] [duration] [maskType]
  static Future<void> showError(
    String status, {
    Duration? duration,
    GlobalNoticeMaskType? maskType,
    bool? dismissOnTap,
  }) {
    Widget w = _instance.errorWidget ??
        Icon(
          Icons.clear,
          color: GlobalNoticeTheme.indicatorColor,
          size: GlobalNoticeTheme.indicatorSize,
        );
    return _instance._show(
      status: status,
      duration: duration ?? GlobalNoticeTheme.displayDuration,
      maskType: maskType,
      dismissOnTap: dismissOnTap,
      w: w,
    );
  }

  /// showInfo [status] [duration] [maskType]
  static Future<void> showInfo(
    String status, {
    Duration? duration,
    GlobalNoticeMaskType? maskType,
    bool? dismissOnTap,
  }) {
    Widget w = _instance.infoWidget ??
        Icon(
          Icons.info_outline,
          color: GlobalNoticeTheme.indicatorColor,
          size: GlobalNoticeTheme.indicatorSize,
        );
    return _instance._show(
      status: status,
      duration: duration ?? GlobalNoticeTheme.displayDuration,
      maskType: maskType,
      dismissOnTap: dismissOnTap,
      w: w,
    );
  }

  /// showToast [status] [duration] [toastPosition] [maskType]
  static Future<void> showToast(
    String status, {
    Duration? duration,
    GlobalNoticeToastPosition? toastPosition,
    GlobalNoticeMaskType? maskType,
    bool? dismissOnTap,
  }) {
    return _instance._show(
      status: status,
      duration: duration ?? GlobalNoticeTheme.displayDuration,
      toastPosition: toastPosition ?? GlobalNoticeTheme.toastPosition,
      maskType: maskType,
      dismissOnTap: dismissOnTap,
    );
  }

  /// showToast [status] [duration] [toastPosition] [maskType]
  /// disOnBg 点击背是否取消弹窗 为 true 时，取消弹窗，默认为 true
  /// duration 延时取消时间，默认为 15
  static Future<void> showNotice(
      {required Widget widget, bool? disOnBg, int? duration}) {
    // if(!GlobalConfig.hasEnterMainPage) return Future.value();
    // if (MainPageModel.inTeen) return Future.value();
    return _instance._show(
      w: widget,
      duration: Duration(seconds: duration ?? 15),
      toastPosition: GlobalNoticeToastPosition.top,
      maskType: GlobalNoticeMaskType.none,
      dismissOnTap: disOnBg ?? true,
      globalNoticeAnimationStyle: GlobalNoticeAnimationStyle.offset,
    );
  }

  /// dismiss loading
  static Future<void> dismiss({
    bool animation = true,
  }) {
    // cancel timer
    _instance._cancelTimer();
    return _instance._dismiss(animation);
  }

  /// add loading status callback
  static void addStatusCallback(GlobalNoticeStatusCallback callback) {
    if (!_instance._statusCallbacks.contains(callback)) {
      _instance._statusCallbacks.add(callback);
    }
  }

  /// remove single loading status callback
  static void removeCallback(GlobalNoticeStatusCallback callback) {
    if (_instance._statusCallbacks.contains(callback)) {
      _instance._statusCallbacks.remove(callback);
    }
  }

  /// remove all loading status callback
  static void removeAllCallbacks() {
    _instance._statusCallbacks.clear();
  }

  /// show [status] [duration] [toastPosition] [maskType]
  Future<void> _show({
    Widget? w,
    String? status,
    Duration? duration,
    GlobalNoticeMaskType? maskType,
    bool? dismissOnTap,
    GlobalNoticeToastPosition? toastPosition,
    GlobalNoticeAnimationStyle? globalNoticeAnimationStyle,
  }) async {
    assert(
      overlayEntry != null,
      'You should call GlobalNotice.init() in your MaterialApp',
    );

    if (loadingStyle == GlobalNoticeStyle.custom) {
      assert(
        backgroundColor != null,
        'while loading style is custom, backgroundColor should not be null',
      );
      assert(
        indicatorColor != null,
        'while loading style is custom, indicatorColor should not be null',
      );
      assert(
        textColor != null,
        'while loading style is custom, textColor should not be null',
      );
    }

    animationStyle =
        globalNoticeAnimationStyle ?? GlobalNoticeAnimationStyle.opacity;
    maskType ??= _instance.maskType;
    if (maskType == GlobalNoticeMaskType.custom) {
      assert(
        maskColor != null,
        'while mask type is custom, maskColor should not be null',
      );
    }

    if (animationStyle == GlobalNoticeAnimationStyle.custom) {
      assert(
        customAnimation != null,
        'while animationStyle is custom, customAnimation should not be null',
      );
    }

    toastPosition ??= GlobalNoticeToastPosition.center;
    bool animation = _w == null;
    _progressKey = null;
    if (_key != null) await dismiss(animation: false);

    Completer<void> completer = Completer<void>();
    _key = GlobalKey<GlobalNoticeContainerState>();
    _w = GlobalNoticeContainer(
      key: _key,
      status: status,
      indicator: w,
      animation: animation,
      toastPosition: toastPosition,
      maskType: maskType,
      dismissOnTap: dismissOnTap,
      completer: completer,
    );
    completer.future.whenComplete(() {
      _callback(GlobalNoticeStatus.show);
      if (duration != null) {
        _cancelTimer();
        _timer = Timer(duration, () async {
          await dismiss();
        });
      }
    });
    _markNeedsBuild();
    return completer.future;
  }

  // bool _isdismissing = false;
  Future<void> _dismiss(bool animation) async {
    // if (_isdismissing) {
    //   //防止多次点击出现多次退出的动画
    //   return;
    // }
    // _isdismissing = true;

    if (key != null && key?.currentState == null) {
      _reset();
      return;
    }

    return key?.currentState?.dismiss(animation).whenComplete(() {
      _reset();
    });
  }

  void _reset() {
    // _isdismissing = false;
    _w = null;
    _key = null;
    _progressKey = null;
    _cancelTimer();
    _markNeedsBuild();
    _callback(GlobalNoticeStatus.dismiss);
  }

  void _callback(GlobalNoticeStatus status) {
    for (final GlobalNoticeStatusCallback callback in _statusCallbacks) {
      callback(status);
    }
  }

  void _markNeedsBuild() {
    overlayEntry?.markNeedsBuild();
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }
}
