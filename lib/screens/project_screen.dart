import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_widgets.dart';
import '../data/portfolio_data.dart';
import '../models/models.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInUp(
            child: const SectionEyebrow('Featured Work'),
          ),
          const SizedBox(height: 8),
          FadeInUp(
            delay: const Duration(milliseconds: 60),
            child: const SectionTitle('Projects'),
          ),
          const SizedBox(height: 28),
          ...PortfolioData.projects.asMap().entries.map(
            (e) => FadeInUp(
              duration: const Duration(milliseconds: 500),
              delay: Duration(milliseconds: e.key * 80),
              child: _ProjectCard(project: e.value),
            ),
          ),
        ],
      ),
    );
  }
}

// ── PROJECT CARD ──────────────────────────────────────────────
class _ProjectCard extends StatefulWidget {
  final Project project;
  const _ProjectCard({required this.project});

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.project;
    // Derive secondary color from primary
    final c2 = Color.lerp(p.color, AppColors.cyan, 0.45) ?? p.color;

    return GestureDetector(
      onTap: () => _openDetail(context),
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 20),
        transform: Matrix4.identity()..scale(_pressed ? 0.98 : 1.0),
        decoration: BoxDecoration(
          color: AppColors.glass,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _pressed
                ? p.color.withValues(alpha: 0.4)
                : AppColors.glassBorder,
          ),
          boxShadow: _pressed
              ? [
                  BoxShadow(
                    color: p.color.withValues(alpha: 0.15),
                    blurRadius: 32,
                    offset: const Offset(0, 8),
                  )
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gradient accent bar
            Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [p.color, c2]),
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: icon + title + arrow
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: p.color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            p.title.length >= 2
                                ? p.title.substring(0, 2)
                                : p.title,
                            style: GoogleFonts.syne(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: p.color.withValues(alpha: 0.9),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.title,
                              style: GoogleFonts.syne(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.3,
                                color: AppColors.white,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              p.subtitle,
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                color: AppColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Arrow circle
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.glassBorder),
                        ),
                        child: const Center(
                          child: Text(
                            '↗',
                            style: TextStyle(
                              color: AppColors.muted,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Description
                  Text(
                    p.description,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      color: const Color(0xA6FFFFFF),
                      height: 1.7,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 14),

                  // Bullet points
                  ...p.bullets.take(3).map(
                    (b) => Padding(
                      padding: const EdgeInsets.only(bottom: 7),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 18,
                            height: 18,
                            margin: const EdgeInsets.only(top: 1),
                            decoration: BoxDecoration(
                              color: p.color.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '✓',
                                style: TextStyle(
                                    fontSize: 9,
                                    color: p.color
                                        .withValues(alpha: 0.9),
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              b,
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                color: const Color(0xA6FFFFFF),
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Tech chips
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: p.tech.take(6).map(
                      (t) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: p.color.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: p.color.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Text(
                          t,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: p.color.withValues(alpha: 0.9),
                          ),
                        ),
                      ),
                    ).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDetail(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) =>
            ProjectDetailScreen(project: widget.project),
        transitionsBuilder: (_, animation, __, child) => SlideTransition(
          position: Tween(
                  begin: const Offset(1, 0), end: Offset.zero)
              .animate(CurvedAnimation(
                  parent: animation, curve: Curves.easeOutCubic)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}

// ── PROJECT DETAIL SCREEN ─────────────────────────────────────
class ProjectDetailScreen extends StatelessWidget {
  final Project project;
  const ProjectDetailScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final p = project;
    final c2 = Color.lerp(p.color, AppColors.cyan, 0.45) ?? p.color;

    return Scaffold(
      backgroundColor: AppColors.void_bg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            backgroundColor: AppColors.void_bg,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.glass,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: const Center(
                  child: Text(
                    '←',
                    style: TextStyle(
                        color: AppColors.white,
                        fontSize: 18),
                  ),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.title,
                    style: GoogleFonts.syne(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    p.subtitle,
                    style: GoogleFonts.outfit(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      p.color.withValues(alpha: 0.25),
                      c2.withValues(alpha: 0.1),
                      AppColors.void_bg,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: p.color.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.description,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: const Color(0xA6FFFFFF),
                      height: 1.75,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'KEY FEATURES',
                    style: GoogleFonts.outfit(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
                      color: AppColors.violet,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ...p.bullets.map(
                    (b) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            margin: const EdgeInsets.only(top: 1),
                            decoration: BoxDecoration(
                              color: p.color.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '✓',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: p.color,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(b,
                                style: GoogleFonts.outfit(
                                    fontSize: 13.5,
                                    color: const Color(0xA6FFFFFF),
                                    height: 1.6)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'TECH STACK',
                    style: GoogleFonts.outfit(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
                      color: AppColors.cyan,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 7,
                    runSpacing: 7,
                    children: p.tech
                        .map(
                          (t) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: p.color.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: p.color.withValues(alpha: 0.25),
                              ),
                            ),
                            child: Text(t,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: p.color,
                                    fontWeight: FontWeight.w500)),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
