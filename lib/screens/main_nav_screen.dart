import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../screens/about.dart';
import '../screens/project_screen.dart';
import '../screens/skills_screen.dart';
import '../screens/experience_screen.dart';
import '../screens/contact_screen.dart';
import '../screens/orb_background.dart';

/// Fallback bottom-nav screen (used if this is the entry point
/// instead of portfolio_screen.dart).
class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    _AboutWrap(),
    ProjectsSection(),
    SkillsSection(),
    ExperienceSection(),
    ContactSection(),
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.void_bg,
        body: OrbBackground(
          child: IndexedStack(
              index: _currentIndex, children: _screens),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: const Color(0xE604040A),
            border: const Border(
              top: BorderSide(color: AppColors.border),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(
                      icon: Icons.person_outline_rounded,
                      label: 'About',
                      index: 0,
                      current: _currentIndex,
                      onTap: _setIndex),
                  _NavItem(
                      icon: Icons.grid_view_rounded,
                      label: 'Projects',
                      index: 1,
                      current: _currentIndex,
                      onTap: _setIndex),
                  _NavItem(
                      icon: Icons.bolt_rounded,
                      label: 'Skills',
                      index: 2,
                      current: _currentIndex,
                      onTap: _setIndex),
                  _NavItem(
                      icon: Icons.work_outline_rounded,
                      label: 'Exp.',
                      index: 3,
                      current: _currentIndex,
                      onTap: _setIndex),
                  _NavItem(
                      icon: Icons.mail_outline_rounded,
                      label: 'Contact',
                      index: 4,
                      current: _currentIndex,
                      onTap: _setIndex),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _setIndex(int i) => setState(() => _currentIndex = i);
}

class _AboutWrap extends StatelessWidget {
  const _AboutWrap();
  @override
  Widget build(BuildContext context) =>
      AboutSection(onAvatarTap: () {});
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index, current;
  final void Function(int) onTap;

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
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          gradient: isActive
              ? const LinearGradient(
                  colors: [
                    Color(0x1A7C5CFC),
                    Color(0x0DB044FC),
                  ],
                )
              : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 22,
                color: isActive ? AppColors.violet : AppColors.muted),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight:
                    isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? AppColors.violet : AppColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
