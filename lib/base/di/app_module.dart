import 'package:beacon/base/data/storage/app_storage.dart';
import 'package:beacon/base/router/app_router.dart';
import 'package:injectable/injectable.dart';

@module
abstract class AppModule {
  @singleton
  AppRouter get appRouter => AppRouter.to;

  @singleton
  AppStorage get appStorage => AppStorage.to;
}
