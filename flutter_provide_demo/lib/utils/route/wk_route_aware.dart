import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/navigator.dart';

import '../log/r_logs.dart';
import '../string_utils.dart';

/// An interface for objects that are aware of their current [Route].
///
/// This is used with [RouteObserver] to make a widget aware of changes to the
/// [Navigator]'s session history.
abstract class WkRouteAware {
  static RegExp sReRouteBuilder = RegExp(r"Closure: \(BuildContext\) =>");

  /// Called when the top route has been popped off, and the current route
  /// shows up.
  void didPopNext() {}

  /// Called when the current route has been pushed.
  void didPush(Route<dynamic> route, Route? previousRoute) {}

  /// Called when the current route has been popped off.
  void didPop(Route<dynamic> route, Route? previousRoute) {}

  /// Called when a new route has been pushed, and the current route is no
  /// longer visible.
  void didPushNext() {}

  static String getRouteName(Route<dynamic>? route) {
    var name = route?.settings.name;
    if (name?.isNotEmpty ?? false) {
      return name!;
    } else if (route is MaterialPageRoute) {
      return route.builder.toString().replaceFirst(sReRouteBuilder, "");
    } else if (route is CupertinoPageRoute) {
      return route.builder.toString().replaceFirst(sReRouteBuilder, "");
    }
    return 'unknown';
  }

  bool isMainPage(Route<dynamic>? route) {
    String? name = getRouteName(route);
    RLog.d('---->$name');
    if (StringUtil.equalIgnoreCase(name.trim(), 'widget') ||
        StringUtil.equalIgnoreCase(name.trim(), '/') ||
        StringUtil.equalIgnoreCase(name.trim(), 'mainpage')) {
      RLog.d('---->$name---true');
      return true;
    }
    return false;
  }
}
