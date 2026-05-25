import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart';
import 'screens/portfolio_screen.dart';
import 'screens/admin_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('isDark') ?? true;
  runApp(PortfolioApp(isDark: isDark));
}

class PortfolioApp extends StatefulWidget {
  final bool isDark;
  const PortfolioApp({super.key, required this.isDark});

  static _PortfolioAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_PortfolioAppState>();

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  late bool _isDark;

  @override
  void initState() {
    super.initState();
    _isDark = widget.isDark;
  }

  void toggleTheme() async {
    setState(() => _isDark = !_isDark);
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDark', _isDark);
  }

  bool get isDark => _isDark;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Abhinaya B - Portfolio',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      initialRoute: '/',
      routes: {
        '/': (_) => const PortfolioScreen(),
        '/admin': (_) => const AdminScreen(),
        // '/admin' route will be added once admin panel is built
      },
    );
  }
}