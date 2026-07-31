part of 'app_router.dart';

class PageBindings<C extends BaseController> {
  const PageBindings({
    this.initial = false,
    required this.page,
    required this.path,
    this.keepAlive = false,
    this.transitionsBuilder,
  });

  final bool initial;
  final PageInfo page;
  final String path;
  final bool keepAlive;
  final RouteTransitionsBuilder? transitionsBuilder;

  Widget _defaultTransitionBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) => FadeTransition(opacity: animation, child: child);

  CustomRouteBuilder? _routeBuilder() => <T>(BuildContext context, Widget child, AutoRoutePage<T> page) {
    // If keepAlive is true, then it's a singleton so we fallback to GetIt
    if (!keepAlive) BindingsInstance.insert<C>(route: page.name);

    return PageRouteBuilder<T>(
      fullscreenDialog: page.fullscreenDialog,
      settings: page,
      transitionsBuilder: transitionsBuilder ?? _defaultTransitionBuilder,
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (_, _, _) => child,
    );
  };

  CustomRoute route({List<AutoRoute>? children}) =>
      CustomRoute(initial: initial, page: page, path: path, customRouteBuilder: _routeBuilder(), children: children);
}

abstract class BindingsInstance {
  static final Map<String, _BindingEntry> _bindings = {};
  static final Map<String, String> _routeToKey = {};

  static String _getKey(Type type, String? name) => name == null ? type.toString() : '${type.toString()}&$name';

  static S find<S extends BaseController>(String? name) {
    final key = _getKey(S, name);
    return _findByKey<S>(key);
  }

  static S findByRoute<S extends BaseController>(String routeName) {
    final key = _routeToKey[routeName];
    if (key == null) {
      throw Exception('No binding found for route: $routeName');
    }
    return _findByKey<S>(key);
  }

  static S _initController<S extends BaseController>(S controller) {
    if (!controller.isInitialized) {
      controller.onInit();
      controller.isInitialized = true;
    }
    return controller;
  }

  static S _findByKey<S extends BaseController>(String key) {
    final entry = _bindings[key];
    if (entry == null) {
      if (GetIt.I.isRegistered<S>()) return _initController<S>(GetIt.I<S>());

      throw Exception('No binding found for $key.');
    }

    return _initController<S>(entry.controller as S);
  }

  static void insert<C extends BaseController>({String? name, String? route}) {
    final key = _getKey(C, name);
    if (_bindings.containsKey(key)) return;

    _bindings[key] = _BindingEntry(GetIt.I<C>());
    if (route != null) _routeToKey[route] = key;
  }

  static bool remove<C extends BaseController>({String? name, String? route}) {
    final key = _getKey(C, name);
    if (!_bindings.containsKey(key)) {
      DartLogger.w('$key already unregistered.');
      return false;
    }

    final entry = _bindings[key]!;
    entry.controller.onClose();
    _bindings.remove(key);
    if (route != null) _routeToKey.remove(route);
    return true;
  }

  static bool removeByRoute(String? routeName) {
    if (routeName == null) {
      return false;
    }

    final key = _routeToKey[routeName];
    if (key == null) return false;

    final entry = _bindings[key];
    if (entry == null) {
      _routeToKey.remove(routeName);
      return false;
    }

    entry.controller.onClose();
    _bindings.remove(key);
    _routeToKey.remove(routeName);
    return true;
  }
}

class _BindingEntry<C extends BaseController> {
  const _BindingEntry(this.controller);

  final C controller;
}

class BindingsObserver extends AutoRouterObserver with LoggerMixin {
  @override
  void didPop(Route route, Route? previousRoute) {
    BindingsInstance.removeByRoute(route.settings.name);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    BindingsInstance.removeByRoute(oldRoute?.settings.name);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    BindingsInstance.removeByRoute(route.settings.name);
  }
}
