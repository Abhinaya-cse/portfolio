import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'project_screen.dart';
import 'skills_screen.dart';
import 'experience_screen.dart';
import 'contact_screen.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _currentIndex = 0;

  // ProjectsSection used instead of ProjectDetailScreen (which needs a Project arg).
  // All section widgets are non-const because some have internal state.
  final List<Widget> _screens = [
    const HomeScreen(),
    const ProjectsSection(),
    const SkillsSection(),
    const ExperienceSection(),
    const ContactSection(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: IndexedStack(index: _currentIndex, children: _screens),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: bg,
            border: Border(top: BorderSide(color: border, width: 0.5)),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(icon: Icons.person_outline_rounded, label: 'About', index: 0, current: _currentIndex, onTap: _setIndex),
                  _NavItem(icon: Icons.grid_view_rounded, label: 'Projects', index: 1, current: _currentIndex, onTap: _setIndex),
                  _NavItem(icon: Icons.bolt_rounded, label: 'Skills', index: 2, current: _currentIndex, onTap: _setIndex),
                  _NavItem(icon: Icons.work_outline_rounded, label: 'Experience', index: 3, current: _currentIndex, onTap: _setIndex),
                  _NavItem(icon: Icons.mail_outline_rounded, label: 'Contact', index: 4, current: _currentIndex, onTap: _setIndex),
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

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int current;
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
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isActive ? AppColors.primary : AppColors.textMuted,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? AppColors.primary : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}