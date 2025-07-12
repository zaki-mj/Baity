import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:baity/themes/theme_provider.dart';
import 'package:baity/local_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.settings),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Theme Settings Section
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.settings,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),

                  // Theme Toggle
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, _) => SwitchListTile(
                      secondary: Icon(
                        themeProvider.isDarkMode
                            ? Icons.dark_mode
                            : Icons.light_mode,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: Text(
                        themeProvider.isDarkMode ? loc.darkMode : loc.lightMode,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      subtitle: Text(
                        themeProvider.isDarkMode
                            ? 'Switch to light mode'
                            : 'Switch to dark mode',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.6),
                            ),
                      ),
                      value: themeProvider.isDarkMode,
                      onChanged: (_) => themeProvider.toggleTheme(),
                    ),
                  ),

                  const Divider(),

                  // Language Picker
                  Consumer<LocaleProvider>(
                    builder: (context, localeProvider, _) => ListTile(
                      leading: Icon(
                        Icons.language,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: Text(
                        localeProvider.locale.languageCode == 'ar'
                            ? loc.arabic
                            : localeProvider.locale.languageCode == 'fr'
                                ? loc.french
                                : loc.english,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      subtitle: Text(
                        'Tap to change language',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.6),
                            ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.5),
                        size: 16,
                      ),
                      onTap: () {
                        _showLanguageDialog(context, localeProvider);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(
      BuildContext context, LocaleProvider localeProvider) {
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(loc.changeLanguage),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.language,
                      color: Theme.of(context).colorScheme.primary),
                  title: Text(loc.arabic),
                  onTap: () {
                    localeProvider.setLocale(const Locale('ar'));
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.language,
                      color: Theme.of(context).colorScheme.primary),
                  title: Text(loc.french),
                  onTap: () {
                    localeProvider.setLocale(const Locale('fr'));
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.language,
                      color: Theme.of(context).colorScheme.primary),
                  title: Text(loc.english),
                  onTap: () {
                    localeProvider.setLocale(const Locale('en'));
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(loc.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
