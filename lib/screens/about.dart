import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_theme.dart';
import '../../data/portfolio_data.dart';
import '../../widgets/section_header.dart';

class AboutSection extends StatelessWidget {
  final VoidCallback onAvatarTap;
  const AboutSection({super.key, required this.onAvatarTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── HEADER ROW: Avatar + Name ──────────────────────
          FadeInDown(
            duration: const Duration(milliseconds: 350),
            child: Row(
              children: [
                GestureDetector(
                  onTap: onAvatarTap,
                  child: Container(
                    width: 78,
                    height: 78,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/avatar.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 18),
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

          const SizedBox(height: 22),

          // ── TITLE (gradient) ───────────────────────────────
          FadeInLeft(
            duration: const Duration(milliseconds: 350),
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [AppColors.primary, AppColors.accent],
              ).createShader(bounds),
              child: Text(
                PortfolioData.title,
                style: Theme.of(context)
                    .textTheme
                    .displayMedium
                    ?.copyWith(color: Colors.white),
              ),
            ),
          ),

          const SizedBox(height: 6),

          // ── TAGLINE ────────────────────────────────────────
          FadeInLeft(
            duration: const Duration(milliseconds: 350),
            child: Text(
              PortfolioData.tagline,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),

          const SizedBox(height: 18),

          // ── BIO ────────────────────────────────────────────
          FadeInUp(
            duration: const Duration(milliseconds: 350),
            child: Text(
              PortfolioData.bio,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),

          const SizedBox(height: 26),

          // ── SOCIAL BUTTONS ─────────────────────────────────
          FadeInUp(
            duration: const Duration(milliseconds: 350),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _SocialBtn(
                  label: 'LinkedIn',
                  icon: Icons.link_rounded,
                  onTap: () => _launch(PortfolioData.linkedin),
                  color: const Color(0xFF0077B5),
                ),
                _SocialBtn(
                  label: 'GitHub',
                  icon: Icons.code_rounded,
                  onTap: () => _launch(PortfolioData.github),
                  color: isDark ? Colors.white : const Color(0xFF333333),
                ),
                _SocialBtn(
                  label: 'Email',
                  icon: Icons.mail_outline_rounded,
                  onTap: () => _launch('mailto:${PortfolioData.email}'),
                  color: AppColors.primary,
                ),
              ],
            ),
          ),

          const SizedBox(height: 34),

          // ── EDUCATION ──────────────────────────────────────
          FadeInUp(
            duration: const Duration(milliseconds: 350),
            child: const SectionHeader(title: 'Education'),
          ),
          const SizedBox(height: 12),
          FadeInUp(
            duration: const Duration(milliseconds: 400),
            child: _EducationCard(),
          ),

          const SizedBox(height: 30),

          // ── ACHIEVEMENTS ───────────────────────────────────
          FadeInUp(
            duration: const Duration(milliseconds: 350),
            child: const SectionHeader(title: 'Achievements'),
          ),
          const SizedBox(height: 12),
          ...PortfolioData.achievements.asMap().entries.map(
                (e) => FadeInUp(
                  duration: const Duration(milliseconds: 350),
                  delay: Duration(milliseconds: e.key * 40),
                  child: _AchievementItem(text: e.value),
                ),
              ),

          const SizedBox(height: 30),

          // ── CERTIFICATIONS ─────────────────────────────────
          FadeInUp(
            duration: const Duration(milliseconds: 350),
            child: const SectionHeader(title: 'Certifications'),
          ),
          const SizedBox(height: 12),
          ...PortfolioData.certifications.asMap().entries.map(
                (e) => FadeInUp(
                  duration: const Duration(milliseconds: 350),
                  delay: Duration(milliseconds: e.key * 40),
                  child: _CertCard(cert: e.value),
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

// ── SOCIAL BUTTON ────────────────────────────────────────────
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

// ── EDUCATION CARD ───────────────────────────────────────────
class _EducationCard extends StatelessWidget {
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
                child: const Icon(
                  Icons.school_outlined,
                  size: 20,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      PortfolioData.college,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontSize: 14),
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
          Row(
            children: [
              const Icon(Icons.star_rounded,
                  size: 16, color: Color(0xFFFFB800)),
              const SizedBox(width: 4),
              Text(
                'CGPA: ${PortfolioData.cgpa}',
                style: const TextStyle(
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

// ── ACHIEVEMENT ITEM ─────────────────────────────────────────
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
            padding: EdgeInsets.only(top: 3),
            child: Icon(Icons.emoji_events_outlined,
                size: 16, color: Color(0xFFFFB800)),
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

// ── CERTIFICATION CARD ────────────────────────────────────────
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
            child: const Icon(
              Icons.verified_outlined,
              size: 18,
              color: AppColors.accent,
            ),
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
                        color:
                            isDark ? AppColors.textLight : AppColors.textDark,
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