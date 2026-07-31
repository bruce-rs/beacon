import 'package:beacon/base/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class AppInputStyles {
  static OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: const BorderRadius.all(Radius.circular(kBorderRadius)),
    borderSide: BorderSide(color: color, width: kBorderWidth),
  );

  static InputDecorationTheme inputDecorationTheme(TextTheme textTheme, ColorScheme colors) {
    return InputDecorationTheme(
      contentPadding: const EdgeInsets.all(kPadding),
      isDense: true,
      hintStyle: textTheme.bodyMedium?.copyWith(color: colors.outline),
      labelStyle: textTheme.bodyMedium,
      helperStyle: textTheme.bodySmall,
      errorStyle: textTheme.bodySmall?.copyWith(color: colors.error),
      errorMaxLines: 2,
      border: _border(colors.onPrimary),
      enabledBorder: _border(colors.onPrimary.withAlpha(130)),
      focusedBorder: _border(colors.onPrimary),
      disabledBorder: _border(colors.outline.withAlpha(130)),
      errorBorder: _border(colors.error),
      focusedErrorBorder: _border(colors.error),
    );
  }

  static TextSelectionThemeData textSelectionTheme(ColorScheme colors) {
    return TextSelectionThemeData(
      cursorColor: colors.onPrimary,
      selectionColor: colors.primaryFixed.withAlpha(150),
      selectionHandleColor: colors.primaryFixed,
    );
  }

  static CheckboxThemeData checkboxTheme(ColorScheme colors) {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        final isActive = states.contains(WidgetState.selected);
        return isActive ? colors.surfaceContainer : colors.surface;
      }),
      checkColor: WidgetStateProperty.all(colors.onPrimary),
      side: BorderSide(color: colors.outline, width: kBorderWidth),
    );
  }

  static RadioThemeData radioTheme(ColorScheme colors) {
    return RadioThemeData(fillColor: WidgetStateProperty.all(colors.tertiary));
  }

  static SwitchThemeData switchTheme(ColorScheme colors) {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        final isActive = states.contains(WidgetState.selected);
        return isActive ? colors.tertiary : colors.outline;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        final isActive = states.contains(WidgetState.selected);
        return isActive ? colors.surfaceContainer : colors.surface;
      }),
    );
  }
}
