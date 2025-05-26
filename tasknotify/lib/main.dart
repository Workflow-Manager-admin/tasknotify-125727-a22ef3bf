import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'providers/task_provider.dart';

import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  final prefs = await SharedPreferences.getInstance();
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskProvider(prefs),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskNotify',
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF1976D2),
        colorScheme: const ColorScheme.dark().copyWith(
          primary: Color(0xFF1976D2),
          secondary: Color(0xFF837272),
          surface: Color(0xFF303030),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1976D2),
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF1976D2),
        ),
        scaffoldBackgroundColor: const Color(0xFF212121),
      ),
      home: const HomeScreen(),
    );
  }
}
