import 'package:flutter/material.dart';
import 'package:frontend/providers/product_provider.dart';
import 'package:frontend/screens/product_list_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => ProductProvider(),
      child: MaterialApp(
        title: 'Product CRUD',
        theme: ThemeData(
          // A clean, professional color scheme
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF3498DB), // A professional blue
            primary: const Color(0xFF3498DB),
            secondary: const Color(0xFF2ECC71), // A vibrant green for success
            background: const Color(0xFFF4F6F8), // A very light grey background
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xFFF4F6F8),

          // App Bar Theme
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFF4F6F8),
            foregroundColor: Color(0xFF2C3E50), // A dark, slate color for text
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),

          // Card Theme
          cardTheme: CardTheme(
            elevation: 1,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          ),

          // Text Theme
          textTheme: const TextTheme(
            titleLarge: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF2C3E50)),
            bodyMedium: TextStyle(
                fontSize: 16,
                color: Color(0xFF7F8C8D)), // A softer grey for subtitles
            labelLarge:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        home: const ProductListScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
