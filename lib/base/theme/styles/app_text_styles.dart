import 'package:flutter/material.dart';

class AppTextStyles {
  static TextTheme texTheme(TextTheme textTheme, ColorScheme colors) {
    // Manrope ships in the bundle (see pubspec `fonts:`), so no network fetch
    // and no silent fallback to the platform font.
    final baseTheme = textTheme.apply(fontFamily: 'Manrope');

    // Material Design 3 roles, tuned for Beacon: heavier weights and tighter
    // sizes than stock MD3, so a dense list still has a clear hierarchy.
    return baseTheme.copyWith(
      displayLarge: baseTheme.displayLarge?.copyWith(
        color: colors.onPrimary,
        fontSize: 54,
        fontWeight: FontWeight.w400,
        height: 1.2,
        letterSpacing: -.25,
      ),
      displayMedium: baseTheme.displayMedium?.copyWith(
        color: colors.onPrimary,
        fontSize: 45,
        fontWeight: FontWeight.w400,
        height: 1.15,
        letterSpacing: .0,
      ),
      displaySmall: baseTheme.displaySmall?.copyWith(
        color: colors.onPrimary,
        fontSize: 36,
        fontWeight: FontWeight.w400,
        height: 1.2,
        letterSpacing: .0,
      ),
      headlineLarge: baseTheme.headlineLarge?.copyWith(
        color: colors.onSurface,
        fontSize: 32,
        fontWeight: FontWeight.w400,
        height: 1.3,
        letterSpacing: .0,
      ),
      headlineMedium: baseTheme.headlineMedium?.copyWith(
        color: colors.onSurface,
        fontSize: 28,
        fontWeight: FontWeight.w400,
        height: 1.3,
        letterSpacing: .0,
      ),
      headlineSmall: baseTheme.headlineSmall?.copyWith(
        color: colors.onSurface,
        fontSize: 23,
        fontWeight: FontWeight.w800,
        height: 1.25,
        letterSpacing: -.4,
      ),
      titleLarge: baseTheme.titleLarge?.copyWith(
        color: colors.onSurface,
        fontSize: 17,
        fontWeight: FontWeight.w800,
        height: 1.3,
        letterSpacing: .0,
      ),
      titleMedium: baseTheme.titleMedium?.copyWith(
        color: colors.onSurface,
        fontSize: 16,
        fontWeight: FontWeight.w800,
        height: 1.35,
        letterSpacing: .0,
      ),
      titleSmall: baseTheme.titleSmall?.copyWith(
        color: colors.onSurface,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.45,
        letterSpacing: 0.1,
      ),
      bodyLarge: baseTheme.bodyLarge?.copyWith(
        color: colors.onSurface,
        fontSize: 15,
        fontWeight: FontWeight.w700,
        height: 1.4,
        letterSpacing: .0,
      ),
      bodyMedium: baseTheme.bodyMedium?.copyWith(
        color: colors.onSurface,
        fontSize: 13.5,
        fontWeight: FontWeight.w700,
        height: 1.4,
        letterSpacing: .0,
      ),
      bodySmall: baseTheme.bodySmall?.copyWith(
        color: colors.onSurfaceVariant,
        fontSize: 12.5,
        fontWeight: FontWeight.w600,
        height: 1.45,
        letterSpacing: .0,
      ),
      labelLarge: baseTheme.labelLarge?.copyWith(
        color: colors.onSurface,
        fontSize: 14.5,
        fontWeight: FontWeight.w700,
        height: 1.4,
        letterSpacing: .0,
      ),
      labelMedium: baseTheme.labelMedium?.copyWith(
        color: colors.onSurface,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        height: 1.3,
        letterSpacing: .0,
      ),
      labelSmall: baseTheme.labelSmall?.copyWith(
        color: colors.onSurfaceVariant,
        fontSize: 11,
        fontWeight: FontWeight.w800,
        height: 1.3,
        letterSpacing: 1.4,
      ),
    );
  }
}
