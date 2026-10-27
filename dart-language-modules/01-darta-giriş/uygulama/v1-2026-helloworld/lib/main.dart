import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'services/workout_storage_service.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  final storageService = WorkoutStorageService();
  await storageService.init();

  runApp(PplVolumeApp(storageService: storageService));
}

class PplVolumeApp extends StatefulWidget {
  final WorkoutStorageService storageService;

  const PplVolumeApp({
    super.key,
    required this.storageService,
  });

  @override
  State<PplVolumeApp> createState() => _PplVolumeAppState();
}

class _PplVolumeAppState extends State<PplVolumeApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PPL Hacim Hesaplayıcısı',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: HomeScreen(
        storageService: widget.storageService,
        onToggleTheme: _toggleTheme,
        isDarkMode: _themeMode == ThemeMode.dark,
      ),
    );
  }
}
