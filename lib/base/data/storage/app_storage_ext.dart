part of 'app_storage.dart';

extension AppStorageExt on AppStorage {
  AppLocale get locale {
    final value = read(AppKey.locale) ?? AppLocale.enUS.name;
    return AppLocale.values.firstWhere((e) => e.name == value, orElse: () => AppLocale.enUS);
  }

  Future<void> setLocale(AppLocale locale) async {
    await write(AppKey.locale, locale.name);
  }

  ThemeMode get theme {
    final value = read(AppKey.theme) ?? ThemeMode.system.name;
    return ThemeMode.values.firstWhere((e) => e.name == value, orElse: () => ThemeMode.system);
  }

  Future<void> setTheme(ThemeMode theme) async {
    await write(AppKey.theme, theme.name);
  }
}
