import 'package:beacon/base/di/di_entry_point.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@InjectableInit(initializerName: 'initDI', preferRelativeImports: true, asExtension: true)
Future<void> initDI() async => GetIt.I.initDI();
