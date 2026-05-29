import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'orb_background.dart';
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
  bool _navScrolled = false;

  int _secretTapCount = 0;
  DateTime? _lastTapTime;

  final List<GlobalKey> _sectionKeys = List.generate(5, (_) => GlobalKey());

  static const _navLabels = ['About', 'Projects', 'Skills', 'Exp.', 'Contact'];

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

  void _onScroll() {
    final scrolled = _scrollController.offset > 60;
    if (scrolled != _navScrolled) setState(() => _navScrolled = scrolled);

    if (_isUserScrolling) return;
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

  Future<void> _scrollToSection(int index) async {
    final ctx = _sectionKeys[index].currentContext;
    if (ctx == null) return;
    setState(() {
      _activeIndex = index;
      _isUserScrolling = true;
    });
    await Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      alignment: 0.0,
    );
    setState(() => _isUserScrolling = false);
  }

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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.void_bg,
        body: OrbBackground(
          child: Column(
            children: [
              // ── Top Nav ─────────────────────────────────
              SafeArea(
                bottom: false,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: EdgeInsets.fromLTRB(
                    20,
                    _navScrolled ? 12 : 16,
                    16,
                    _navScrolled ? 12 : 10,
                  ),
                  decoration: BoxDecoration(
                    color: _navScrolled
                        ? const Color(0xD904040A)
                        : Colors.transparent,
                    border: _navScrolled
                        ? const Border(
                            bottom: BorderSide(color: AppColors.border))
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // ── Row 1: Logo ──────────────────────
                      Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.syne(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.3,
                              ),
                              children: [
                                const TextSpan(
                                  text: 'abhinaya',
                                  style: TextStyle(color: AppColors.white),
                                ),
                                TextSpan(
                                  text: '.',
                                  style: GoogleFonts.syne(
                                      color: AppColors.violet, fontSize: 16),
                                ),
                                const TextSpan(
                                  text: 'dev',
                                  style: TextStyle(color: AppColors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // ── Row 2: Pill nav ──────────────────
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.glass,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.glassBorder),
                        ),
                        padding: const EdgeInsets.all(3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(_navLabels.length, (i) {
                            final isActive = i == _activeIndex;
                            return GestureDetector(
                              onTap: () => _scrollToSection(i),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  gradient: isActive
                                      ? const LinearGradient(
                                          colors: [
                                            AppColors.violet,
                                            AppColors.purple
                                          ],
                                        )
                                      : null,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  _navLabels[i],
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: isActive
                                        ? Colors.white
                                        : AppColors.muted,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Scrollable content ───────────────────────
              Expanded(
                child: CustomScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          KeyedSubtree(
                            key: _sectionKeys[0],
                            child: AboutSection(onAvatarTap: _onAvatarTap),
                          ),
                          const _SectionDivider(),
                          KeyedSubtree(
                            key: _sectionKeys[1],
                            child: const ProjectsSection(),
                          ),
                          const _SectionDivider(),
                          KeyedSubtree(
                            key: _sectionKeys[2],
                            child: const SkillsSection(),
                          ),
                          const _SectionDivider(),
                          KeyedSubtree(
                            key: _sectionKeys[3],
                            child: const ExperienceSection(),
                          ),
                          const _SectionDivider(),
                          KeyedSubtree(
                            key: _sectionKeys[4],
                            child: const ContactSection(),
                          ),
                          // Footer
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 28),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ShaderMask(
                                  shaderCallback: (b) =>
                                      const LinearGradient(colors: [
                                    AppColors.violet,
                                    AppColors.cyan,
                                  ]).createShader(b),
                                  child: Text(
                                    'abhinaya.dev',
                                    style: GoogleFonts.syne(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  ),
                                ),
                                Text(
                                  'Designed with ♥ · 2025',
                                  style: TextStyle(
                                      fontSize: 11, color: AppColors.faint),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 1,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            AppColors.border,
            AppColors.border,
            Colors.transparent,
          ],
          stops: [0, 0.2, 0.8, 1],
        ),
      ),
    );
  }
}