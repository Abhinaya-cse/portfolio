import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme/app_theme.dart';
import 'notifications_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _isLoading     = false;
  bool _obscure       = true;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email    = _emailCtrl.text.trim();
    final password = _passwordCtrl.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => _error = 'Please enter email and password.');
      return;
    }

    setState(() {
      _isLoading = true;
      _error     = null;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Auth success — StreamBuilder in build() will rebuild to dashboard
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
        _error = switch (e.code) {
          'user-not-found'  => 'No account found for that email.',
          'wrong-password'  => 'Incorrect password.',
          'invalid-email'   => 'Invalid email address.',
          'too-many-requests' => 'Too many attempts. Try again later.',
          _                 => e.message ?? 'Login failed.',
        };
      });
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final user = snapshot.data;

        if (user != null) {
          // ── LOGGED IN: Admin Dashboard ─────────────────
          return _AdminDashboard(user: user, onLogout: _logout);
        }

        // ── NOT LOGGED IN: Login Screen ─────────────────
        return Scaffold(
          backgroundColor:
              isDark ? AppColors.darkBg : AppColors.lightBg,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded,
                  color: isDark ? AppColors.textLight : AppColors.textDark,
                  size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(28, 16, 28, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Icon
                  FadeInDown(
                    duration: const Duration(milliseconds: 400),
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.accent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(Icons.admin_panel_settings_outlined,
                          color: Colors.white, size: 32),
                    ),
                  ),
                  const SizedBox(height: 24),

                  FadeInLeft(
                    duration: const Duration(milliseconds: 350),
                    child: Text('Admin Login',
                        style: Theme.of(context).textTheme.headlineMedium),
                  ),
                  const SizedBox(height: 6),
                  FadeInLeft(
                    duration: const Duration(milliseconds: 350),
                    child: Text('Sign in to view contact messages',
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                  const SizedBox(height: 36),

                  // Error
                  if (_error != null)
                    FadeInUp(
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.red.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline_rounded,
                                color: Colors.red, size: 18),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(_error!,
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 13)),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Email field
                  FadeInUp(
                    duration: const Duration(milliseconds: 350),
                    child: _LoginField(
                      controller: _emailCtrl,
                      label: 'Email',
                      icon: Icons.mail_outline_rounded,
                      isDark: isDark,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Password field
                  FadeInUp(
                    duration: const Duration(milliseconds: 400),
                    child: _LoginField(
                      controller: _passwordCtrl,
                      label: 'Password',
                      icon: Icons.lock_outline_rounded,
                      isDark: isDark,
                      obscure: _obscure,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 18,
                          color: AppColors.textMuted,
                        ),
                        onPressed: () =>
                            setState(() => _obscure = !_obscure),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Login button
                  FadeInUp(
                    duration: const Duration(milliseconds: 450),
                    child: SizedBox(
                      width: double.infinity,
                      child: GestureDetector(
                        onTap: _isLoading ? null : _login,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: _isLoading
                                  ? [
                                      AppColors.primary
                                          .withValues(alpha: 0.5),
                                      AppColors.accent.withValues(alpha: 0.5),
                                    ]
                                  : [AppColors.primary, AppColors.accent],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    AppColors.primary.withValues(alpha: 0.3),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Center(
                            child: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation(
                                          Colors.white),
                                    ),
                                  )
                                : const Text('Sign In',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    )),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── ADMIN DASHBOARD (shown after login) ──────────────────────
class _AdminDashboard extends StatelessWidget {
  final User user;
  final VoidCallback onLogout;
  const _AdminDashboard({required this.user, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded,
              color: isDark ? AppColors.textLight : AppColors.textDark,
              size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Admin Panel',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textLight : AppColors.textDark,
            )),
        actions: [
          // ── Notification Bell with unread badge ────────
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('contact')
                .where('read', isEqualTo: false)
                .snapshots(),
            builder: (context, snapshot) {
              final unread = snapshot.data?.docs.length ?? 0;
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NotificationsScreen(),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
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
                        child: Icon(Icons.notifications_outlined,
                            size: 20,
                            color: isDark
                                ? AppColors.textLight
                                : AppColors.textDark),
                      ),
                      if (unread > 0)
                        Positioned(
                          top: 2,
                          right: 2,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                unread > 9 ? '9+' : '$unread',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 4),
          // Logout
          IconButton(
            icon: const Icon(Icons.logout_rounded,
                color: Colors.red, size: 20),
            onPressed: onLogout,
            tooltip: 'Logout',
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome card
            FadeInDown(
              duration: const Duration(milliseconds: 350),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.accent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.waving_hand_rounded,
                        color: Colors.white, size: 28),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Welcome back!',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700)),
                          Text(user.email ?? '',
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            Text('Overview',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontSize: 18)),
            const SizedBox(height: 16),

            // Stats row
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('contact')
                  .snapshots(),
              builder: (context, snapshot) {
                final total  = snapshot.data?.docs.length ?? 0;
                final unread = snapshot.data?.docs
                        .where((d) => d['read'] == false)
                        .length ??
                    0;

                return Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        label: 'Total Messages',
                        value: '$total',
                        icon: Icons.mail_outline_rounded,
                        color: AppColors.primary,
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _StatCard(
                        label: 'Unread',
                        value: '$unread',
                        icon: Icons.mark_email_unread_outlined,
                        color: unread > 0 ? Colors.red : AppColors.accent,
                        isDark: isDark,
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 28),

            // Go to notifications button
            FadeInUp(
              duration: const Duration(milliseconds: 400),
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const NotificationsScreen()),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : AppColors.lightCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.notifications_active_outlined,
                            color: AppColors.primary, size: 22),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('View Messages',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15)),
                            Text('See all contact form submissions',
                                style: TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 12)),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded,
                          size: 14, color: AppColors.textMuted),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── STAT CARD ─────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool isDark;
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 12),
          Text(value,
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: color)),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(
                  color: AppColors.textMuted, fontSize: 12)),
        ],
      ),
    );
  }
}

// ── LOGIN FIELD ───────────────────────────────────────────────
class _LoginField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isDark;
  final bool obscure;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;

  const _LoginField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.isDark,
    this.obscure = false,
    this.keyboardType,
    this.suffixIcon,
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
        obscureText: obscure,
        keyboardType: keyboardType,
        style: TextStyle(
          color: isDark ? AppColors.textLight : AppColors.textDark,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, size: 18, color: AppColors.textMuted),
          suffixIcon: suffixIcon,
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