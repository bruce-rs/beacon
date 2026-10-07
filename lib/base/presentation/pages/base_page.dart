import 'package:beacon/base/presentation/controllers/base_controller.dart';
import 'package:beacon/base/presentation/widgets/constrained_screen.dart';
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

  /// Caps the page width on large screens, via [ConstrainedScreen].
  ///
  /// Shells that sit above (or instead of) page content — [AppPage] builds the
  /// MaterialApp, [AppLayoutPage] only hosts a nested router — override this to
  /// false. Keep it false for anything that wraps a Navigator: a width cap
  /// around one also caps its modal routes, cutting bottom sheets off
  /// mid-screen on wide displays.
  bool get constrainWidth => true;

  /// Builds the page content. Implement this instead of [build] so the width
  /// constraint is applied consistently.
  @protected
  Widget buildPage(BuildContext context);

  @override
  Widget build(BuildContext context) =>
      constrainWidth ? ConstrainedScreen(child: buildPage(context)) : buildPage(context);

  @override
  StatelessElement createElement() {
    onPageStart();
    return super.createElement();
  }
}

abstract class Consumer<C extends BaseController> extends BasePage<C> {
  const Consumer({super.key});
}
