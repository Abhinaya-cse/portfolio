import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_widgets.dart';
import '../data/portfolio_data.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  void _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInUp(child: const SectionEyebrow('Get in Touch')),
          const SizedBox(height: 8),
          FadeInUp(
            delay: const Duration(milliseconds: 60),
            child: const SectionTitle('Contact'),
          ),
          const SizedBox(height: 20),

          // Intro
          FadeInUp(
            delay: const Duration(milliseconds: 100),
            child: Text(
              "I'm currently open to new opportunities and collaborations. Whether you have a project in mind, a question, or just want to say hello — let's talk.",
              style: GoogleFonts.outfit(
                fontSize: 13.5,
                color: AppColors.muted,
                height: 1.85,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Contact link cards
          ..._contactItems.asMap().entries.map(
            (e) => FadeInLeft(
              duration: const Duration(milliseconds: 400),
              delay: Duration(milliseconds: 100 + e.key * 60),
              child: _ContactLinkCard(item: e.value, onTap: _launch),
            ),
          ),

          const SizedBox(height: 16),

          // Glow box — "Open to Work"
          FadeInUp(
            delay: const Duration(milliseconds: 350),
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.glass,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: Stack(
                children: [
                  // Glow blob
                  Positioned(
                    top: -40,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppColors.violet.withValues(alpha: 0.2),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      const Text('✨',
                          style: TextStyle(fontSize: 40)),
                      const SizedBox(height: 14),
                      Text(
                        'Open to Work',
                        style: GoogleFonts.syne(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                          color: AppColors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Looking for full-time Flutter / mobile development roles. Available immediately for the right opportunity.',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          color: AppColors.muted,
                          height: 1.7,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: () =>
                            _launch('mailto:${PortfolioData.email}'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 28, vertical: 14),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.violet, AppColors.purple],
                            ),
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.violetGlow,
                                blurRadius: 32,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            'Send a Message',
                            style: GoogleFonts.outfit(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  static final _contactItems = [
    _ContactItem(
      label: 'Email',
      value: 'abhinaya03.b@gmail.com',
      url: 'mailto:${PortfolioData.email}',
      iconBg: const Color(0x1A7C5CFC),
      iconColor: AppColors.violet,
      emoji: '✉️',
    ),
    _ContactItem(
      label: 'Phone',
      value: PortfolioData.phone,
      url: 'tel:${PortfolioData.phone}',
      iconBg: const Color(0x1A00E5D4),
      iconColor: AppColors.cyan,
      emoji: '📞',
    ),
    _ContactItem(
      label: 'LinkedIn',
      value: 'abhinaya03b',
      url: PortfolioData.linkedin,
      iconBg: const Color(0x1A0077B5),
      iconColor: Color(0xFF0095D5),
      emoji: '💼',
    ),
    _ContactItem(
      label: 'GitHub',
      value: 'Abhinaya-cse',
      url: PortfolioData.github,
      iconBg: Color(0x0DFFFFFF),
      iconColor: Color(0xCCFFFFFF),
      emoji: '⌨️',
    ),
  ];
}

class _ContactItem {
  final String label, value, url, emoji;
  final Color iconBg, iconColor;
  const _ContactItem({
    required this.label,
    required this.value,
    required this.url,
    required this.iconBg,
    required this.iconColor,
    required this.emoji,
  });
}

class _ContactLinkCard extends StatelessWidget {
  final _ContactItem item;
  final void Function(String) onTap;
  const _ContactLinkCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(item.url),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.glass,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: item.iconBg,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Center(
                child:
                    Text(item.emoji, style: const TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label.toUpperCase(),
                  style: GoogleFonts.outfit(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: AppColors.muted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.value,
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Text('→',
                style: TextStyle(color: AppColors.muted, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
