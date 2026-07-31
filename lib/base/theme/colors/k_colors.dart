import 'dart:ui';

import 'package:sdk_helpers/sdk_helpers.dart';

enum KColor {
  transparent(Color(0x00000000)),
  lightBlue(Color(0xFFe2ecff)),
  lightGreen(Color(0xFFdfffe2)),
  lightPurple(Color(0xFFd6c9fd)),
  lightYellow(Color(0xFFfff7d7)),
  lightOrange(Color(0xFFfee0d4));

  const KColor(this.color);
  final Color color;

  static KColor fromJson(String rgbString) =>
      KColor.values.firstWhere((kColor) => kColor.asRGBString == rgbString, orElse: () => transparent);

  static String? toJson(KColor? kColor) {
    if (kColor == null) return null;
    return kColor.asRGBString;
  }
}

extension KColorExtension on KColor {
  String get asRGBString => color.asRGBString;
}
