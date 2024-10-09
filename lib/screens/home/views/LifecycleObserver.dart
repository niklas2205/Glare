import 'package:flutter/widgets.dart';
import 'package:glare/screens/home/views/ClickTracking.dart';


class LifecycleObserver with WidgetsBindingObserver {
  // Singleton pattern
  static final LifecycleObserver _instance = LifecycleObserver._internal();

  factory LifecycleObserver() {
    return _instance;
  }

  LifecycleObserver._internal();

  void startObserving() {
    WidgetsBinding.instance.addObserver(this);
    ClickTrackingService().startPeriodicFlush();
  }

  void stopObserving() {
    WidgetsBinding.instance.removeObserver(this);
    ClickTrackingService().stopPeriodicFlush();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      ClickTrackingService().flushCountsToFirestore();
    }
  }
}