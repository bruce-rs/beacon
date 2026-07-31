extension StringExt on String {
  static final _urlRegex = RegExp(
    r'^https?:\/\/'
    r'('
    r'localhost|'
    r'(\d{1,3}\.){3}\d{1,3}|'
    r'([a-zA-Z0-9-]+\.)*[a-zA-Z0-9-]+'
    r')'
    r'(:\d+)?(\/[^\s]*)?$',
    caseSensitive: false,
  );

  bool get isValidUrl => _urlRegex.hasMatch(this);
}
