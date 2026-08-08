import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/services/financial_services_screen.dart';
import 'screens/services/it_consulting_screen.dart';
import 'screens/services/business_consulting_screen.dart';
import 'screens/about_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/blog_screen.dart';
import 'screens/consultation_form_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const RBMBusinessApp());
}

class RBMBusinessApp extends StatelessWidget {
  const RBMBusinessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RBM Business Holdings Inc.',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A237E), // Professional Navy Blue
          primary: const Color(0xFF1A237E),
          secondary: const Color(0xFFC5A059), // Professional Gold
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A237E),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: Border(
            bottom: BorderSide(
              color: Color(0xFFC5A059), // Gold Trim
              width: 2,
            ),
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: const Color(0xFF1A237E),
          primary: const Color(0xFF1A237E),
          secondary: const Color(0xFFC5A059),
        ),
        scaffoldBackgroundColor: const Color(0xFF0A0E2E), // Midnight Navy
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0A0E2E),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: Border(
            bottom: BorderSide(
              color: Color(0xFFC5A059), // Gold Trim
              width: 2,
            ),
          ),
        ),
      ),
      themeMode: ThemeMode.system, // Automatically switch based on device settings
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/': (context) => const HomeScreen(),
        '/financial': (context) => const FinancialServicesScreen(),
        '/it': (context) => const ITConsultingScreen(),
        '/business': (context) => const BusinessConsultingScreen(),
        '/about': (context) => const AboutScreen(),
        '/contact': (context) => const ContactScreen(),
        '/blog': (context) => const BlogScreen(),
        '/consultation': (context) => const ConsultationFormScreen(),
      },
    );
  }
}
