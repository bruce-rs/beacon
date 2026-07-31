import 'package:beacon/base/extensions/context_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show ThemeMode, BuildContext, Icons;

extension ThemeModeExt on ThemeMode {
  (String, IconData) labelIcon(BuildContext context) => switch (this) {
    ThemeMode.system => (context.tr.theme_system, Icons.brightness_auto_outlined),
    ThemeMode.light => (context.tr.theme_light, Icons.light_mode_outlined),
    ThemeMode.dark => (context.tr.theme_dark, Icons.dark_mode_outlined),
  };
}
