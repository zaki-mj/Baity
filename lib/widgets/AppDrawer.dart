import 'package:baity/pages/DiscoveryPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:baity/l10n/app_localizations.dart';
import 'package:baity/pages/SettingsPage.dart';
import 'package:baity/pages/AboutPage.dart';
import 'package:baity/pages/welcome.dart';
import 'package:baity/pages/ContributePage.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.home, size: 48, color: Theme.of(context).colorScheme.onPrimary),
                const SizedBox(height: 8),
                Text(
                  loc.appTitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (user != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    loc.loggedInAs(user.email ?? ''),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
                        ),
                  ),
                ],
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(
              loc.settings,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.info_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(
              loc.about,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.dashboard,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(
              loc.explore,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DiscoveryPage(),
                ),
              );
            },
          ),
          if (user != null) ...[
            ListTile(
              leading: Icon(
                Icons.logout_outlined,
                color: Colors.red,
              ),
              title: Text(
                loc.logout,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.red,
                    ),
              ),
              onTap: () async {
                Navigator.pop(context); // Close drawer
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const WelcomePage(),
                  ),
                  (route) => false, // Remove all previous routes
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
