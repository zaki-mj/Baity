import 'package:baity/pages/AdminDashboardPage.dart';
import 'package:baity/pages/AdminLoginPage.dart';
import 'package:baity/services/dev_mode_service.dart';
import 'package:baity/services/favorite_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:baity/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:baity/themes/theme_provider.dart';
import 'package:baity/local_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  final user = FirebaseAuth.instance.currentUser;
  final _devService = DevModeService();
  bool _isDevMode = false;

  Future<void> _loadDevMode() async {
    final enabled = await _devService.isDevModeEnabled();
    if (mounted) {
      setState(() => _isDevMode = enabled);
    }
  }

  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    _loadDevMode();

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
                        themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: Text(
                        themeProvider.isDarkMode ? loc.darkMode : loc.lightMode,
                        style: Theme.of(context).textTheme.bodyLarge,
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
                        loc.changeLanguage,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                        size: 16,
                      ),
                      onTap: () {
                        _showLanguageDialog(context, localeProvider);
                      },
                    ),
                  ),
                  const Divider(),

                  // Language Picker
                  Consumer<LocaleProvider>(
                    builder: (context, localeProvider, _) => ListTile(
                      leading: Icon(
                        Icons.delete,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: Text(
                        loc.clearCacheAndFavorites,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                        size: 16,
                      ),
                      onTap: () {
                        _showClearCashDialog(context, localeProvider);
                      },
                    ),
                  ),

                  if (_isDevMode)
                    Column(
                      children: [
                        const Divider(),
                        (ListTile(
                          leading: Icon(
                            Icons.admin_panel_settings,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          subtitle: Text(
                            loc.enterAdminPanel,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                            size: 16,
                          ),
                          title: Text(loc.adminInterface),
                          onTap: () {
                            if (user != null) {
                              Navigator.pop(context); // Close drawer
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AdminDashboardPage(),
                                ),
                              );
                            } else {
                              Navigator.pop(context); // Close drawer
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AdminLoginPage(),
                                ),
                              );
                            }
                          },
                        )),
                      ],
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, LocaleProvider localeProvider) {
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
                  leading: Icon(Icons.language, color: Theme.of(context).colorScheme.primary),
                  title: Text(loc.arabic),
                  onTap: () {
                    localeProvider.setLocale(const Locale('ar'));
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.language, color: Theme.of(context).colorScheme.primary),
                  title: Text(loc.french),
                  onTap: () {
                    localeProvider.setLocale(const Locale('fr'));
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.language, color: Theme.of(context).colorScheme.primary),
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

  void _showClearCashDialog(BuildContext context, LocaleProvider localeProvider) {
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(loc.clearCacheConfirmationTitle),
          content: Text(loc.clearCacheConfirmationMessage),
          actions: <Widget>[
            TextButton(
              child: Text(
                loc.delete,
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                await FavoriteService.instance.clearAllFavorites();
                await DefaultCacheManager().emptyCache();
                Navigator.of(context).pop();
              },
            ),
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
