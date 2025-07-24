import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:baity/widgets/YouthHouseCard.dart';
import 'package:provider/provider.dart';
import 'package:baity/themes/theme_provider.dart';
import 'package:baity/local_provider.dart';
import 'package:baity/pages/HouseDetailsPage.dart';
import 'package:baity/pages/SettingsPage.dart';
import 'package:baity/pages/AboutPage.dart';
import 'package:baity/services/StoreServices.dart';

StoreServices _storeServices = StoreServices();

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
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(loc.exploreButton),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: loc.tabAll),
            Tab(text: loc.tabYouthHouses),
            Tab(text: loc.tabYouthCamps),
          ],
          labelColor: Colors.white,
          unselectedLabelColor:
              Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
          indicatorColor: Colors.white,
          dividerColor: Colors.transparent,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('places')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error loading data'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              final docs = snapshot.data!.docs;

              if (docs.isEmpty) {
                return Center(child: Text('No places found'));
              }
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  return YouthHouseCard(
                    name: data['name'] ?? 'Unnamed',
                    location: data['location'] ?? '',
                    imageUrl: (data['imageUrl'] != null &&
                            (data['imageUrl'] as String).isNotEmpty)
                        ? data['imageUrl']
                        : 'https://via.placeholder.com/100',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HouseDetailsPage(
                            name: data['name'] ?? 'Unnamed',
                            location: data['location'] ?? '',
                            imageUrl: (data['imageUrl'] != null &&
                                    (data['imageUrl'] as String).isNotEmpty)
                                ? data['imageUrl']
                                : 'https://via.placeholder.com/100',
                            availableSpots: data['availableSpots'] ?? 0,
                            phone: data['phone'] ?? '',
                            email: data['email'] ?? '',
                            facebookUrl: data['facebookUrl'] ?? '',
                            instagramUrl: data['instagramUrl'] ?? '',
                            twitterUrl: data['twitterUrl'] ?? '',
                            address: data['address'] ?? '',
                            latitude: (data['latitude'] is double)
                                ? data['latitude']
                                : (data['latitude'] is int)
                                    ? (data['latitude'] as int).toDouble()
                                    : 0.0,
                            longitude: (data['longitude'] is double)
                                ? data['longitude']
                                : (data['longitude'] is int)
                                    ? (data['longitude'] as int).toDouble()
                                    : 0.0,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
          Text('datad'),
          Text('dataf'),
        ],
      ),
    );
  }
}
