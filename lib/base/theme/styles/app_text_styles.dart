import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextTheme texTheme(TextTheme textTheme, ColorScheme colors) {
    final baseTheme = GoogleFonts.robotoTextTheme(textTheme);

    // Styles according to Material Design 3 Typography
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
        fontSize: 24,
        fontWeight: FontWeight.w400,
        height: 1.3,
        letterSpacing: .0,
      ),
      titleLarge: baseTheme.titleLarge?.copyWith(
        color: colors.onSurface,
        fontSize: 22,
        fontWeight: FontWeight.w400,
        height: 1.3,
        letterSpacing: .0,
      ),
      titleMedium: baseTheme.titleMedium?.copyWith(
        color: colors.onSurface,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.5,
        letterSpacing: 0.15,
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
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        letterSpacing: 0.5,
      ),
      bodyMedium: baseTheme.bodyMedium?.copyWith(
        color: colors.onSurface,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.45,
        letterSpacing: 0.25,
      ),
      bodySmall: baseTheme.bodySmall?.copyWith(
        color: colors.onSurface,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.3,
        letterSpacing: 0.4,
      ),
      labelLarge: baseTheme.labelLarge?.copyWith(
        color: colors.onSurface,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.45,
        letterSpacing: 0.1,
      ),
      labelMedium: baseTheme.labelMedium?.copyWith(
        color: colors.onSurface,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.3,
        letterSpacing: 0.5,
      ),
      labelSmall: baseTheme.labelSmall?.copyWith(
        color: colors.onSurface,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.3,
        letterSpacing: 0.5,
      ),
    );
  }
}
