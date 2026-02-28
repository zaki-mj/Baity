import 'package:baity/l10n/app_localizations.dart';
import 'package:baity/pages/HouseDetailsPage.dart';
import 'package:baity/widgets/YouthHouseCard.dart';
import 'package:flutter/material.dart';
import 'package:baity/services/favorite_service.dart';
import 'dart:convert';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  Map<String, Map<String, dynamic>> _favorites = {};

  @override
  void initState() {
    super.initState();
    _favorites = FavoriteService.instance.favorites;
    FavoriteService.instance.addListener(_onFavoritesChanged);
  }

  void _onFavoritesChanged() {
    if (!mounted) return;
    setState(() {
      _favorites = FavoriteService.instance.favorites;
    });
  }

  @override
  void dispose() {
    FavoriteService.instance.removeListener(_onFavoritesChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
        final isEnglish = Localizations.localeOf(context).languageCode == 'en';
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    // final isEnglish = Localizations.localeOf(context).languageCode == 'en'; // unused → commented out

    return Scaffold(
      body: Builder(builder: (context) {
        if (_favorites.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  loc.noFavoritesYet,
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  loc.heartSomeHousesFromDiscovery,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        final entries = _favorites.entries.toList();

        return ListView.builder(
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final key = entries[index].key;
            final data = Map<String, dynamic>.from(entries[index].value);

            return YouthHouseCard(
              id: key.toString(),
              name: isArabic ? (data['type']['ar'] + ' ' + data['nameAR']) : data['nameFR'],
              location: isArabic ? (data['state']['name_ar'] + '، ' + data['city']['name_ar']) : (data['state']['name_fr'] + ', ' + data['city']['name_fr']),
              imageUrl: data['imageUrl'] ?? '',
              fullData: data,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HouseDetailsPage(
                      name: isArabic ? (data['type']['ar'] + ' ' + data['nameAR']) : (isEnglish ? (data['type']['en'] + ' ' + data['nameFR']) : data['type']['fr'] + ' ' + data['nameFR'],
                      location: isArabic ? '${data['state']['name_ar'] ?? ''}، ${data['city']['name_ar'] ?? ''}' : '${data['state']['name_fr'] ?? ''}, ${data['city']['name_fr'] ?? ''}',
                      imageUrl: data['imageUrl'] ?? '',
                      availableSpots: data['spots'] as int? ?? 0,
                      phone: data['phone'] as String? ?? '',
                      email: data['email'] as String? ?? '',
                      facebookUrl: data['facebook'] as String? ?? '',
                      instagramUrl: data['instagram'] as String? ?? '',
                      twitterUrl: data['twitter'] as String? ?? '',
                      address: data['address'] as String? ?? '',
                      
                    ), 
                );
              },
            );
          },
        );
      }),
    );
  }
}
