import 'package:beacon/base/extensions/context_ext.dart';
import 'package:flutter/material.dart';

/// Shown in place of the device list while no peer has been discovered.
///
/// The rings pulse outwards and fade, which reads as "listening" without a
/// spinner — a spinner here would compete with the per-transfer progress bars
/// below.
class ScanningPlaceholder extends StatefulWidget {
  const ScanningPlaceholder({super.key});

  static const double _size = 168;

  @override
  State<ScanningPlaceholder> createState() => _ScanningPlaceholderState();
}

class _ScanningPlaceholderState extends State<ScanningPlaceholder> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2800),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = context.colors.primaryFixed;
    // Honour the platform's "reduce motion" setting: the rings then sit still
    // at the spacing they used to have.
    final animate = !MediaQuery.disableAnimationsOf(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: Column(
        children: [
          SizedBox.square(
            dimension: ScanningPlaceholder._size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // One painter for all rings, repainting off the controller, so
                // no widget in the tree rebuilds per frame.
                Positioned.fill(
                  child: RepaintBoundary(
                    child: CustomPaint(
                      painter: _RadarPainter(
                        progress: animate ? _controller : const AlwaysStoppedAnimation(0),
                        color: accent,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(18)),
                  child: Icon(Icons.sensors_rounded, size: 26, color: context.colors.onPrimary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(context.tr.looking_for_devices, style: context.texts.titleMedium),
          const SizedBox(height: 6),
          Text(context.tr.searching_devices, style: context.texts.bodySmall, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  _RadarPainter({required this.progress, required this.color}) : super(repaint: progress);

  final Animation<double> progress;
  final Color color;

  static const int _ringCount = 3;
  static const double _minRadius = 34;
  static const double _maxRadius = 84;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    for (var i = 0; i < _ringCount; i++) {
      // Rings are evenly spaced in the cycle, so one leaves as the next starts.
      final phase = (progress.value + i / _ringCount) % 1;
      final radius = _minRadius + (_maxRadius - _minRadius) * phase;
      // Fade in quickly, then out towards the edge, so nothing pops.
      final opacity = (phase < 0.15 ? phase / 0.15 : 1 - (phase - 0.15) / 0.85) * 0.32;

      canvas.drawCircle(center, radius, paint..color = color.withValues(alpha: opacity.clamp(0, 1)));
    }
  }

  @override
  bool shouldRepaint(_RadarPainter oldDelegate) => oldDelegate.color != color || oldDelegate.progress != progress;
}
