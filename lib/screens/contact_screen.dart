import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../theme/app_theme.dart';
import '../../data/portfolio_data.dart';
import '../../widgets/section_header.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _nameCtrl  = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _msgCtrl   = TextEditingController();
  bool _isSending  = false;
  bool _sent       = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final name    = _nameCtrl.text.trim();
    final email   = _emailCtrl.text.trim();
    final message = _msgCtrl.text.trim();

    if (name.isEmpty || email.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }

    setState(() {
      _isSending    = true;
      _errorMessage = null;
    });

    try {
      // Save to 'contact' collection in Firestore
      await FirebaseFirestore.instance.collection('contact').add({
        'name'      : name,
        'email'     : email,
        'message'   : message,
        'timestamp' : FieldValue.serverTimestamp(),
        'read'      : false,
      });

      setState(() {
        _isSending = false;
        _sent      = true;
      });
    } on FirebaseException catch (e) {
      setState(() {
        _isSending    = false;
        _errorMessage = 'Failed to send: ${e.message ?? 'Please try again.'}';
      });
    } catch (e) {
      setState(() {
        _isSending    = false;
        _errorMessage = 'Something went wrong. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Contact'),
          const SizedBox(height: 10),
          FadeInDown(
            duration: const Duration(milliseconds: 350),
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [AppColors.primary, AppColors.accent],
              ).createShader(bounds),
              child: Text(
                "Let's connect!",
                style: Theme.of(context)
                    .textTheme
                    .displayMedium
                    ?.copyWith(fontSize: 30, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 8),
          FadeInDown(
            duration: const Duration(milliseconds: 350),
            child: Text(
              "I'm open to opportunities, collaborations, and interesting conversations.",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 28),

          FadeInUp(
            duration: const Duration(milliseconds: 350),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _ContactChip(
                  icon: Icons.mail_outline_rounded,
                  label: PortfolioData.email,
                  onTap: () => _launch('mailto:${PortfolioData.email}'),
                ),
                _ContactChip(
                  icon: Icons.phone_outlined,
                  label: PortfolioData.phone,
                  onTap: () => _launch('tel:${PortfolioData.phone}'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          FadeInUp(
            duration: const Duration(milliseconds: 350),
            child: Row(
              children: [
                _SocialTile(
                  icon: Icons.link_rounded,
                  label: 'LinkedIn',
                  color: const Color(0xFF0077B5),
                  onTap: () => _launch(PortfolioData.linkedin),
                ),
                const SizedBox(width: 12),
                _SocialTile(
                  icon: Icons.code_rounded,
                  label: 'GitHub',
                  color: isDark ? Colors.white : const Color(0xFF333333),
                  onTap: () => _launch(PortfolioData.github),
                ),
              ],
            ),
          ),
          const SizedBox(height: 36),

          if (_errorMessage != null)
            FadeInUp(
              duration: const Duration(milliseconds: 300),
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline_rounded,
                        color: Colors.red, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(_errorMessage!,
                          style: const TextStyle(
                              color: Colors.red, fontSize: 13)),
                    ),
                  ],
                ),
              ),
            ),

          if (_sent)
            FadeInUp(
              duration: const Duration(milliseconds: 350),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: AppColors.accent.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline_rounded,
                        color: AppColors.accent, size: 28),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Message sent! 🎉',
                              style: Theme.of(context).textTheme.titleLarge),
                          Text("I'll get back to you shortly.",
                              style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            FadeInUp(
              duration: const Duration(milliseconds: 350),
              child: Text('Send a message',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontSize: 18)),
            ),
            const SizedBox(height: 16),
            FadeInUp(
              duration: const Duration(milliseconds: 350),
              child: _InputField(
                controller: _nameCtrl,
                label: 'Your name',
                icon: Icons.person_outline_rounded,
                isDark: isDark,
              ),
            ),
            const SizedBox(height: 12),
            FadeInUp(
              duration: const Duration(milliseconds: 350),
              child: _InputField(
                controller: _emailCtrl,
                label: 'Email address',
                icon: Icons.mail_outline_rounded,
                isDark: isDark,
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            const SizedBox(height: 12),
            FadeInUp(
              duration: const Duration(milliseconds: 350),
              child: _InputField(
                controller: _msgCtrl,
                label: 'Message',
                icon: Icons.chat_bubble_outline_rounded,
                isDark: isDark,
                maxLines: 5,
              ),
            ),
            const SizedBox(height: 20),
            FadeInUp(
              duration: const Duration(milliseconds: 350),
              child: SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: _isSending ? null : _send,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _isSending
                            ? [
                                AppColors.primary.withValues(alpha: 0.5),
                                AppColors.accent.withValues(alpha: 0.5),
                              ]
                            : [AppColors.primary, AppColors.accent],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Center(
                      child: _isSending
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              ),
                            )
                          : const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.send_rounded,
                                    size: 18, color: Colors.white),
                                SizedBox(width: 8),
                                Text('Send Message',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    )),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ],

          const SizedBox(height: 32),
          FadeInUp(
            duration: const Duration(milliseconds: 350),
            child: Center(
              child: Text(
                '✨ Designed & built by Abhinaya B',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) launchUrl(uri);
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isDark;
  final TextInputType? keyboardType;
  final int maxLines;

  const _InputField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.isDark,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 0.5,
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: TextStyle(
          color: isDark ? AppColors.textLight : AppColors.textDark,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, size: 18, color: AppColors.textMuted),
          labelText: label,
          labelStyle:
              const TextStyle(color: AppColors.textMuted, fontSize: 14),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}

class _ContactChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ContactChip(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(label,
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

class _SocialTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _SocialTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.lightCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: color.withValues(alpha: 0.3), width: 0.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(label,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: color)),
            ],
          ),
        ),
      ),
    );
  }
}