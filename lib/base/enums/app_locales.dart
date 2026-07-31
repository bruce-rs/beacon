import 'package:beacon/base/extensions/context_ext.dart';
import 'package:flutter/material.dart' show BuildContext, Locale;

enum AppLocale {
  enUS('en', 'US', '🇺🇸'),
  esES('es', 'ES', '🇪🇸');

  const AppLocale(this.langCode, this.countryCode, this.flag);

  final String langCode;
  final String countryCode;
  final String flag;

  Locale get asLocale => switch (this) {
    AppLocale.enUS => Locale(langCode, countryCode),
    AppLocale.esES => Locale(langCode, countryCode),
  };

  String displayLabel(BuildContext context) => switch (this) {
    AppLocale.enUS => '$flag  ${context.tr.lang_en}',
    AppLocale.esES => '$flag  ${context.tr.lang_es}',
  };
}
