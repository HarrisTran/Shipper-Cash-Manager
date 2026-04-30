import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'features/main/presentation/pages/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shipper Cash Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF565E74),
          surface: const Color(0xFFFCF8FA),
        ),
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: const MainPage(),
    );
  }
}
