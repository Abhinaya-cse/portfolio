import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/glass_widgets.dart';
import '../data/portfolio_data.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final experiences = PortfolioData.experience;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInUp(child: const SectionEyebrow('Work History')),
          const SizedBox(height: 8),
          FadeInUp(
            delay: const Duration(milliseconds: 60),
            child: const SectionTitle('Experience'),
          ),
          const SizedBox(height: 28),

          ...experiences.asMap().entries.map((e) {
            final idx = e.key;
            final exp = e.value;
            final isFirst = idx == 0;
            final isLast = idx == experiences.length - 1;

            return FadeInLeft(
              duration: const Duration(milliseconds: 450),
              delay: Duration(milliseconds: idx * 70),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Timeline column
                    SizedBox(
                      width: 28,
                      child: Column(
                        children: [
                          // Dot
                          Container(
                            width: 14,
                            height: 14,
                            margin: const EdgeInsets.only(top: 5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: isFirst
                                  ? const LinearGradient(
                                      colors: [
                                        AppColors.violet,
                                        AppColors.cyan,
                                      ],
                                    )
                                  : null,
                              color: isFirst ? null : AppColors.void_bg,
                              border: Border.all(
                                color: isFirst
                                    ? AppColors.violet
                                    : AppColors.glassBorder,
                                width: isFirst ? 0 : 1.5,
                              ),
                            ),
                            child: isFirst
                                ? const SizedBox()
                                : Center(
                                    child: Container(
                                      width: 5,
                                      height: 5,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.muted,
                                      ),
                                    ),
                                  ),
                          ),
                          // Line
                          if (!isLast)
                            Expanded(
                              child: Container(
                                width: 1,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 4),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      isFirst
                                          ? AppColors.violet
                                              .withValues(alpha: 0.4)
                                          : AppColors.glassBorder,
                                      AppColors.border,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Card
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                          left: 12,
                          bottom: isLast ? 0 : 16,
                        ),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.glass,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isFirst
                                ? AppColors.violet.withValues(alpha: 0.35)
                                : AppColors.glassBorder,
                            width: isFirst ? 1 : 1,
                          ),
                          boxShadow: isFirst
                              ? [
                                  BoxShadow(
                                    color: AppColors.violetGlow
                                        .withValues(alpha: 0.15),
                                    blurRadius: 24,
                                    offset: const Offset(0, 4),
                                  )
                                ]
                              : null,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isFirst) ...[
                              // Live badge
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0x1A7C5CFC),
                                          Color(0x0D7C5CFC),
                                        ],
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(100),
                                      border: Border.all(
                                        color: AppColors.violet
                                            .withValues(alpha: 0.3),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        _PulseDot(),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Current Role',
                                          style: GoogleFonts.outfit(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.violet,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],

                            // Role
                            Text(
                              exp.role,
                              style: GoogleFonts.syne(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.white,
                                letterSpacing: -0.2,
                              ),
                            ),
                            const SizedBox(height: 6),

                            // Company row
                            Row(
                              children: [
                                const Text('🏢',
                                    style: TextStyle(fontSize: 11)),
                                const SizedBox(width: 5),
                                Text(
                                  exp.company,
                                  style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isFirst
                                        ? AppColors.violet
                                        : AppColors.cyan,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),

                            // Duration
                            Row(
                              children: [
                                const Text('📅',
                                    style: TextStyle(fontSize: 10)),
                                const SizedBox(width: 5),
                                Text(
                                  exp.duration,
                                  style: GoogleFonts.outfit(
                                    fontSize: 11,
                                    color: AppColors.muted,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Description
                            Text(
                              exp.description,
                              style: GoogleFonts.outfit(
                                fontSize: 12.5,
                                color: const Color(0xA6FFFFFF),
                                height: 1.65,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// Animated pulsing green dot for "live" badge
class _PulseDot extends StatefulWidget {
  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.violet.withValues(alpha: _anim.value),
          boxShadow: [
            BoxShadow(
              color: AppColors.violet.withValues(alpha: _anim.value * 0.5),
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }
}
