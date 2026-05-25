import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../../theme/app_theme.dart';
import '../../data/portfolio_data.dart';
import '../../widgets/section_header.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final experiences = PortfolioData.experience;

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 28, 0, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SectionHeader(title: 'Experience'),
          ),
          const SizedBox(height: 16),
          ...experiences.asMap().entries.map((e) {
            final idx = e.key;
            final exp = e.value;
            return FadeInLeft(
              duration: const Duration(milliseconds: 350),
              delay: Duration(milliseconds: idx * 50),
              child: TimelineTile(
                alignment: TimelineAlign.manual,
                lineXY: 0.15,
                isFirst: idx == 0,
                isLast: idx == experiences.length - 1,
                indicatorStyle: IndicatorStyle(
                  width: 20,
                  height: 20,
                  indicator: Container(
                    decoration: BoxDecoration(
                      color: idx == 0
                          ? AppColors.primary
                          : (isDark ? AppColors.darkCard : AppColors.lightCard),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary,
                        width: idx == 0 ? 0 : 2,
                      ),
                    ),
                    child: idx == 0
                        ? const Icon(Icons.star_rounded,
                            size: 12, color: Colors.white)
                        : null,
                  ),
                ),
                beforeLineStyle: LineStyle(
                  color: AppColors.primary.withOpacity(0.3),
                  thickness: 2,
                ),
                afterLineStyle: LineStyle(
                  color: AppColors.primary.withOpacity(0.3),
                  thickness: 2,
                ),
                startChild: const SizedBox(width: 24),
                endChild: Container(
                  margin: const EdgeInsets.fromLTRB(12, 8, 20, 8),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkCard
                        : AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: idx == 0
                          ? AppColors.primary.withOpacity(0.4)
                          : (isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder),
                      width: idx == 0 ? 1.0 : 0.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // "Current" badge for first item
                      if (idx == 0)
                        Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Current',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),

                      Text(
                        exp.role,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.business_outlined,
                              size: 14, color: AppColors.accent),
                          const SizedBox(width: 4),
                          Text(
                            exp.company,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.accent,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined,
                              size: 12, color: AppColors.textMuted),
                          const SizedBox(width: 4),
                          Text(
                            exp.duration,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        exp.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}