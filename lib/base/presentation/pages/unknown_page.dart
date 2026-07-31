import 'package:auto_route/auto_route.dart';
import 'package:beacon/base/extensions/context_ext.dart';
import 'package:beacon/base/router/app_router.dart';
import 'package:flutter/material.dart';

@RoutePage()
class UnknownPage extends StatelessWidget {
  const UnknownPage({super.key});

  static const String routePath = '*';

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.tr.unknown_page), leading: const SizedBox.shrink()),
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          Text(context.tr.oops_you_should_not_be_here),
          FilledButton(
            onPressed: () => context.router.replaceAll([const HomeRoute()]),
            child: Text(context.tr.go_home),
          ),
        ],
      ),
    ),
  );
}
