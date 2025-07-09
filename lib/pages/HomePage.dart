import 'package:baity/local_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:baity/themes/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Text("Settings"),
            Switch(
              value: themeProvider.isDarkMode,
              onChanged: (_) => themeProvider.toggleTheme(),
              activeColor: Theme.of(context).focusColor,
              inactiveThumbColor: Colors.brown,
              trackOutlineColor: MaterialStateProperty.all(
                  const Color.fromARGB(0, 165, 64, 64)),
            ),
            ElevatedButton(
              onPressed: () {
                final provider =
                    Provider.of<LocaleProvider>(context, listen: false);
                final isArabic = provider.locale.languageCode == 'ar';
                provider.setLocale(isArabic ? Locale('en') : Locale('ar'));
              },
              child: Text('Switch Language'),
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("Baity"),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              AppLocalizations.of(context)!.welcomeText,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}
