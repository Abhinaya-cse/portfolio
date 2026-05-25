import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:percent_indicator/percent_indicator.dart';
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filtered = _selectedCategory == 'All'
        ? PortfolioData.skills
        : PortfolioData.skills
            .where((s) => s.category == _selectedCategory)
            .toList();

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
                          horizontal: 16, vertical: 8),
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
                      child: Text(
                        cat,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isActive
                              ? Colors.white
                              : AppColors.textMuted,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 28),

          // ── Top 3 circular skills (All view only) ───────
          if (_selectedCategory == 'All') ...[
            FadeInUp(
              duration: const Duration(milliseconds: 350),
              child: Text(
                'Top Skills',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),
            FadeInUp(
              duration: const Duration(milliseconds: 400),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: PortfolioData.skills
                    .take(3)
                    .map((s) => _CircularSkill(skill: s))
                    .toList(),
              ),
            ),
            const SizedBox(height: 32),
            FadeInUp(
              duration: const Duration(milliseconds: 350),
              child: Text(
                'All Skills',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // ── Skill bars ──────────────────────────────────
          ...filtered.asMap().entries.map(
                (e) => FadeInLeft(
                  duration: const Duration(milliseconds: 350),
                  delay: Duration(milliseconds: e.key * 40),
                  child: _SkillBar(skill: e.value),
                ),
              ),
        ],
      ),
    );
  }
}

// ── CIRCULAR SKILL ───────────────────────────────────────────
class _CircularSkill extends StatelessWidget {
  final dynamic skill;
  const _CircularSkill({required this.skill});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 48,
          lineWidth: 7,
          percent: skill.level,
          center: Text(
            '${(skill.level * 100).round()}%',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          progressColor: AppColors.primary,
          backgroundColor: AppColors.primary.withOpacity(0.1),
          animation: true,
          animationDuration: 900,
          circularStrokeCap: CircularStrokeCap.round,
        ),
        const SizedBox(height: 8),
        Text(skill.name, style: Theme.of(context).textTheme.labelLarge),
      ],
    );
  }
}

// ── SKILL BAR ────────────────────────────────────────────────
class _SkillBar extends StatelessWidget {
  final dynamic skill;
  const _SkillBar({required this.skill});

  Color get _barColor {
    if (skill.level >= 0.85) return AppColors.accent;
    if (skill.level >= 0.75) return AppColors.primary;
    return const Color(0xFFFF7043);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                skill.name,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: 15),
              ),
              Text(
                '${(skill.level * 100).round()}%',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _barColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          LinearPercentIndicator(
            padding: EdgeInsets.zero,
            lineHeight: 8,
            percent: skill.level,
            progressColor: _barColor,
            backgroundColor: _barColor.withOpacity(0.1),
            barRadius: const Radius.circular(8),
            animation: true,
            animationDuration: 900,
          ),
          const SizedBox(height: 6),
          Text(
            skill.category,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }
}