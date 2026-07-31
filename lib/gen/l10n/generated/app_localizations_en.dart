// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_name => 'Beacon';

  @override
  String get settings => 'Settings';

  @override
  String get nearby_devices => 'Nearby Devices';

  @override
  String get searching_devices => 'Searching for devices on your network…';

  @override
  String get transfers => 'Transfers';

  @override
  String get drop_zone_select_device => 'Select a device above to send files';

  @override
  String drop_zone_tap_to_pick(String name) {
    return 'Tap to pick files\nand send to $name';
  }

  @override
  String drop_zone_release_to_send(String name) {
    return 'Release to send to $name';
  }

  @override
  String drop_zone_drop_files(String name) {
    return 'Drop files here\nto send to $name';
  }

  @override
  String get status => 'Status';

  @override
  String get status_running => 'Online';

  @override
  String get status_starting => 'Starting…';

  @override
  String get status_stopped => 'Offline';

  @override
  String get status_error => 'Error';

  @override
  String get open_folder => 'Open folder';

  @override
  String get open_folder_failed => 'Couldn\'t open the folder';

  @override
  String get appearance => 'Appearance';

  @override
  String get theme_system => 'System default';

  @override
  String get theme_light => 'Light';

  @override
  String get theme_dark => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get lang_en => 'English';

  @override
  String get lang_es => 'Spanish';

  @override
  String get oops_you_should_not_be_here => 'Oops! You shouldn\'t be here. Let\'s go back to where we started.';

  @override
  String get go_home => 'Go Home';

  @override
  String get unknown_page => 'Unknown Page';

  @override
  String get privacy_policy => 'Privacy Policy';

  @override
  String get privacy_policy_subtitle => 'How we handle your files and data';

  @override
  String get privacy_policy_close => 'Close';

  @override
  String get privacy_policy_intro =>
      'Beacon is a free tool that helps you share files between your own devices on the same local network. Please read the points below before using the app.';

  @override
  String get privacy_policy_file_sharing_title => 'File sharing only';

  @override
  String get privacy_policy_file_sharing_body =>
      'The app is limited to transferring the files you explicitly choose to send. Nothing is sent in the background and nothing is uploaded to any server.';

  @override
  String get privacy_policy_liability_title => 'Network risks are always present';

  @override
  String get privacy_policy_liability_body =>
      'This app does not modify or damage your files. However, since transfers rely on your local network, some risks are always present and are outside of our control. We recommend keeping your own backups of important files.';

  @override
  String get privacy_policy_free_title => 'Completely free';

  @override
  String get privacy_policy_free_body => 'The app is totally free. There are no purchases, subscriptions, or ads.';

  @override
  String get privacy_policy_no_tracking_title => 'No tracking';

  @override
  String get privacy_policy_no_tracking_body =>
      'We do not collect, track, or share any personal data, analytics, or usage information.';

  @override
  String get privacy_policy_no_storage_title => 'No file storage';

  @override
  String get privacy_policy_no_storage_body =>
      'We do not store your files. Transfers go directly between your devices on the local network; no copy is kept by us.';
}
