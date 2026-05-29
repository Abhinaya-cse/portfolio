import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Glassmorphism card matching the HTML .glass-card style
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final double borderWidth;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.borderColor,
    this.borderWidth = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.glass,
        borderRadius: borderRadius ?? BorderRadius.circular(20),
        border: Border.all(
          color: borderColor ?? AppColors.glassBorder,
          width: borderWidth,
        ),
      ),
      child: child,
    );
  }
}

/// Section eyebrow label  (e.g. "Featured Work" above "Projects")
class SectionEyebrow extends StatelessWidget {
  final String text;
  final Color color;
  const SectionEyebrow(this.text, {super.key, this.color = AppColors.violet});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20, height: 1,
          color: color,
          margin: const EdgeInsets.only(right: 10),
        ),
        Text(
          text.toUpperCase(),
          style: TextStyle(
            fontSize: 10, fontWeight: FontWeight.w700,
            letterSpacing: 1.6, color: color,
            fontFamily: 'Outfit',
          ),
        ),
      ],
    );
  }
}

/// Big gradient section title
class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [AppColors.white, Color(0x8CFFFFFF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: Text(
        text,
        style: Theme.of(context).textTheme.displayMedium?.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }
}
