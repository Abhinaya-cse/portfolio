import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../main.dart';
import 'about.dart';
import 'project_screen.dart';
import 'skills_screen.dart';
import 'experience_screen.dart';
import 'contact_screen.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final _scrollController = ScrollController();
  int _activeIndex = 0;
  bool _isUserScrolling = false;

  // Secret admin tap
  int _secretTapCount = 0;
  DateTime? _lastTapTime;

  // One key per section to detect which is in view
  final List<GlobalKey> _sectionKeys = List.generate(5, (_) => GlobalKey());

  static const _navItems = [
    _NavMeta(Icons.person_outline_rounded, 'About'),
    _NavMeta(Icons.grid_view_rounded, 'Projects'),
    _NavMeta(Icons.bolt_rounded, 'Skills'),
    _NavMeta(Icons.work_outline_rounded, 'Experience'),
    _NavMeta(Icons.mail_outline_rounded, 'Contact'),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // ── Detect which section is in the viewport center ──────────
  void _onScroll() {
    if (_isUserScrolling) return; // skip during programmatic scroll
    final screenH = MediaQuery.of(context).size.height;
    for (int i = _sectionKeys.length - 1; i >= 0; i--) {
      final ctx = _sectionKeys[i].currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null) continue;
      final pos = box.localToGlobal(Offset.zero);
      if (pos.dy <= screenH * 0.45) {
        if (_activeIndex != i) setState(() => _activeIndex = i);
        break;
      }
    }
  }

  // ── Smooth scroll to section ─────────────────────────────────
  Future<void> _scrollToSection(int index) async {
    final ctx = _sectionKeys[index].currentContext;
    if (ctx == null) return;
    setState(() {
      _activeIndex = index;
      _isUserScrolling = true;
    });
    await Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 550),
      curve: Curves.easeInOutCubic,
      alignment: 0.0,
    );
    setState(() => _isUserScrolling = false);
  }

  // ── Secret tap handler (5 taps → admin) ──────────────────────
  void _onAvatarTap() {
    final now = DateTime.now();
    if (_lastTapTime == null ||
        now.difference(_lastTapTime!) > const Duration(seconds: 2)) {
      _secretTapCount = 1;
    } else {
      _secretTapCount++;
    }
    _lastTapTime = now;
    if (_secretTapCount >= 5) {
      _secretTapCount = 0;
      Navigator.pushNamed(context, '/admin');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── App Bar ────────────────────────────────────
            SliverAppBar(
              backgroundColor:
                  isDark ? AppColors.darkBg : AppColors.lightBg,
              elevation: 0,
              floating: true,
              snap: true,
              titleSpacing: 20,
              title: Row(
                children: [
                  // Logo dot
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'abhinaya.dev',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              actions: [
                // Theme toggle
                GestureDetector(
                  onTap: () => PortfolioApp.of(context)?.toggleTheme(),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 16),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkCard
                          : AppColors.lightCard,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder,
                        width: 0.5,
                      ),
                    ),
                    child: Icon(
                      isDark
                          ? Icons.light_mode_outlined
                          : Icons.dark_mode_outlined,
                      size: 18,
                      color: isDark
                          ? AppColors.textMuted
                          : const Color(0xFF888899),
                    ),
                  ),
                ),
              ],
            ),

            // ── All Sections (single continuous scroll) ────
            SliverToBoxAdapter(
              child: Column(
                children: [
                  // ABOUT
                  KeyedSubtree(
                    key: _sectionKeys[0],
                    child: AboutSection(onAvatarTap: _onAvatarTap),
                  ),
                  _Divider(),

                  // PROJECTS
                  KeyedSubtree(
                    key: _sectionKeys[1],
                    child: const ProjectsSection(),
                  ),
                  _Divider(),

                  // SKILLS
                  KeyedSubtree(
                    key: _sectionKeys[2],
                    child: const SkillsSection(),
                  ),
                  _Divider(),

                  // EXPERIENCE
                  KeyedSubtree(
                    key: _sectionKeys[3],
                    child: const ExperienceSection(),
                  ),
                  _Divider(),

                  // CONTACT
                  KeyedSubtree(
                    key: _sectionKeys[4],
                    child: const ContactSection(),
                  ),

                  // Bottom padding for nav bar
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),

        // ── Bottom Navigation Bar ───────────────────────────
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: bg,
            border: Border(top: BorderSide(color: border, width: 0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  _navItems.length,
                  (i) => _NavItem(
                    icon: _navItems[i].icon,
                    label: _navItems[i].label,
                    index: i,
                    current: _activeIndex,
                    onTap: _scrollToSection,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── SECTION DIVIDER ──────────────────────────────────────────
class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      height: 0.5,
      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
    );
  }
}

// ── NAV META ─────────────────────────────────────────────────
class _NavMeta {
  final IconData icon;
  final String label;
  const _NavMeta(this.icon, this.label);
}

// ── NAV ITEM ─────────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int current;
  final Future<void> Function(int) onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == current;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                icon,
                key: ValueKey(isActive),
                size: 22,
                color: isActive ? AppColors.primary : AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight:
                    isActive ? FontWeight.w600 : FontWeight.w400,
                color:
                    isActive ? AppColors.primary : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}