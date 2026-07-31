import 'package:beacon/base/utils/env.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sdk_helpers/sdk_helpers.dart';
import 'package:sqflite/sqflite.dart';

class Db {
  const Db._(this._db);

  static late final Db instance;

  final Database _db;
  Database get db => _db;

  static Future<void> init() async {
    final dir = await getApplicationSupportDirectory();
    final path = join(dir.path, Env.dbName);

    final talkingDb = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Init tables/DAOs here
      },
    );

    instance = Db._(talkingDb);

    DartLogger.log('Initialized', name: 'DB');
  }
}
