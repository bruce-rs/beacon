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

    final String label;
    final IconData icon;

    if (!active) {
      label = context.tr.drop_zone_select_device;
      icon = Icons.upload_file_outlined;
    } else if (_isMobile) {
      label = context.tr.drop_zone_tap_to_pick(widget.selectedDeviceName ?? '');
      icon = Icons.folder_open_outlined;
    } else if (hovering) {
      label = context.tr.drop_zone_release_to_send(widget.selectedDeviceName ?? '');
      icon = Icons.file_download_outlined;
    } else {
      label = context.tr.drop_zone_drop_files(widget.selectedDeviceName ?? '');
      icon = Icons.upload_file_outlined;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: double.infinity,
      height: 148,
      decoration: BoxDecoration(
        color: hovering
            ? context.colors.primaryFixed.withValues(alpha: 0.08)
            : context.colors.primaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hovering
              ? context.colors.primaryFixed
              : active
              ? context.colors.primaryFixed.withValues(alpha: 0.4)
              : context.colors.outline,
          width: hovering ? 2 : 1.5,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 36, color: active ? context.colors.primaryFixed : context.colors.outlineVariant),
            const SizedBox(height: 10),
            Text(
              label,
              style: context.texts.bodyMedium?.copyWith(
                color: active ? context.colors.onSurface : context.colors.outlineVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
