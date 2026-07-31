import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

enum Flavor { dev, prod, unknown }

abstract class AppFlavor {
  static const String _flavor = appFlavor ?? String.fromEnvironment('flavor');

  static Flavor get flavor => switch (_flavor) {
    'prod' => Flavor.prod,
    'dev' => Flavor.dev,
    _ => Flavor.unknown,
  };

  static String get title => switch (flavor) {
    Flavor.prod => 'Beacon',
    Flavor.dev => 'Beacon (Dev)',
    Flavor.unknown => 'Beacon (Unknown)',
  };

  static String get envFile => switch (flavor) {
    Flavor.prod => 'assets/env/.env.prod',
    _ => 'assets/env/.env.dev',
  };

  static bool get isProd => flavor == Flavor.prod;
  static bool get isProdRelease => flavor == Flavor.prod && kReleaseMode;
  static bool get isDev => flavor == Flavor.dev;
}
