import 'dart:io';

import 'package:beacon/base/constants/app_sizes.dart';
import 'package:beacon/base/extensions/context_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<T?> showAdaptiveBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isScrollControlled = true,
  bool isDismissible = true,
  bool useRootNavigator = true,
  Clip clipBehavior = Clip.hardEdge,
  Color? backgroundColor,
  double? minHeight,
}) async {
  if (Platform.isIOS) {
    return await showCupertinoSheet<T>(
      context: context,
      enableDrag: isDismissible,
      builder: (context) => Material(color: backgroundColor ?? context.colors.surface, child: builder(context)),
    );
  }

  return await showModalBottomSheet<T>(
    isScrollControlled: isScrollControlled,
    isDismissible: isDismissible,
    useRootNavigator: useRootNavigator,
    backgroundColor: backgroundColor ?? context.colors.surface,
    clipBehavior: clipBehavior,
    constraints: BoxConstraints(maxHeight: context.height * 0.9),
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(kBorderRadiusLarge))),
    context: context,
    builder: (context) => ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight ?? context.height * 0.6, maxHeight: context.height * 0.9),
      child: Padding(padding: context.viewInsets, child: builder(context)),
    ),
  );
}
