import 'package:beacon/base/data/db/db.dart';
import 'package:beacon/base/data/storage/app_storage.dart';
import 'package:beacon/base/di/di_entry_point.dart';
import 'package:beacon/base/presentation/pages/app_page.dart';
import 'package:beacon/base/utils/env.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Env.init();
  await AppStorage.init();
  await Db.init();
  await initDI();

  runApp(const AppPage());
}
