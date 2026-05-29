import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_widgets.dart';
import '../data/portfolio_data.dart';
import '../models/models.dart';

class SkillsSection extends StatefulWidget {
  const SkillsSection({super.key});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> {
  String _selected = 'All';
  final _cats = ['All', 'Mobile', 'Backend', 'Web', 'Design', 'Tools'];

  Color _catColor(String cat) {
    switch (cat) {
      case 'Mobile':  return AppColors.violet;
      case 'Backend': return AppColors.cyan;
      case 'Web':     return AppColors.coral;
      case 'Design':
      case 'Tools':   return AppColors.gold;
      default:        return AppColors.violet;
    }
  }

  List<Color> _catGradient(String cat) {
    switch (cat) {
      case 'Mobile':  return [AppColors.violet, const Color(0xFF9D80FD)];
      case 'Backend': return [AppColors.cyan, AppColors.green];
      case 'Web':     return [AppColors.coral, const Color(0xFFFF9966)];
      case 'Design':  return [AppColors.gold, AppColors.coral];
      case 'Tools':   return [AppColors.gold, AppColors.coral];
      default:        return [AppColors.violet, AppColors.cyan];
    }
  }

  IconData _catIcon(String cat) {
    switch (cat) {
      case 'Mobile':  return Icons.phone_android_rounded;
      case 'Backend': return Icons.storage_rounded;
      case 'Web':     return Icons.language_rounded;
      case 'Design':  return Icons.palette_rounded;
      case 'Tools':   return Icons.build_rounded;
      default:        return Icons.category_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final toShow = _selected == 'All'
        ? ['Mobile', 'Backend', 'Web', 'Design', 'Tools']
        : [_selected];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInUp(child: const SectionEyebrow('Tech Stack')),
          const SizedBox(height: 8),
          FadeInUp(
            delay: const Duration(milliseconds: 60),
            child: const SectionTitle('Skills'),
          ),
          const SizedBox(height: 24),

          // Filter chips
          FadeInDown(
            duration: const Duration(milliseconds: 400),
            child: SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _cats.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final cat = _cats[i];
                  final isActive = cat == _selected;
                  final color = cat == 'All' ? AppColors.violet : _catColor(cat);
                  return GestureDetector(
                    onTap: () => setState(() => _selected = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        gradient: isActive
                            ? LinearGradient(
                                colors: cat == 'All'
                                    ? [AppColors.violet, AppColors.purple]
                                    : _catGradient(cat),
                              )
                            : null,
                        color: isActive ? null : AppColors.glass,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isActive
                              ? color.withValues(alpha: 0.5)
                              : AppColors.glassBorder,
                        ),
                      ),
                      child: Text(
                        cat,
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color:
                              isActive ? Colors.white : AppColors.muted,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 24),

          ...toShow.asMap().entries.map((entry) {
            final cat = entry.value;
            final catSkills = PortfolioData.skills
                .where((s) => s.category == cat)
                .toList();
            if (catSkills.isEmpty) return const SizedBox.shrink();

            return FadeInUp(
              duration: const Duration(milliseconds: 400),
              delay: Duration(milliseconds: entry.key * 80),
              child: _SkillGroupCard(
                category: cat,
                color: _catColor(cat),
                gradient: _catGradient(cat),
                icon: _catIcon(cat),
                skills: catSkills,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _SkillGroupCard extends StatefulWidget {
  final String category;
  final Color color;
  final List<Color> gradient;
  final IconData icon;
  final List<Skill> skills;
  const _SkillGroupCard({
    required this.category,
    required this.color,
    required this.gradient,
    required this.icon,
    required this.skills,
  });

  @override
  State<_SkillGroupCard> createState() => _SkillGroupCardState();
}

class _SkillGroupCardState extends State<_SkillGroupCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.glass,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category header
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(widget.icon, size: 16, color: widget.color),
              ),
              const SizedBox(width: 10),
              Text(
                widget.category,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: widget.color,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: widget.color.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  '${widget.skills.length}',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: widget.color,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Skill chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.skills.map((s) {
              return Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: widget.color.withValues(alpha: 0.25),
                  ),
                ),
                child: Text(
                  s.name,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

/// Minimal visibility wrapper that fires once when widget enters viewport
class VisibilityDetectorWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback onVisible;
  const VisibilityDetectorWrapper(
      {super.key, required this.child, required this.onVisible});

  @override
  State<VisibilityDetectorWrapper> createState() =>
      _VisibilityDetectorWrapperState();
}

class _VisibilityDetectorWrapperState
    extends State<VisibilityDetectorWrapper> {
  bool _fired = false;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (_) {
        if (!_fired) _checkVisibility();
        return false;
      },
      child: Builder(
        builder: (ctx) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!_fired) _checkVisibility();
          });
          return widget.child;
        },
      ),
    );
  }

  void _checkVisibility() {
    final ctx = context;
    if (!ctx.mounted) return;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return;
    final pos = box.localToGlobal(Offset.zero);
    final screenH = MediaQuery.of(ctx).size.height;
    if (pos.dy < screenH * 0.9) {
      _fired = true;
      widget.onVisible();
    }
  }
}