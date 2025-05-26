import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences.dart';
import 'screens/home_screen.dart';
import 'providers/task_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF1976D2),
          secondary: Color(0xFF837272),
          surface: Color(0xFF424242),
          background: Color(0xFF303030),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1976D2),
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF1976D2),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
