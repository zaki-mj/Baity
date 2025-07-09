import 'package:baity/local_provider.dart';
import 'package:baity/pages/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:baity/themes/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width; // Gives the width
    double height = MediaQuery.of(context).size.height; // Gives the height
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 100,
                child: Icon(
                  Icons.home,
                  size: 180,
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.appTitle,
                    ),
                    Text(
                      AppLocalizations.of(context)!.welcomeText,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(Size(width * 0.9, 50)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                  child: Text(AppLocalizations.of(context)!.exploreButton))
            ],
          ),
        ),
      ),
    );
  }
}
