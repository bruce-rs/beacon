import 'package:beacon/base/theme/colors/app_color_extension.dart';
import 'package:flutter/material.dart';

class AppColors {
  static const Color white = Color(0xFFE6E6E6);
  static const Color black = Color(0xFF161616);
  static const Color blue = Color(0xFF3f7ee6);
  static const Color blueDim = Color(0xFFb5d8fd);
  static const Color blueBlack = Color(0xFF1A1B27);

  static ColorScheme get light => const ColorScheme.light(
    primary: Color(0xFFffffff),
    onPrimary: black,
    primaryContainer: Color(0xFFF3F9FF),
    onPrimaryContainer: white,
    primaryFixed: blue,
    primaryFixedDim: blueDim,
    onPrimaryFixed: white,
    onPrimaryFixedVariant: blueBlack,
    secondary: Color(0xFFE4E4F2),
    onSecondary: black,
    secondaryContainer: Color(0xFFD7D7E6),
    onSecondaryContainer: black,
    secondaryFixed: Color(0xFFfefadc),
    onSecondaryFixed: blueBlack,
    tertiary: Color(0xFF323336),
    onTertiary: white,
    error: Color(0xFFe1605c),
    onError: white,
    errorContainer: Color(0xFF5c2b29),
    onErrorContainer: white,
    surface: Color(0xFFf3f3f3),
    surfaceContainer: Color(0xFFE6E6E6),
    onSurface: black,
    onSurfaceVariant: black,
    outline: Color(0xFFC3C3C3),
    outlineVariant: Color(0xFFa5a4a5),
    scrim: Color(0xFF151515),
    shadow: Color(0xFF0B0A0A),
  );

  static ColorScheme get dark => const ColorScheme.dark(
    primary: Color(0xFF2c2c2e),
    onPrimary: white,
    primaryContainer: Color(0xFF242628),
    onPrimaryContainer: white,
    primaryFixed: blue,
    primaryFixedDim: blueDim,
    onPrimaryFixed: white,
    onPrimaryFixedVariant: blueBlack,
    secondary: Color(0xFF2c2c2e),
    onSecondary: white,
    secondaryContainer: Color(0xFF323235),
    onSecondaryContainer: white,
    secondaryFixed: Color(0xFF423a24),
    onSecondaryFixed: Color(0xFFe4dfca),
    tertiary: Color(0xFFe9e9e7),
    onTertiary: black,
    error: Color(0xFFdd5f54),
    onError: white,
    errorContainer: Color(0xFF5c2b29),
    onErrorContainer: white,
    surface: Color(0xFF1f2123),
    surfaceContainer: Color(0xFF2c2c2e),
    onSurface: white,
    onSurfaceVariant: white,
    outline: Color(0xFF3c3c43),
    outlineVariant: Color(0xFF7e7d80),
    scrim: Color(0xFF151515),
    shadow: Color(0xFF0B0A0A),
  );

  static AppColorExtension get lightColorExt => const AppColorExtension(
    success: Color(0XFF6CC071),
    onSuccess: Color(0xFFF4F4F4),
    successContainer: Color(0xFFE8F5E9),
    onSuccessContainer: Color(0xFF1A1B27),
  );

  static AppColorExtension get darkColorExt => const AppColorExtension(
    success: Color(0XFF6CC071),
    onSuccess: Color(0xFFF4F4F4),
    successContainer: Color(0xFFE8F5E9),
    onSuccessContainer: Color(0xFF1A1B27),
  );

  static ColorScheme colorScheme(Brightness brightness) => switch (brightness) {
    Brightness.light => light,
    Brightness.dark => dark,
  };

  static AppColorExtension colorExt(Brightness brightness) => switch (brightness) {
    Brightness.light => lightColorExt,
    Brightness.dark => darkColorExt,
  };
}
