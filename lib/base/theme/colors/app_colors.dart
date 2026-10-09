import 'package:beacon/base/theme/colors/app_color_extension.dart';
import 'package:flutter/material.dart';

class AppColors {
  static const Color white = Color(0xFFE6E6E6);
  static const Color black = Color(0xFF161616);
  static const Color blue = Color(0xFF3f7ee6);
  static const Color blueDim = Color(0xFFb5d8fd);
  static const Color blueBlack = Color(0xFF1A1B27);

  // ── Surfaces ────────────────────────────────────────────────────────────────
  // Dark greys are spaced far enough apart that a card reads as raised against
  // the page; the previous set sat within a few points of each other.
  static const Color darkSurface = Color(0xFF121418);
  static const Color darkSurfaceLow = Color(0xFF15181D);
  static const Color darkSurfaceContainer = Color(0xFF1B1F25);
  static const Color darkSurfaceHigh = Color(0xFF22272F);
  static const Color darkOnSurface = Color(0xFFF2F5F8);
  static const Color darkOnSurfaceVariant = Color(0xFF9AA4B0);
  static const Color darkOutline = Color(0xFF6B757F);
  static const Color darkOutlineVariant = Color(0xFF23272E);
  static const Color darkPrimaryContainer = Color(0xFF1E2A3C);

  static const Color lightSurface = Color(0xFFF4F6F9);
  static const Color lightSurfaceLow = Color(0xFFF7F9FB);
  static const Color lightSurfaceContainer = Color(0xFFFFFFFF);
  static const Color lightSurfaceHigh = Color(0xFFF1F4F8);
  static const Color lightOnSurface = Color(0xFF15181D);
  static const Color lightOnSurfaceVariant = Color(0xFF54606C);
  static const Color lightOutline = Color(0xFF8794A1);
  static const Color lightOutlineVariant = Color(0xFFEEF1F5);
  static const Color lightPrimaryContainer = Color(0xFFE4EEFC);

  /// Reads on a blue tint, where [blue] itself would be too dark/light.
  static const Color blueOnTintDark = Color(0xFF9CC3F7);
  static const Color blueOnTintLight = Color(0xFF2F63B8);

  // ── Device identity tints ───────────────────────────────────────────────────
  // Picked per device from its advertised id so a device keeps one colour.
  static const Color tealDark = Color(0xFF2BB3A3);
  static const Color tealLight = Color(0xFF157F72);
  static const Color violetDark = Color(0xFF8B7CF6);
  static const Color violetLight = Color(0xFF5A46D6);

  static ColorScheme get light => const ColorScheme.light(
    primary: Color(0xFFffffff),
    onPrimary: black,
    primaryContainer: lightPrimaryContainer,
    onPrimaryContainer: blueOnTintLight,
    primaryFixed: blue,
    primaryFixedDim: blueOnTintLight,
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
    surface: lightSurface,
    surfaceContainerLow: lightSurfaceLow,
    surfaceContainer: lightSurfaceContainer,
    surfaceContainerHigh: lightSurfaceHigh,
    onSurface: lightOnSurface,
    onSurfaceVariant: lightOnSurfaceVariant,
    outline: lightOutline,
    outlineVariant: lightOutlineVariant,
    scrim: Color(0xFF151515),
    shadow: Color(0xFF0B0A0A),
  );

  static ColorScheme get dark => const ColorScheme.dark(
    primary: Color(0xFF2c2c2e),
    onPrimary: white,
    primaryContainer: darkPrimaryContainer,
    onPrimaryContainer: blueOnTintDark,
    primaryFixed: blue,
    primaryFixedDim: blueOnTintDark,
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
    surface: darkSurface,
    surfaceContainerLow: darkSurfaceLow,
    surfaceContainer: darkSurfaceContainer,
    surfaceContainerHigh: darkSurfaceHigh,
    onSurface: darkOnSurface,
    onSurfaceVariant: darkOnSurfaceVariant,
    outline: darkOutline,
    outlineVariant: darkOutlineVariant,
    scrim: Color(0xFF151515),
    shadow: Color(0xFF0B0A0A),
  );

  static AppColorExtension get lightColorExt => const AppColorExtension(
    success: Color(0xFF3F9A4C),
    onSuccess: Color(0xFFFFFFFF),
    successContainer: Color(0xFFDFF2E1),
    onSuccessContainer: Color(0xFF2A6B35),
    deviceTeal: tealLight,
    deviceViolet: violetLight,
  );

  static AppColorExtension get darkColorExt => const AppColorExtension(
    success: Color(0xFF6CC071),
    onSuccess: Color(0xFF0D1F12),
    successContainer: Color(0xFF1C2A20),
    onSuccessContainer: Color(0xFF8FD694),
    deviceTeal: tealDark,
    deviceViolet: violetDark,
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
