import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../data/portfolio_data.dart';
import '../main.dart';
import '../widgets/section_header.dart';
import '../widgets/chip_tag.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 0,
            floating: true,
            backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
            elevation: 0,
            title: const Text(
              'abhinaya.dev',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                  color: isDark ? AppColors.textMuted : const Color(0xFF888899),
                ),
                onPressed: () => PortfolioApp.of(context)?.toggleTheme(),
              ),
              const SizedBox(width: 8),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // Avatar + greeting
                  FadeInDown(
                    duration: const Duration(milliseconds: 600),
                    child: Row(
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.primary, AppColors.accent],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(
                            child: Text(
                              'AB',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello, I\'m 👋',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              PortfolioData.name,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Title with gradient text
                  FadeInLeft(
                    delay: const Duration(milliseconds: 200),
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [AppColors.primary, AppColors.accent],
                      ).createShader(bounds),
                      child: Text(
                        PortfolioData.title,
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  FadeInLeft(
                    delay: const Duration(milliseconds: 300),
                    child: Text(
                      PortfolioData.tagline,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Bio
                  FadeInUp(
                    delay: const Duration(milliseconds: 400),
                    child: Text(
                      PortfolioData.bio,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Social links
                  FadeInUp(
                    delay: const Duration(milliseconds: 500),
                    child: Row(
                      children: [
                        _SocialBtn(
                          label: 'LinkedIn',
                          icon: Icons.link_rounded,
                          onTap: () => _launch(PortfolioData.linkedin),
                          color: const Color(0xFF0077B5),
                        ),
                        const SizedBox(width: 12),
                        _SocialBtn(
                          label: 'GitHub',
                          icon: Icons.code_rounded,
                          onTap: () => _launch(PortfolioData.github),
                          color: isDark ? Colors.white : const Color(0xFF333333),
                        ),
                        const SizedBox(width: 12),
                        _SocialBtn(
                          label: 'Email',
                          icon: Icons.mail_outline_rounded,
                          onTap: () => _launch('mailto:${PortfolioData.email}'),
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 36),

                  // Education card
                  FadeInUp(
                    delay: const Duration(milliseconds: 600),
                    child: const SectionHeader(title: 'Education'),
                  ),
                  const SizedBox(height: 12),
                  FadeInUp(
                    delay: const Duration(milliseconds: 700),
                    child: _EducationCard(context: context),
                  ),

                  const SizedBox(height: 32),

                  // Achievements
                  FadeInUp(
                    delay: const Duration(milliseconds: 700),
                    child: const SectionHeader(title: 'Achievements'),
                  ),
                  const SizedBox(height: 12),
                  ...PortfolioData.achievements.asMap().entries.map(
                    (e) => FadeInUp(
                      delay: Duration(milliseconds: 750 + e.key * 80),
                      child: _AchievementItem(text: e.value),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Certifications
                  FadeInUp(
                    child: const SectionHeader(title: 'Certifications'),
                  ),
                  const SizedBox(height: 12),
                  ...PortfolioData.certifications.map(
                    (c) => FadeInUp(
                      child: _CertCard(cert: c),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _SocialBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const _SocialBtn({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: color.withValues(alpha: 0.4)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EducationCard extends StatelessWidget {
  final BuildContext context;
  const _EducationCard({required this.context});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.school_outlined, size: 20, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      PortfolioData.college,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15),
                    ),
                    Text(
                      PortfolioData.collegeDuration,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            PortfolioData.degree,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textLight : AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(Icons.star_rounded, size: 16, color: Color(0xFFFFB800)),
              SizedBox(width: 4),
              Text(
                'CGPA: ${PortfolioData.cgpa}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AchievementItem extends StatelessWidget {
  final String text;
  const _AchievementItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Icon(Icons.emoji_events_outlined, size: 16, color: Color(0xFFFFB800)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}

class _CertCard extends StatelessWidget {
  final Map<String, String> cert;
  const _CertCard({required this.cert});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.verified_outlined, size: 18, color: AppColors.accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cert['title']!,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.textLight : AppColors.textDark,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${cert['org']} · ${cert['date']}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}