import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:baity/themes/theme_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Baity"),
        actions: [
          Switch(
            value: themeProvider.isDarkMode,
            onChanged: (_) => themeProvider.toggleTheme(),
            activeColor: Theme.of(context).focusColor,
            inactiveThumbColor: Colors.brown,
            trackOutlineColor:
                MaterialStateProperty.all(const Color.fromARGB(0, 165, 64, 64)),
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Welcome to Baity!',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
