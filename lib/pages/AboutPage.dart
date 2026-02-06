import 'package:flutter/material.dart';
import 'package:baity/l10n/app_localizations.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.about),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // App Icon and Title
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Image.asset(
                    "lib/assets/images/icon.png",
                    scale: 6,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    loc.appTitle,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    loc.slogan,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // About Description
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.aboutTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    loc.aboutDescription,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Technical Details
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.technicalDetails,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    leading: Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(loc.appVersion),
                    subtitle: Text("1.0.0"),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.code,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(loc.developedWith),
                    subtitle: const Text('Flutter & Firebase'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Credits
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.credits,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    leading: Icon(
                      Icons.public_sharp,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(loc.publisher),
                    subtitle: Text(loc.jawalAssociation),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.lightbulb_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(loc.ideaBy),
                    subtitle: Text(loc.medjdoubHadjirat),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.person_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(loc.developedBy),
                    subtitle: Text(loc.medjdoubZakaria),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
