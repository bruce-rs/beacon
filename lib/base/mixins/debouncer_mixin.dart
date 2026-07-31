import 'dart:async';

import 'package:flutter/widgets.dart';

mixin DebouncerMixin<T extends StatefulWidget> on State<T> {
  Timer? _debounceTimer;

  Duration get debounceDuration => const Duration(milliseconds: 500);

  void debounce(VoidCallback action) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(debounceDuration, action);
  }

  void cancelDebounce() => _debounceTimer?.cancel();

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
