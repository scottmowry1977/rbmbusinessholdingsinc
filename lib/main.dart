import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
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
import 'screens/admin/article_uploader_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const RBMBusinessApp());
}

class RBMBusinessApp extends StatelessWidget {
  const RBMBusinessApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color notreDameNavy = Color(0xFF0C2340);
    const Color notreDameGold = Color(0xFFC99700);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RBM Business Holdings Inc.',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: notreDameNavy,
          primary: notreDameNavy,
          secondary: notreDameGold,
        ),
        textTheme: GoogleFonts.montserratTextTheme().copyWith(
          displayLarge: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.bold,
            color: notreDameNavy,
          ),
          headlineLarge: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.bold,
            color: notreDameNavy,
          ),
          titleLarge: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.bold,
            color: notreDameNavy,
          ),
        ),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: notreDameNavy,
          foregroundColor: Colors.white,
          titleTextStyle: GoogleFonts.playfairDisplay(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          elevation: 0,
          shape: const Border(
            bottom: BorderSide(
              color: notreDameGold,
              width: 2,
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: notreDameNavy,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: notreDameNavy,
          primary: notreDameNavy,
          secondary: notreDameGold,
        ),
        scaffoldBackgroundColor: const Color(0xFF030712),
        textTheme: GoogleFonts.montserratTextTheme(ThemeData.dark().textTheme).copyWith(
          displayLarge: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          headlineLarge: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          titleLarge: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF030712),
          foregroundColor: Colors.white,
          titleTextStyle: GoogleFonts.playfairDisplay(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          elevation: 0,
          shape: const Border(
            bottom: BorderSide(
              color: notreDameGold,
              width: 2,
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: notreDameNavy,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
      themeMode: ThemeMode.system,
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
        '/admin/uploader': (context) => const ArticleUploaderScreen(),
      },
    );
  }
}
