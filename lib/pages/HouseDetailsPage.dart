import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class HouseDetailsPage extends StatelessWidget {
  final String name;
  final String location;
  final String imageUrl;
  final int availableSpots;
  final String phone;
  final String email;
  final String facebookUrl;
  final String instagramUrl;
  final String twitterUrl;
  final String address;
  final double latitude;
  final double longitude;

  const HouseDetailsPage({
    Key? key,
    required this.name,
    required this.location,
    required this.imageUrl,
    required this.availableSpots,
    required this.phone,
    required this.email,
    required this.facebookUrl,
    required this.instagramUrl,
    required this.twitterUrl,
    required this.address,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  void _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _openMap(BuildContext context, double lat, double lng) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    final uri = Uri.parse(url);
    final canLaunch = await canLaunchUrl(uri);
    if (canLaunch) {
      final launched =
          await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open Google Maps')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open Google Maps')),
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
            child: Image.network(
              imageUrl,
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
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
                    Icon(Icons.people, color: theme.colorScheme.secondary),
                    const SizedBox(width: 6),
                    Text('${loc.detailsSpots}: $availableSpots'),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  loc.detailsDescription,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                Divider(),
                Text(
                  loc.detailsContact,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.phone, color: theme.colorScheme.primary),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () => _openUrl('tel:$phone'),
                      child: Text(phone,
                          style: theme.textTheme.bodyLarge
                              ?.copyWith(color: theme.colorScheme.primary)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.email, color: theme.colorScheme.primary),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () => _openUrl('mailto:$email'),
                      child: Text(email,
                          style: theme.textTheme.bodyLarge
                              ?.copyWith(color: theme.colorScheme.primary)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  loc.detailsSocial,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      icon:
                          const Icon(Icons.facebook, color: Color(0xFF4267B2)),
                      onPressed: () => _openUrl(facebookUrl),
                      tooltip: loc.detailsFacebook,
                    ),
                    IconButton(
                      icon: const Icon(Icons.camera_alt,
                          color: Color(0xFFC13584)),
                      onPressed: () => _openUrl(instagramUrl),
                      tooltip: loc.detailsInstagram,
                    ),
                    IconButton(
                      icon: const Icon(Icons.alternate_email,
                          color: Color(0xFF1DA1F2)),
                      onPressed: () => _openUrl(twitterUrl),
                      tooltip: loc.detailsTwitter,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  loc.detailsAddress,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.map, color: theme.colorScheme.primary),
                    const SizedBox(width: 6),
                    Expanded(child: Text(address)),
                  ],
                ),
                const SizedBox(height: 12),
                Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.map),
                    label: Text(loc.detailsMap),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    onPressed: () => _openMap(context, latitude, longitude),
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
