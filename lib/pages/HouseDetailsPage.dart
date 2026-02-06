import 'package:flutter/material.dart';
import 'package:baity/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class HouseDetailsPage extends StatelessWidget {
  final String name;
  final String location;
  final String? imageUrl; // Changed to final
  final int availableSpots;
  final String? phone;
  final String? email;
  final String? secondPhone;
  final String facebookUrl;
  final String instagramUrl;
  final String twitterUrl;
  final String address;

  const HouseDetailsPage({
    Key? key,
    required this.name,
    required this.location,
    this.imageUrl,
    required this.availableSpots,
    this.phone,
    this.email,
    this.secondPhone,
    required this.facebookUrl,
    required this.instagramUrl,
    required this.twitterUrl,
    required this.address,
  }) : super(key: key);

  Future<void> _launchURL(BuildContext context, String? url, {String? fallbackMessage}) async {
    if (url == null || url.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(fallbackMessage ?? 'Link not available')),
      );
      return;
    }

    final uri = Uri.tryParse(url);
    if (uri == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(fallbackMessage ?? 'Invalid link')),
      );
      return;
    }

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open the link')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to launch: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: ListView(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
            child: imageUrl != null
                ? Image.network(imageUrl!, fit: BoxFit.cover)
                : Container(
                    height: 220,
                    color: theme.colorScheme.surfaceVariant,
                    child: const Icon(Icons.image, size: 80),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  color: theme.colorScheme.surface,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.location_on, color: theme.colorScheme.primary),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                location,
                                style: theme.textTheme.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.hotel, color: theme.colorScheme.primary),
                            const SizedBox(width: 6),
                            Text('${loc.detailsSpots}: $availableSpots', style: theme.textTheme.bodyMedium),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  color: theme.colorScheme.surface,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          loc.detailsContact,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (phone != null && phone!.isNotEmpty)
                          Row(
                            children: [
                              Icon(Icons.phone, color: theme.colorScheme.primary),
                              const SizedBox(width: 6),
                              GestureDetector(
                                onTap: () => _launchURL(context, 'tel:$phone'),
                                child: Text(phone!,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: theme.colorScheme.primary,
                                      decoration: TextDecoration.underline,
                                    )),
                              ),
                            ],
                          ),
                        if (phone != null && phone!.isNotEmpty) const SizedBox(height: 8),
                        if (email != null && email!.isNotEmpty)
                          Row(
                            children: [
                              Icon(Icons.email, color: theme.colorScheme.primary),
                              const SizedBox(width: 6),
                              GestureDetector(
                                onTap: () => _launchURL(context, 'mailto:$email'),
                                child: Text(email!,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: theme.colorScheme.primary,
                                      decoration: TextDecoration.underline,
                                    )),
                              ),
                            ],
                          ),
                        if (email != null && email!.isNotEmpty) const SizedBox(height: 8),
                        if (secondPhone != null && secondPhone!.isNotEmpty)
                          Row(
                            children: [
                              Icon(Icons.phone_android, color: theme.colorScheme.primary),
                              const SizedBox(width: 6),
                              GestureDetector(
                                onTap: () => _launchURL(context, 'tel:$secondPhone'),
                                child: Text(secondPhone!,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: theme.colorScheme.primary,
                                      decoration: TextDecoration.underline,
                                    )),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  color: theme.colorScheme.surface,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          loc.detailsSocial,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _launchURL(context, facebookUrl, fallbackMessage: loc.facebookLinkNotAvailable);
                                  },
                                  child: CircleAvatar(
                                    radius: 24,
                                    backgroundColor: theme.colorScheme.primary,
                                    child: Text(
                                      'F',
                                      style: TextStyle(
                                        color: theme.colorScheme.onPrimary,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  loc.detailsFacebook,
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _launchURL(context, instagramUrl, fallbackMessage: loc.instagramLinkNotAvailable);
                                  },
                                  child: CircleAvatar(
                                    radius: 24,
                                    backgroundColor: theme.colorScheme.primary,
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: theme.colorScheme.onPrimary,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  loc.detailsInstagram,
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _launchURL(context, twitterUrl, fallbackMessage: loc.twitterLinkNotAvailable);
                                  },
                                  child: CircleAvatar(
                                    radius: 24,
                                    backgroundColor: theme.colorScheme.primary,
                                    child: Icon(
                                      Icons.music_note,
                                      color: theme.colorScheme.onPrimary,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  loc.detailsTwitter,
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  color: theme.colorScheme.surface,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          loc.detailsAddress,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: ElevatedButton.icon(
                            icon: Icon(
                              Icons.map,
                              color: theme.colorScheme.onPrimary,
                            ),
                            label: Text(
                              loc.detailsMap,
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
                            onPressed: () => _launchURL(context, address),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
