import 'dart:io';

import 'package:beacon/base/extensions/context_ext.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';

class DropZoneWidget extends StatefulWidget {
  const DropZoneWidget({
    super.key,
    required this.isActive,
    required this.selectedDeviceName,
    required this.onDropped,
    this.onTap,
  });

  final bool isActive;
  final String? selectedDeviceName;

  /// Called on desktop when files are dropped.
  final void Function(List<String> paths) onDropped;

  /// Called on mobile when the zone is tapped (opens file picker in controller).
  final VoidCallback? onTap;

  @override
  State<DropZoneWidget> createState() => _DropZoneWidgetState();
}

class _DropZoneWidgetState extends State<DropZoneWidget> {
  bool _hovering = false;

  static bool get _isDesktop => Platform.isLinux || Platform.isMacOS || Platform.isWindows;

  static bool get _isMobile => Platform.isAndroid || Platform.isIOS;

  @override
  Widget build(BuildContext context) {
    final content = _buildContent(context);

    if (_isDesktop) {
      return DropTarget(
        onDragEntered: (_) => setState(() => _hovering = true),
        onDragExited: (_) => setState(() => _hovering = false),
        onDragDone: (detail) {
          setState(() => _hovering = false);
          if (widget.isActive) {
            widget.onDropped(detail.files.map((f) => f.path).toList());
          }
        },
        child: content,
      );
    }

    if (_isMobile) {
      return GestureDetector(onTap: widget.isActive ? widget.onTap : null, child: content);
    }

    return content;
  }

  Widget _buildContent(BuildContext context) {
    final active = widget.isActive;
    final hovering = _hovering && active;
    final name = widget.selectedDeviceName ?? '';

    final String title;
    final String? hint;
    final IconData icon;

    if (!active) {
      title = context.tr.drop_zone_select_device;
      hint = null;
      icon = Icons.file_upload_outlined;
    } else if (hovering) {
      title = context.tr.drop_zone_hint_release;
      hint = context.tr.send_to(name);
      icon = Icons.file_download_outlined;
    } else {
      title = context.tr.send_to(name);
      hint = _isMobile ? context.tr.drop_zone_hint_tap : context.tr.drop_zone_hint_drop;
      icon = Icons.file_upload_outlined;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
      decoration: BoxDecoration(
        // Inactive is a dashed-looking inset; selected fills with the accent
        // tint so the state change is visible without reading the label.
        color: active ? context.colors.primaryContainer : context.colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: hovering
              ? context.colors.primaryFixed
              : active
              ? context.colors.primaryFixed.withValues(alpha: 0.55)
              : context.colors.outlineVariant,
          width: hovering ? 2 : 1.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: active ? context.colors.primaryFixed : context.colors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, size: 26, color: active ? context.colors.onPrimary : context.colors.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: active ? context.texts.titleMedium : context.texts.bodyLarge?.copyWith(color: context.colors.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          if (hint != null) ...[
            const SizedBox(height: 4),
            Text(hint, style: context.texts.bodySmall, textAlign: TextAlign.center),
          ],
        ],
      ),
    );
  }
}
