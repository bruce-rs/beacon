import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en'), Locale('es')];

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'Beacon'**
  String get app_name;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @nearby_devices.
  ///
  /// In en, this message translates to:
  /// **'Nearby Devices'**
  String get nearby_devices;

  /// No description provided for @searching_devices.
  ///
  /// In en, this message translates to:
  /// **'Searching for devices on your network…'**
  String get searching_devices;

  /// No description provided for @transfers.
  ///
  /// In en, this message translates to:
  /// **'Transfers'**
  String get transfers;

  /// No description provided for @drop_zone_select_device.
  ///
  /// In en, this message translates to:
  /// **'Select a device above to send files'**
  String get drop_zone_select_device;

  /// No description provided for @drop_zone_tap_to_pick.
  ///
  /// In en, this message translates to:
  /// **'Tap to pick files\nand send to {name}'**
  String drop_zone_tap_to_pick(String name);

  /// No description provided for @drop_zone_release_to_send.
  ///
  /// In en, this message translates to:
  /// **'Release to send to {name}'**
  String drop_zone_release_to_send(String name);

  /// No description provided for @drop_zone_drop_files.
  ///
  /// In en, this message translates to:
  /// **'Drop files here\nto send to {name}'**
  String drop_zone_drop_files(String name);

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @status_running.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get status_running;

  /// No description provided for @status_starting.
  ///
  /// In en, this message translates to:
  /// **'Starting…'**
  String get status_starting;

  /// No description provided for @status_stopped.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get status_stopped;

  /// No description provided for @status_error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get status_error;

  /// No description provided for @open_folder.
  ///
  /// In en, this message translates to:
  /// **'Open folder'**
  String get open_folder;

  /// No description provided for @open_folder_failed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the folder'**
  String get open_folder_failed;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @theme_system.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get theme_system;

  /// No description provided for @theme_light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get theme_light;

  /// No description provided for @theme_dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get theme_dark;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @lang_en.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get lang_en;

  /// No description provided for @lang_es.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get lang_es;

  /// No description provided for @oops_you_should_not_be_here.
  ///
  /// In en, this message translates to:
  /// **'Oops! You shouldn\'t be here. Let\'s go back to where we started.'**
  String get oops_you_should_not_be_here;

  /// No description provided for @go_home.
  ///
  /// In en, this message translates to:
  /// **'Go Home'**
  String get go_home;

  /// No description provided for @unknown_page.
  ///
  /// In en, this message translates to:
  /// **'Unknown Page'**
  String get unknown_page;

  /// No description provided for @privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy_policy;

  /// No description provided for @privacy_policy_subtitle.
  ///
  /// In en, this message translates to:
  /// **'How we handle your files and data'**
  String get privacy_policy_subtitle;

  /// No description provided for @privacy_policy_close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get privacy_policy_close;

  /// No description provided for @privacy_policy_intro.
  ///
  /// In en, this message translates to:
  /// **'Beacon is a free tool that helps you share files between your own devices on the same local network. Please read the points below before using the app.'**
  String get privacy_policy_intro;

  /// No description provided for @privacy_policy_file_sharing_title.
  ///
  /// In en, this message translates to:
  /// **'File sharing only'**
  String get privacy_policy_file_sharing_title;

  /// No description provided for @privacy_policy_file_sharing_body.
  ///
  /// In en, this message translates to:
  /// **'The app is limited to transferring the files you explicitly choose to send. Nothing is sent in the background and nothing is uploaded to any server.'**
  String get privacy_policy_file_sharing_body;

  /// No description provided for @privacy_policy_liability_title.
  ///
  /// In en, this message translates to:
  /// **'Network risks are always present'**
  String get privacy_policy_liability_title;

  /// No description provided for @privacy_policy_liability_body.
  ///
  /// In en, this message translates to:
  /// **'This app does not modify or damage your files. However, since transfers rely on your local network, some risks are always present and are outside of our control. We recommend keeping your own backups of important files.'**
  String get privacy_policy_liability_body;

  /// No description provided for @privacy_policy_free_title.
  ///
  /// In en, this message translates to:
  /// **'Completely free'**
  String get privacy_policy_free_title;

  /// No description provided for @privacy_policy_free_body.
  ///
  /// In en, this message translates to:
  /// **'The app is totally free. There are no purchases, subscriptions, or ads.'**
  String get privacy_policy_free_body;

  /// No description provided for @privacy_policy_no_tracking_title.
  ///
  /// In en, this message translates to:
  /// **'No tracking'**
  String get privacy_policy_no_tracking_title;

  /// No description provided for @privacy_policy_no_tracking_body.
  ///
  /// In en, this message translates to:
  /// **'We do not collect, track, or share any personal data, analytics, or usage information.'**
  String get privacy_policy_no_tracking_body;

  /// No description provided for @privacy_policy_no_storage_title.
  ///
  /// In en, this message translates to:
  /// **'No file storage'**
  String get privacy_policy_no_storage_title;

  /// No description provided for @privacy_policy_no_storage_body.
  ///
  /// In en, this message translates to:
  /// **'We do not store your files. Transfers go directly between your devices on the local network; no copy is kept by us.'**
  String get privacy_policy_no_storage_body;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
