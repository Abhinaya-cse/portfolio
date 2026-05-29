import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Animated radial-gradient orbs — mirrors the HTML canvas background.
class OrbBackground extends StatefulWidget {
  final Widget child;
  const OrbBackground({super.key, required this.child});

  @override
  State<OrbBackground> createState() => _OrbBackgroundState();
}

class _OrbBackgroundState extends State<OrbBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Void background
        Container(color: AppColors.void_bg),
        // Animated orbs
        AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) => CustomPaint(
            painter: _OrbPainter(_ctrl.value),
            size: Size.infinite,
            child: const SizedBox.expand(),
          ),
        ),
        // Noise overlay
        IgnorePointer(
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topLeft,
                radius: 2.5,
                colors: [
                  Colors.white.withValues(alpha: 0.01),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Content
        widget.child,
      ],
    );
  }
}

class _OrbPainter extends CustomPainter {
  final double t;
  _OrbPainter(this.t);

  static const _orbs = [
    _Orb(fx: 0.15, fy: 0.20, r: 280, c: Color(0x387C5CFC), vx: 0.4, vy: 0.25),
    _Orb(fx: 0.78, fy: 0.72, r: 240, c: Color(0x2E00E5D4), vx: -0.3, vy: 0.2),
    _Orb(fx: 0.50, fy: 0.45, r: 200, c: Color(0x24B044FC), vx: 0.2, vy: -0.35),
    _Orb(fx: 0.85, fy: 0.15, r: 180, c: Color(0x1EF5C542), vx: -0.25, vy: 0.3),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final angle = t * math.pi * 2;
    for (final orb in _orbs) {
      final dx = math.sin(angle * orb.vx) * 0.06;
      final dy = math.cos(angle * orb.vy) * 0.06;
      final cx = (orb.fx + dx) * size.width;
      final cy = (orb.fy + dy) * size.height;
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [orb.c, orb.c.withValues(alpha: 0)],
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: orb.r.toDouble()));
      canvas.drawCircle(Offset(cx, cy), orb.r.toDouble(), paint);
    }
  }

  @override
  bool shouldRepaint(_OrbPainter old) => old.t != t;
}

class _Orb {
  final double fx, fy, vx, vy;
  final int r;
  final Color c;
  const _Orb({
    required this.fx, required this.fy, required this.r,
    required this.c, required this.vx, required this.vy,
  });
}
