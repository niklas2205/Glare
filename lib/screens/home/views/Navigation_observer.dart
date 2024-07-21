import 'package:flutter/cupertino.dart';

class EventNavigationObserver extends NavigatorObserver {
  final Function onReturn;

  EventNavigationObserver({required this.onReturn});

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    onReturn();
  }
}
