import 'package:auto_route/auto_route.dart';
import 'package:beacon/base/constants/constants.dart';
import 'package:beacon/base/theme/colors/app_color_extension.dart';
import 'package:beacon/base/theme/colors/app_colors.dart';
import 'package:beacon/gen/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

extension ContextExt on BuildContext {
  AppLocalizations get tr => AppLocalizations.of(this)!;

  ThemeData get theme => Theme.of(this);
  TextTheme get texts => theme.textTheme;

  ColorScheme get colors => theme.colorScheme;
  AppColorExtension get colorsExt => theme.extension<AppColorExtension>() ?? AppColors.lightColorExt;

  bool get isDark => theme.brightness == Brightness.dark;
  bool get isLight => theme.brightness == Brightness.light;

  EdgeInsets get padding => MediaQuery.paddingOf(this);
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);
  EdgeInsets get viewPadding => MediaQuery.viewPaddingOf(this);

  Orientation get orientation => MediaQuery.orientationOf(this);
  bool get isLandscape => orientation == Orientation.landscape;
  bool get isPortrait => orientation == Orientation.portrait;

  Size get screenSize => MediaQuery.sizeOf(this);
  double get width => screenSize.width;
  double get height => screenSize.height;

  bool get isSmallScreen => screenSize.shortestSide <= kSmallScreenMaxWidth;
  bool get isMediumScreen =>
      screenSize.shortestSide > kSmallScreenMaxWidth && screenSize.shortestSide <= kMediumScreenMaxWidth;
  bool get isLargeScreen =>
      screenSize.shortestSide > kMediumScreenMaxWidth && screenSize.shortestSide <= kLargeScreenMaxWidth;
  bool get isXLargeScreen => screenSize.shortestSide > kLargeScreenMaxWidth;

  bool get isPortraitSmall => isPortrait && isSmallScreen;
  bool get isPortraitMedium => isPortrait && isMediumScreen;
  bool get isPortraitLarge => isPortrait && isLargeScreen;

  bool get isLandscapeSmall => isLandscape && isSmallScreen;
  bool get isLandscapeMedium => isLandscape && isMediumScreen;
  bool get isLandscapeLarge => isLandscape && isLargeScreen;

  void hideKeyboard() => FocusScope.of(this).unfocus();

  void safePop<T extends Object?>([T? result]) async {
    if (mounted) pop(result);
  }

  Future<bool> safeMaybePop<T extends Object?>([T? result]) async {
    if (mounted) return await maybePop(result);
    return false;
  }
}
