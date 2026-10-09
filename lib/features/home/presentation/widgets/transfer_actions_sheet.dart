import 'dart:io';

import 'package:beacon/base/extensions/context_ext.dart';
import 'package:beacon/base/utils/env.dart';
import 'package:beacon/features/beacon/data/models/file_transfer.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

/// Actions for a received file, shown from [TransferTile].
class TransferActionsSheet extends StatelessWidget {
  const TransferActionsSheet({
    super.key,
    required this.transfer,
    required this.onOpenFolder,
    required this.onRemove,
  });

  final FileTransfer transfer;
  final VoidCallback onOpenFolder;
  final VoidCallback onRemove;

  /// Where the file landed, in a form a person can match against their files
  /// app. Android hands back a MediaStore URI rather than a path, so the folder
  /// is reconstructed from the same values the save used.
  String get _location {
    if (Platform.isAndroid) return p.join('Download', Env.folderName);
    final path = transfer.savePath;
    if (path == null) return Env.folderName;
    final dir = p.dirname(path);
    // The last two segments are enough to recognise the folder.
    final parts = p.split(dir);
    return parts.length <= 2 ? dir : p.join(parts[parts.length - 2], parts.last);
  }

  IconData get _fileIcon {
    final ext = p.extension(transfer.filename).toLowerCase();
    return switch (ext) {
      '.jpg' || '.jpeg' || '.png' || '.gif' || '.webp' || '.heic' => Icons.image_outlined,
      '.mp4' || '.mov' || '.mkv' || '.avi' || '.webm' => Icons.movie_outlined,
      '.mp3' || '.wav' || '.m4a' || '.flac' || '.ogg' => Icons.audiotrack_outlined,
      '.pdf' => Icons.picture_as_pdf_outlined,
      '.zip' || '.rar' || '.7z' || '.tar' || '.gz' => Icons.folder_zip_outlined,
      _ => Icons.insert_drive_file_outlined,
    };
  }

  @override
  Widget build(BuildContext context) {
    final success = context.colorsExt.success ?? context.colors.primaryFixed;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ────────────────────────────────────────────────
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: success.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Icon(_fileIcon, size: 24, color: success),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        transfer.filename,
                        style: context.texts.titleLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${transfer.formattedSize} · ${context.tr.transfer_received_from(transfer.deviceName)}',
                        style: context.texts.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── Where it landed ───────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: context.colors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Icon(Icons.folder_outlined, size: 18, color: context.colors.onSurfaceVariant),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(context.tr.saved_in, style: context.texts.labelSmall),
                        const SizedBox(height: 2),
                        Text(_location, style: context.texts.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Actions ───────────────────────────────────────────────
            _SheetAction(
              icon: Icons.folder_open_outlined,
              label: context.tr.open_folder,
              isPrimary: true,
              onTap: onOpenFolder,
            ),
            const SizedBox(height: 10),
            _SheetAction(icon: Icons.playlist_remove_rounded, label: context.tr.remove_from_list, onTap: onRemove),
          ],
        ),
      ),
    );
  }
}

class _SheetAction extends StatelessWidget {
  const _SheetAction({required this.icon, required this.label, required this.onTap, this.isPrimary = false});

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final background = isPrimary ? context.colors.primaryFixed : context.colors.surfaceContainerHigh;
    final foreground = isPrimary ? context.colors.onPrimary : context.colors.onSurface;

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: isPrimary
                      ? context.colors.onPrimary.withValues(alpha: 0.18)
                      : context.colors.surfaceContainer,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, size: 18, color: foreground),
              ),
              const SizedBox(width: 13),
              Expanded(child: Text(label, style: context.texts.bodyLarge?.copyWith(color: foreground))),
              if (isPrimary) Icon(Icons.chevron_right_rounded, size: 20, color: foreground),
            ],
          ),
        ),
      ),
    );
  }
}
