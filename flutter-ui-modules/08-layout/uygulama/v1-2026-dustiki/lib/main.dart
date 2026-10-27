import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/planner_provider.dart';
import 'theme/app_theme.dart';
import 'screens/main_navigation_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => PlannerProvider(),
      child: const DayPlannerApp(),
    ),
  );
}

class DayPlannerApp extends StatelessWidget {
  const DayPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlannerProvider>(
      builder: (context, provider, child) {
        return MaterialApp(
          title: 'Günlük Planlayıcı & Rutin',
          debugShowCheckedModeBanner: false,
          themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          theme: AppTheme.lightTheme(provider.seedColor),
          darkTheme: AppTheme.darkTheme(provider.seedColor),
          home: const MainNavigationScreen(),
        );
      },
    );
  }
}
