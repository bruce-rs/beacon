import 'package:beacon/base/utils/flavors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static final String dbName = _tryGet<String>('DB_NAME');
  static final String folderName = _tryGet<String>('MEDIA_FOLDER_NAME');

  /// Load environment variables from [AppFlavor.envFile].
  static Future<void> init() async => await dotenv.load(fileName: AppFlavor.envFile);

  static T _tryGet<T>(String key, {T? fallback}) {
    if (!dotenv.isInitialized) {
      throw Exception('dotenv is not initialized, call init() first');
    }

    return switch (T) {
          const (String) => dotenv.get(key, fallback: fallback as String?),
          const (int) => dotenv.getInt(key, fallback: fallback as int?),
          const (double) => dotenv.getDouble(key, fallback: fallback as double?),
          const (bool) => dotenv.getBool(key, fallback: fallback as bool?),
          _ => throw Exception('Unsupported environment variable type: $T'),
        }
        as T;
  }
}
