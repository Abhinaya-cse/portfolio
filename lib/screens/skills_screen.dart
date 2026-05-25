import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../theme/app_theme.dart';
import '../../data/portfolio_data.dart';
import '../../widgets/section_header.dart';

class SkillsSection extends StatefulWidget {
  const SkillsSection({super.key});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> {
  String _selectedCategory = 'All';
  final _categories = ['All', 'Mobile', 'Backend', 'Web', 'Design', 'Tools'];

  // Icon mapping per category
  IconData _categoryIcon(String cat) {
    switch (cat) {
      case 'Mobile':  return Icons.phone_android_rounded;
      case 'Backend': return Icons.storage_rounded;
      case 'Web':     return Icons.language_rounded;
      case 'Design':  return Icons.palette_rounded;
      case 'Tools':   return Icons.build_rounded;
      default:        return Icons.category_rounded;
    }
  }

  // Accent color per category
  Color _categoryColor(String cat) {
    switch (cat) {
      case 'Mobile':  return const Color(0xFF6C63FF);
      case 'Backend': return const Color(0xFF00D4AA);
      case 'Web':     return const Color(0xFFFF7043);
      case 'Design':  return const Color(0xFFAB47BC);
      case 'Tools':   return const Color(0xFF29B6F6);
      default:        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Group skills by category (respect filter)
    final categoriesToShow = _selectedCategory == 'All'
        ? ['Mobile', 'Backend', 'Web', 'Design', 'Tools']
        : [_selectedCategory];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Skills'),
          const SizedBox(height: 16),

          // ── Category filter chips ───────────────────────
          FadeInDown(
            duration: const Duration(milliseconds: 350),
            child: SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final cat = _categories[i];
                  final isActive = cat == _selectedCategory;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.primary
                            : (isDark
                                ? AppColors.darkCard
                                : AppColors.lightCard),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isActive
                              ? AppColors.primary
                              : (isDark
                                  ? AppColors.darkBorder
                                  : AppColors.lightBorder),
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (cat != 'All') ...[
                            Icon(
                              _categoryIcon(cat),
                              size: 13,
                              color: isActive
                                  ? Colors.white
                                  : AppColors.textMuted,
                            ),
                            const SizedBox(width: 5),
                          ],
                          Text(
                            cat,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isActive
                                  ? Colors.white
                                  : AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 28),

          // ── Skill groups ────────────────────────────────
          ...categoriesToShow.asMap().entries.map((entry) {
            final idx = entry.key;
            final cat = entry.value;
            final catSkills = PortfolioData.skills
                .where((s) => s.category == cat)
                .toList();
            if (catSkills.isEmpty) return const SizedBox.shrink();

            return FadeInUp(
              duration: const Duration(milliseconds: 350),
              delay: Duration(milliseconds: idx * 80),
              child: _SkillCategoryCard(
                category: cat,
                categoryColor: _categoryColor(cat),
                categoryIcon: _categoryIcon(cat),
                skills: catSkills,
                isDark: isDark,
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ── CATEGORY CARD ────────────────────────────────────────────
class _SkillCategoryCard extends StatelessWidget {
  final String category;
  final Color categoryColor;
  final IconData categoryIcon;
  final List<dynamic> skills;
  final bool isDark;

  const _SkillCategoryCard({
    required this.category,
    required this.categoryColor,
    required this.categoryIcon,
    required this.skills,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category header row
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(categoryIcon, size: 16, color: categoryColor),
              ),
              const SizedBox(width: 10),
              Text(
                category,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.4,
                    ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${skills.length}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: categoryColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Skill chips wrap
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills
                .map((s) => _SkillChip(
                      name: s.name,
                      accentColor: categoryColor,
                      isDark: isDark,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

// ── SKILL CHIP ───────────────────────────────────────────────
class _SkillChip extends StatelessWidget {
  final String name;
  final Color accentColor;
  final bool isDark;

  const _SkillChip({
    required this.name,
    required this.accentColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: accentColor.withOpacity(0.25),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: accentColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 7),
          Text(
            name,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? Colors.white.withOpacity(0.88)
                  : Colors.black.withOpacity(0.75),
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}