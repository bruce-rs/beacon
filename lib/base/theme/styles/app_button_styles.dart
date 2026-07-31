import 'package:beacon/base/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class AppButtonStyles {
  static const _minSize = Size.zero;
  static const _shape = RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(kBorderRadius)));
  static const _padding = EdgeInsets.symmetric(horizontal: kPaddingHorizontal, vertical: kPaddingVertical);

  static FilledButtonThemeData filledButtonThemeData(TextTheme textTheme, ColorScheme colors) {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: _padding,
        minimumSize: _minSize,
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        textStyle: textTheme.labelLarge,
        shape: _shape,
      ),
    );
  }

  static OutlinedButtonThemeData outlinedButtonThemeData(TextTheme textTheme, ColorScheme colors) {
    return OutlinedButtonThemeData(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(_padding),
        minimumSize: WidgetStateProperty.all(_minSize),
        side: WidgetStateProperty.resolveWith((states) {
          final isDisabled = states.contains(WidgetState.disabled);
          return BorderSide(color: isDisabled ? colors.outline : colors.onPrimary.withAlpha(90), width: kBorderWidth);
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          final isDisabled = states.contains(WidgetState.disabled);
          return isDisabled ? colors.outline : colors.onPrimary;
        }),
        textStyle: WidgetStateProperty.all(textTheme.labelLarge),
        shape: WidgetStateProperty.all(_shape),
      ),
    );
  }

  static TextButtonThemeData textButtonThemeData(TextTheme textTheme, ColorScheme colors) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: _padding,
        minimumSize: _minSize,
        foregroundColor: colors.onPrimary,
        textStyle: textTheme.labelLarge,
        shape: _shape,
      ),
    );
  }

  static ElevatedButtonThemeData elevatedButtonThemeData(TextTheme textTheme, ColorScheme colors) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: _padding,
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        textStyle: textTheme.labelLarge,
        shape: _shape,
      ),
    );
  }

  static FloatingActionButtonThemeData floatingActionButtonThemeData(ColorScheme colors) {
    return FloatingActionButtonThemeData(
      shape: const CircleBorder(),
      iconSize: kIconSizeLarge,
      backgroundColor: colors.primaryFixed,
      foregroundColor: colors.onPrimaryFixed,
      elevation: kElevation,
    );
  }

  static MenuButtonThemeData menuButtonThemeData(TextTheme textTheme, ColorScheme colors) {
    return MenuButtonThemeData(
      style: MenuItemButton.styleFrom(
        textStyle: textTheme.bodyMedium,
        iconColor: colors.onSurfaceVariant,
        backgroundColor: colors.onPrimary,
      ),
    );
  }

  static IconButtonThemeData iconButtonThemeData(ColorScheme colors) {
    return IconButtonThemeData(style: IconButton.styleFrom(iconSize: kIconSize));
  }

  static IconThemeData iconThemeData({Color? color, double size = kIconSize}) {
    return IconThemeData(color: color, size: size);
  }
}
