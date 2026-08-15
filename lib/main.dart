import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_screen.dart';
import 'screens/services/financial_services_screen.dart';
import 'screens/services/it_consulting_screen.dart';
import 'screens/services/business_consulting_screen.dart';
import 'screens/about_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/blog_screen.dart';
import 'screens/consultation_form_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
          seedColor: const Color(0xFF0C2340), // Notre Dame Navy
          primary: const Color(0xFF0C2340),
          secondary: const Color(0xFFC99700), // Notre Dame Gold
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0C2340),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: Border(
            bottom: BorderSide(
              color: Color(0xFFC99700), // Gold Trim
              width: 2,
            ),
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: const Color(0xFF0C2340),
          primary: const Color(0xFF0C2340),
          secondary: const Color(0xFFC99700),
        ),
        scaffoldBackgroundColor: const Color(0xFF030712), // Deeper Midnight
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF030712),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: Border(
            bottom: BorderSide(
              color: Color(0xFFC99700), // Gold Trim
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
        '/onboarding': (context) => const OnboardingScreen(),
      },
    );
  }
}
