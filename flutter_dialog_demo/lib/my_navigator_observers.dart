import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common_utils/log_util.dart';

import 'navigator_manager.dart';

/// @desc: 导航监听
/// @time 2019-09-20 09:55
/// @author Cheney

class MyNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    LogUtil.v("didPush router : $route |  previousRoute: $previousRoute");
    NavigatorManager().addRouter(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    LogUtil.v("didPop router : $route |  previousRoute: $previousRoute");

    NavigatorManager().removeRouter(route);

//    LogUtil.v("didPop history=${NavigatorManager().history}");
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    LogUtil.v("didRemove router : $route |  previousRoute: $previousRoute");
    NavigatorManager().removeRouter(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    LogUtil.v("didReplace router : $newRoute |  previousRoute: $oldRoute");
    if (newRoute != null && oldRoute != null)
      NavigatorManager().replaceRouter(newRoute, oldRoute);
  }
}
