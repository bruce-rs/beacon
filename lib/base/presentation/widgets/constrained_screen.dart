import 'package:beacon/base/constants/constants.dart';
import 'package:beacon/base/extensions/context_ext.dart';
import 'package:flutter/material.dart';

/// Centres a page and caps its width on large screens.
///
/// This lives around each page rather than in `MaterialApp.builder`, because
/// the builder also wraps the navigator: a width cap there applies to modal
/// routes too, leaving bottom sheets and dialogs cut off mid-screen instead of
/// spanning the display.
class ConstrainedScreen extends StatelessWidget {
  const ConstrainedScreen({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: context.colors.surface,
    child: Align(
      alignment: Alignment.topCenter,
      child: SafeArea(
        child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: kMediumScreenMaxWidth), child: child),
      ),
    ),
  );
}
