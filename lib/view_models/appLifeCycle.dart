import 'package:flutter/material.dart';

class AppLifecycleStateNotifier with ChangeNotifier, WidgetsBindingObserver {
  AppLifecycleState? _lifecycleState;

  AppLifecycleState get lifecycleState => _lifecycleState!;

  AppLifecycleStateNotifier() {
    _lifecycleState = AppLifecycleState.resumed;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _lifecycleState = state;
    if (_lifecycleState == AppLifecycleState.paused) {
      // Thực hiện hành động khi ứng dụng tắt
    }
    notifyListeners();
  }
}