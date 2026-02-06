import 'package:flutter/material.dart';
import 'package:baity/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class ContributePage extends StatelessWidget {
  const ContributePage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.contributeTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: theme.colorScheme.surface,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.volunteer_activism,
                  size: 80,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  loc.contributeDescription,
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  loc.contributeDetails,
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  loc.contributeEmail,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    decoration: TextDecoration.underline,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                    icon: Icon(
                      Icons.email,
                      color: theme.colorScheme.onPrimary,
                    ),
                    label: Text(
                      loc.contributeButton,
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    onPressed: () {
                      final subject = Uri.encodeComponent('Contribution to Baity App');
                      final body = Uri.encodeComponent('* Marks Mandatory fields\n\n'
                          'Hello Baity team,\n\n'
                          'I would like to contribute a new place:\n\n'
                          '  Establishment Name:\n'
                          '    *Arabic:\n'
                          '    *Latin:\n\n'
                          '  *Google Maps Location Link:\n\n'
                          '  *Capacity: .. Beds\n\n'
                          '  *Type: Youth Hostel / Youth Camp\n\n'
                          '  Contact Info:\n'
                          '    *Phone:\n'
                          '    Email:\n\n'
                          '  Social Media Links:\n'
                          '    Facebook:\n'
                          '    Instagram:\n'
                          '    Tiktok:\n\n'
                          '  *Entrance Picture:\n\n'
                          '  Additional Notes:\n\n'
                          'Thank you.');

                      final Uri emailUri = Uri.parse(
                        'mailto:${loc.contributeEmail}?subject=$subject&body=$body',
                      );

                      launchUrl(emailUri);
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
