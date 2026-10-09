import 'dart:io';
import 'dart:math' as math;

import 'package:beacon/base/constants/app_sizes.dart';
import 'package:beacon/base/constants/constants.dart';
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
  double maxWidth = kBottomSheetMaxWidth,
  bool showDragHandle = false,
}) async {
  if (Platform.isIOS) {
    return await showCupertinoSheet<T>(
      context: context,
      enableDrag: isDismissible,
      scrollableBuilder: (BuildContext context, ScrollController controller) {
        Widget widgetBuilder(BuildContext context) => Material(
          color: backgroundColor ?? context.colors.surface,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // A Cupertino sheet draws no handle of its own, so add the
                  // same grab bar Material gives us; it dismisses by swiping.
                  if (showDragHandle) const _CupertinoSheetHandle(),
                  Flexible(child: builder(context)),
                ],
              ),
            ),
          ),
        );
        return widgetBuilder(context);
      },
    );
  }

  // 90% of the screen, and never a minimum taller than that: in landscape the
  // available height can be smaller than the requested minimum.
  final maxHeight = context.height * 0.9;
  final effectiveMinHeight = math.min(minHeight ?? context.height * 0.6, maxHeight);

  return await showModalBottomSheet<T>(
    isScrollControlled: isScrollControlled,
    showDragHandle: showDragHandle,
    isDismissible: isDismissible,
    useRootNavigator: useRootNavigator,
    backgroundColor: backgroundColor ?? context.colors.surface,
    clipBehavior: clipBehavior,
    // The sheet's own cap, not the page's: Material's default is 640, which is
    // narrower than the rest of the app.
    constraints: BoxConstraints(maxHeight: maxHeight, maxWidth: maxWidth),
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(kBorderRadiusLarge))),
    context: context,
    builder: (context) => ConstrainedBox(
      constraints: BoxConstraints(minHeight: effectiveMinHeight, maxHeight: maxHeight),
      child: Padding(padding: context.viewInsets, child: builder(context)),
    ),
  );
}

class _CupertinoSheetHandle extends StatelessWidget {
  const _CupertinoSheetHandle();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 12, bottom: 4),
    child: Container(
      width: 42,
      height: 4,
      decoration: BoxDecoration(
        color: context.colors.onSurfaceVariant.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(999),
      ),
    ),
  );
}
