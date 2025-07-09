import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:baity/themes/theme_provider.dart';
import 'pages/HomePage.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const BaityApp(),
    ),
  );
}

class BaityApp extends StatelessWidget {
  const BaityApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 👇 This context is safe because it's below the Provider
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Baity',
      theme: themeProvider.theme,
      home: const HomePage(),
    );
  }
}
