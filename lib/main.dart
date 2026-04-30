import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home_page.dart';

void main() {
  runApp(const ProviderScope(child: FlowSpaceApp()));
}

class FlowSpaceApp extends StatelessWidget {
  const FlowSpaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlowSpace',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF030005),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF8B5CF6),
          surface: Color(0xFF141118),
          onSurface: Colors.white,
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
