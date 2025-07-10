import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:baity/widgets/YouthHouseCard.dart';
import 'package:provider/provider.dart';
import 'package:baity/themes/theme_provider.dart';
import 'package:baity/local_provider.dart';
import 'package:baity/pages/HouseDetailsPage.dart';

class DiscoveryPage extends StatefulWidget {
  const DiscoveryPage({Key? key}) : super(key: key);

  @override
  State<DiscoveryPage> createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final List<Map<String, String>> allHouses = [
      {
        'name': loc.youthHouseName1,
        'location': loc.youthHouseLocation1,
        'imageUrl':
            'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
      },
      {
        'name': loc.youthHouseName2,
        'location': loc.youthHouseLocation2,
        'imageUrl':
            'https://images.unsplash.com/photo-1465101046530-73398c7f28ca',
      },
      {
        'name': loc.youthHouseName3,
        'location': loc.youthHouseLocation3,
        'imageUrl':
            'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429',
      },
    ];
    return Scaffold(
      drawer: Drawer(
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
                  Icon(Icons.home,
                      size: 48, color: Theme.of(context).colorScheme.onPrimary),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.appTitle,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                AppLocalizations.of(context)!.settings,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, _) => SwitchListTile(
                secondary: Icon(
                  themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  themeProvider.isDarkMode ? 'Dark Mode' : 'Light Mode',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                value: themeProvider.isDarkMode,
                onChanged: (_) => themeProvider.toggleTheme(),
              ),
            ),
            Consumer<LocaleProvider>(
              builder: (context, localeProvider, _) => SwitchListTile(
                secondary: Icon(Icons.language,
                    color: Theme.of(context).colorScheme.primary),
                title: Text(
                  localeProvider.locale.languageCode == 'ar'
                      ? 'العربية'
                      : 'English',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                value: localeProvider.locale.languageCode == 'ar',
                onChanged: (val) {
                  localeProvider
                      .setLocale(val ? const Locale('ar') : const Locale('en'));
                },
                activeColor: Theme.of(context).colorScheme.primary,
                inactiveThumbColor: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(loc.exploreButton),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: loc.tabAll),
            Tab(text: loc.tabYouthHouses),
            Tab(text: loc.tabYouthCamps),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // All
          ListView(
            children: allHouses
                .map((house) => YouthHouseCard(
                      name: house['name']!,
                      location: house['location']!,
                      imageUrl: house['imageUrl']!,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HouseDetailsPage(
                              name: house['name']!,
                              location: house['location']!,
                              imageUrl: house['imageUrl']!,
                              availableSpots: 12,
                              phone: '+201234567890',
                              email: 'info@youthhouse.com',
                              facebookUrl: 'https://facebook.com/youthhouse',
                              instagramUrl: 'https://instagram.com/youthhouse',
                              twitterUrl: 'https://twitter.com/youthhouse',
                              address: '123 Youth St, Cairo, Egypt',
                              latitude: 30.0444,
                              longitude: 31.2357,
                            ),
                          ),
                        );
                      },
                    ))
                .toList(),
          ),
          // Youth Houses (first and third)
          ListView(
            children: [0, 2]
                .map((i) => YouthHouseCard(
                      name: allHouses[i]['name']!,
                      location: allHouses[i]['location']!,
                      imageUrl: allHouses[i]['imageUrl']!,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Placeholder()));
                      },
                    ))
                .toList(),
          ),
          // Youth Camps (second)
          ListView(
            children: [1]
                .map((i) => YouthHouseCard(
                      name: allHouses[i]['name']!,
                      location: allHouses[i]['location']!,
                      imageUrl: allHouses[i]['imageUrl']!,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Placeholder()));
                      },
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
