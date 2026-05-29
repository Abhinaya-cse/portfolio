import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_widgets.dart';
import '../data/portfolio_data.dart';

class AboutSection extends StatelessWidget {
  final VoidCallback onAvatarTap;
  const AboutSection({super.key, required this.onAvatarTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── HERO ────────────────────────────────────────
          const SizedBox(height: 24),

          // Eyebrow
          FadeInDown(
            duration: const Duration(milliseconds: 600),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 1,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, AppColors.cyan],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'AVAILABLE FOR OPPORTUNITIES',
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.4,
                    color: AppColors.cyan,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Name
          FadeInUp(
            duration: const Duration(milliseconds: 700),
            delay: const Duration(milliseconds: 100),
            child: GestureDetector(
              onTap: onAvatarTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello, I'm 👋",
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: AppColors.muted,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        AppColors.white,
                        Color(0xB3FFFFFF),
                        Color(0x66FFFFFF),
                      ],
                      stops: [0, 0.5, 1],
                    ).createShader(bounds),
                    child: Text(
                      PortfolioData.name,
                      style: GoogleFonts.syne(
                        fontSize: 44,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -2.0,
                        height: 0.95,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Role with animated gradient
          FadeInUp(
            duration: const Duration(milliseconds: 700),
            delay: const Duration(milliseconds: 200),
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [AppColors.violet, AppColors.cyan, AppColors.gold],
                stops: [0, 0.55, 1],
              ).createShader(bounds),
              child: Text(
                PortfolioData.title,
                style: GoogleFonts.syne(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.8,
                  height: 1.1,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Tagline
          FadeInUp(
            duration: const Duration(milliseconds: 700),
            delay: const Duration(milliseconds: 300),
            child: Text(
              'Building production-grade Flutter apps with Firebase — from real-time CRM systems to smart distribution platforms. CS graduate passionate about clean code and impactful products.',
              style: GoogleFonts.outfit(
                fontSize: 13.5,
                color: AppColors.muted,
                height: 1.85,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // CTA buttons
          FadeInUp(
            duration: const Duration(milliseconds: 700),
            delay: const Duration(milliseconds: 400),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _CtaBtn(
                  label: "Let's Connect",
                  isPrimary: true,
                  onTap: () => _launch('mailto:${PortfolioData.email}'),
                ),
                _CtaBtn(
                  label: 'View GitHub',
                  isPrimary: false,
                  onTap: () => _launch(PortfolioData.github),
                ),
              ],
            ),
          ),

          const SizedBox(height: 48),

          // ── ABOUT SECTION ────────────────────────────────
          FadeInUp(
            duration: const Duration(milliseconds: 500),
            child: const SectionEyebrow('About Me'),
          ),
          const SizedBox(height: 8),
          FadeInUp(
            duration: const Duration(milliseconds: 500),
            delay: const Duration(milliseconds: 50),
            child: const SectionTitle('Who I Am'),
          ),
          const SizedBox(height: 28),

          // Bio card (full width)
          FadeInUp(
            duration: const Duration(milliseconds: 500),
            delay: const Duration(milliseconds: 100),
            child: GlassCard(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: const Color(0xA6FFFFFF),
                        height: 1.9,
                        fontWeight: FontWeight.w300,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Computer Science graduate with hands-on industry experience as a ',
                        ),
                        TextSpan(
                          text: 'Software Developer at Antano & Harini',
                          style: GoogleFonts.outfit(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const TextSpan(
                          text:
                              ', where I built and delivered production-grade Flutter mobile apps integrated with Firebase. Strong technical foundation, problem-solving aptitude, and a team-oriented professional committed to continuous learning.',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _SocialPill(
                        label: 'LinkedIn',
                        onTap: () => _launch(PortfolioData.linkedin),
                        borderColor: const Color(0x660077B5),
                        color: const Color(0xFF0077B5),
                        bg: const Color(0x140077B5),
                      ),
                      _SocialPill(
                        label: 'GitHub',
                        onTap: () => _launch(PortfolioData.github),
                        borderColor: AppColors.glassBorder,
                        color: const Color(0xCCFFFFFF),
                        bg: AppColors.glass,
                      ),
                      _SocialPill(
                        label: 'Email Me',
                        onTap: () => _launch('mailto:${PortfolioData.email}'),
                        borderColor: AppColors.violetGlow,
                        color: AppColors.violet,
                        bg: const Color(0x147C5CFC),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Education + Stats row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Education card
              Expanded(
                flex: 3,
                child: FadeInUp(
                  duration: const Duration(milliseconds: 500),
                  delay: const Duration(milliseconds: 150),
                  child: GlassCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0x1A7C5CFC),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text('🎓', style: TextStyle(fontSize: 18)),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'EDUCATION',
                          style: GoogleFonts.outfit(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                            color: AppColors.muted,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          PortfolioData.college,
                          style: GoogleFonts.outfit(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${PortfolioData.degree}\n${PortfolioData.collegeDuration}',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            color: AppColors.muted,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0x26F5C542),
                                Color(0x0DF5C542),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                                color: const Color(0x4DF5C542), width: 1),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('⭐',
                                  style: TextStyle(fontSize: 11)),
                              const SizedBox(width: 5),
                              Text(
                                'CGPA ${PortfolioData.cgpa}',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.gold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Stats card
              Expanded(
                flex: 2,
                child: FadeInUp(
                  duration: const Duration(milliseconds: 500),
                  delay: const Duration(milliseconds: 200),
                  child: GlassCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _StatItem(
                          value: '4',
                          label: 'Projects',
                          gradient: const LinearGradient(
                              colors: [AppColors.violet, AppColors.cyan]),
                          hasBorder: true,
                        ),
                        _StatItem(
                          value: '5',
                          label: 'Internships',
                          gradient: const LinearGradient(
                              colors: [AppColors.cyan, AppColors.gold]),
                          hasBorder: true,
                        ),
                        _StatItem(
                          value: '10+',
                          label: 'Skills',
                          gradient: const LinearGradient(
                              colors: [AppColors.gold, AppColors.coral]),
                          hasBorder: false,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Certifications
          FadeInUp(
            duration: const Duration(milliseconds: 500),
            delay: const Duration(milliseconds: 250),
            child: GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0x1A00E5D4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                            child:
                                Text('🛡', style: TextStyle(fontSize: 18))),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'CERTIFICATIONS',
                        style: GoogleFonts.outfit(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...PortfolioData.certifications.map(
                    (c) => _CertRow(cert: c),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 28),

          // Achievements
          FadeInUp(
            duration: const Duration(milliseconds: 500),
            child: const SectionEyebrow('Achievements'),
          ),
          const SizedBox(height: 16),
          ...PortfolioData.achievements.asMap().entries.map(
            (e) => FadeInUp(
              duration: const Duration(milliseconds: 400),
              delay: Duration(milliseconds: e.key * 60),
              child: _AchievementRow(
                  index: e.key + 1, text: e.value),
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

// ── CTA BUTTON ────────────────────────────────────────────────
class _CtaBtn extends StatelessWidget {
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;
  const _CtaBtn(
      {required this.label, required this.isPrimary, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        decoration: BoxDecoration(
          gradient: isPrimary
              ? const LinearGradient(
                  colors: [AppColors.violet, AppColors.purple])
              : null,
          color: isPrimary ? null : AppColors.glass,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: isPrimary
                ? AppColors.violetGlow
                : AppColors.glassBorder,
          ),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: AppColors.violetGlow,
                    blurRadius: 28,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isPrimary ? Colors.white : const Color(0xBFFFFFFF),
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}

// ── SOCIAL PILL ───────────────────────────────────────────────
class _SocialPill extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color color, bg, borderColor;
  const _SocialPill({
    required this.label,
    required this.onTap,
    required this.color,
    required this.bg,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: borderColor),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ),
    );
  }
}

// ── STAT ITEM ─────────────────────────────────────────────────
class _StatItem extends StatelessWidget {
  final String value, label;
  final Gradient gradient;
  final bool hasBorder;
  const _StatItem({
    required this.value,
    required this.label,
    required this.gradient,
    required this.hasBorder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: hasBorder
          ? const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.border),
              ),
            )
          : null,
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (b) => gradient.createShader(b),
            child: Text(
              value,
              style: GoogleFonts.syne(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 10,
              color: AppColors.muted,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ── CERT ROW ──────────────────────────────────────────────────
class _CertRow extends StatelessWidget {
  final Map<String, String> cert;
  const _CertRow({required this.cert});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.glass,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0x2600E5D4), Color(0x0D00E5D4)],
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0x4000E5D4)),
            ),
            child: const Center(
                child: Text('✓',
                    style: TextStyle(
                        color: AppColors.cyan,
                        fontSize: 16,
                        fontWeight: FontWeight.w700))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cert['title']!,
                  style: GoogleFonts.outfit(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${cert['org']} · ${cert['date']}',
                  style: GoogleFonts.outfit(
                      fontSize: 11, color: AppColors.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── ACHIEVEMENT ROW ───────────────────────────────────────────
class _AchievementRow extends StatelessWidget {
  final int index;
  final String text;
  const _AchievementRow({required this.index, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.glass,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShaderMask(
            shaderCallback: (b) => const LinearGradient(
              colors: [AppColors.violet, AppColors.cyan],
            ).createShader(b),
            child: Text(
              index.toString().padLeft(2, '0'),
              style: GoogleFonts.syne(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1.1,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                text,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: const Color(0xA6FFFFFF),
                  height: 1.65,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
