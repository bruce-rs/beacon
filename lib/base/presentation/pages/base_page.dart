import 'package:beacon/base/presentation/controllers/base_controller.dart';
import 'package:beacon/base/router/app_router.dart';
import 'package:flutter/widgets.dart';
import 'package:sdk_helpers/sdk_helpers.dart';

abstract class BasePage<C extends BaseController> extends StatelessWidget with LoggerMixin {
  const BasePage({super.key});

  String? get tag => null;

  C get controller => BindingsInstance.find<C>(tag);

  @protected
  @mustCallSuper
  void onPageStart() {
    controller;
  }

  @override
  StatelessElement createElement() {
    onPageStart();
    return super.createElement();
  }
}

abstract class Consumer<C extends BaseController> extends BasePage<C> {
  const Consumer({super.key});
}
