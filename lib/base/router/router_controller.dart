import 'package:beacon/base/presentation/controllers/base_controller.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@singleton
class RouterController extends BaseController {
  static RouterController get to => GetIt.I<RouterController>();
}
