import 'package:flutter/material.dart';

import '../log/r_logs.dart';
import 'wk_route_aware.dart';

class AppNavigatorObserver extends NavigatorObserver {
  List<String> history = [];
  List<WkRouteAware> _awareList = [];

  void add(WkRouteAware aware) => _awareList.add(aware);

  bool remove(WkRouteAware aware) => _awareList.remove(aware);

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);

    var routeName = getRouteName(route);
    history.removeLast();
    RLog.d('Pop route: $routeName, history: ${history.join(', ')}');

    for (var element in _awareList) {
      element.didPop(route, previousRoute);
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);

    var routeName = getRouteName(route);
    history.add(routeName);
    RLog.d(
        'Push route: ${getRouteName(route)}, history: ${history.join(', ')}');

    for (var element in _awareList) {
      element.didPush(route, previousRoute);
    }
  }

  String getRouteName(Route? route) => WkRouteAware.getRouteName(route);
}
