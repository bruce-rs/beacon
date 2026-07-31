import 'package:beacon/base/constants/app_sizes.dart';
import 'package:beacon/base/theme/colors/app_colors.dart';
import 'package:beacon/base/theme/styles/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData _create(ThemeData base) {
    final colors = AppColors.colorScheme(base.brightness);
    final textTheme = AppTextStyles.texTheme(base.textTheme, colors);

    return base.copyWith(
      canvasColor: colors.surfaceContainerLow,
      scaffoldBackgroundColor: colors.surface,
      primaryColor: colors.primary,
      colorScheme: colors,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      extensions: [AppColors.colorExt(base.brightness)],
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: kPaddingSmall + 2, vertical: kPaddingSmall),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(kBorderRadiusLarge))),
        visualDensity: VisualDensity(horizontal: -4, vertical: -4),
      ),

      //* INPUTS *//
      inputDecorationTheme: AppInputStyles.inputDecorationTheme(textTheme, colors),
      cupertinoOverrideTheme: CupertinoThemeData(primaryColor: colors.primaryFixed),
      textSelectionTheme: AppInputStyles.textSelectionTheme(colors),
      checkboxTheme: AppInputStyles.checkboxTheme(colors),
      radioTheme: AppInputStyles.radioTheme(colors),
      switchTheme: AppInputStyles.switchTheme(colors),

      //* Buttons *//
      filledButtonTheme: AppButtonStyles.filledButtonThemeData(textTheme, colors),
      outlinedButtonTheme: AppButtonStyles.outlinedButtonThemeData(textTheme, colors),
      textButtonTheme: AppButtonStyles.textButtonThemeData(textTheme, colors),
      elevatedButtonTheme: AppButtonStyles.elevatedButtonThemeData(textTheme, colors),
      iconButtonTheme: AppButtonStyles.iconButtonThemeData(colors),
      floatingActionButtonTheme: AppButtonStyles.floatingActionButtonThemeData(colors),
      menuButtonTheme: AppButtonStyles.menuButtonThemeData(textTheme, colors),
      dialogTheme: AppDialogStyles.dialogTheme(textTheme, colors),
      datePickerTheme: AppDialogStyles.datePickerThemeData(textTheme, colors),

      //* BARS *//
      iconTheme: AppButtonStyles.iconThemeData(color: colors.outlineVariant),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        titleTextStyle: textTheme.headlineSmall,
        actionsIconTheme: AppButtonStyles.iconThemeData(color: colors.onSurfaceVariant),
      ),

      tabBarTheme: TabBarThemeData(
        indicatorColor: colors.primary,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: colors.primary, width: kBorderWidth),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedIconTheme: AppButtonStyles.iconThemeData(color: colors.primary, size: kIconSizeLarge),
        unselectedIconTheme: AppButtonStyles.iconThemeData(color: colors.onSurfaceVariant, size: kIconSizeLarge),
        selectedLabelStyle: textTheme.labelMedium,
        unselectedLabelStyle: textTheme.labelMedium,
        selectedItemColor: colors.primary,
        unselectedItemColor: colors.onSurfaceVariant,
      ),
      navigationRailTheme: NavigationRailThemeData(
        selectedIconTheme: AppButtonStyles.iconThemeData(color: colors.primary, size: kIconSizeLarge),
        unselectedIconTheme: AppButtonStyles.iconThemeData(color: colors.onSurfaceVariant, size: kIconSizeLarge),
        selectedLabelTextStyle: textTheme.labelLarge,
        unselectedLabelTextStyle: textTheme.labelLarge,
        minWidth: 50,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.primary,
        linearTrackColor: colors.primary,
        linearMinHeight: 8.0,
      ),
    );
  }

  static ThemeData get light => _create(ThemeData.light(useMaterial3: true));

  static ThemeData get dark => _create(ThemeData.dark(useMaterial3: true));
}
