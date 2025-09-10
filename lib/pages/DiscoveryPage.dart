import 'package:baity/pages/AdminDashboardPage.dart';
import 'package:baity/pages/AdminLoginPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:baity/widgets/YouthHouseCard.dart';
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
    bool isValidUrl(String? url) {
      if (url == null) return false;
      final uri = Uri.tryParse(url);
      return uri != null &&
          uri.hasAbsolutePath &&
          (uri.isScheme('http') || uri.isScheme('https'));
    }

    final loc = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final user = FirebaseAuth.instance.currentUser;

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
                Icons.admin_panel_settings_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                loc.adminInterface,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
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
                debugPrint('Firestore error: ${snapshot.error}');
                debugPrint('Stack trace: ${snapshot.stackTrace}');

                // Show the error message in the UI
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Error loading data:\n${snapshot.error}',
                      style: TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
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
                  String imageUrl = isValidUrl(data['imageUrl'])
                      ? data['imageUrl']
                      : 'https://i.ibb.co/sJvdxyHr/952285.webp';

                  return YouthHouseCard(
                    name: isArabic ? data['nameAR'] : data['nameFR'],
                    location: isArabic
                        ? (data['state']['name_ar'] +
                            '، ' +
                            data['city']['name_ar'])
                        : (data['state']['name_fr'] +
                            ', ' +
                            data['city']['name_fr']),
                    imageUrl: imageUrl,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HouseDetailsPage(
                            name: data['name'] ?? 'Unnamed',
                            location: isArabic
                                ? (data['state']['name_ar'] +
                                    '، ' +
                                    data['city']['name_ar'])
                                : (data['state']['name_fr'] +
                                    ', ' +
                                    data['city']['name_fr']),
                            imageUrl: imageUrl,
                            availableSpots: data['spots'] ?? 0,
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
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('places')
                .where('type.en', isEqualTo: "Youth house")
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                debugPrint('Firestore error: ${snapshot.error}');
                debugPrint('Stack trace: ${snapshot.stackTrace}');

                // Show the error message in the UI
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Error loading data:\n${snapshot.error}',
                      style: TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
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
                  String imageUrl = isValidUrl(data['imageUrl'])
                      ? data['imageUrl']
                      : 'https://i.ibb.co/sJvdxyHr/952285.webp';

                  return YouthHouseCard(
                    name: isArabic ? data['nameAR'] : data['nameFR'],
                    location: isArabic
                        ? (data['state']['name_ar'] +
                            '، ' +
                            data['city']['name_ar'])
                        : (data['state']['name_fr'] +
                            ', ' +
                            data['city']['name_fr']),
                    imageUrl: imageUrl,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HouseDetailsPage(
                            name: data['name'] ?? 'Unnamed',
                            location: isArabic
                                ? (data['state']['name_ar'] +
                                    '، ' +
                                    data['city']['name_ar'])
                                : (data['state']['name_fr'] +
                                    ', ' +
                                    data['city']['name_fr']),
                            imageUrl: imageUrl,
                            availableSpots: data['spots'] ?? 0,
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
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('places')
                .where('type.en', isEqualTo: "Youth camp")
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                debugPrint('Firestore error: ${snapshot.error}');
                debugPrint('Stack trace: ${snapshot.stackTrace}');

                // Show the error message in the UI
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Error loading data:\n${snapshot.error}',
                      style: TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
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
                  String imageUrl = isValidUrl(data['imageUrl'])
                      ? data['imageUrl']
                      : 'https://i.ibb.co/sJvdxyHr/952285.webp';

                  return YouthHouseCard(
                    name: isArabic ? data['nameAR'] : data['nameFR'],
                    location: isArabic
                        ? (data['state']['name_ar'] +
                            '، ' +
                            data['city']['name_ar'])
                        : (data['state']['name_fr'] +
                            ', ' +
                            data['city']['name_fr']),
                    imageUrl: imageUrl,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HouseDetailsPage(
                            name: data['name'] ?? 'Unnamed',
                            location: isArabic
                                ? (data['state']['name_ar'] +
                                    '، ' +
                                    data['city']['name_ar'])
                                : (data['state']['name_fr'] +
                                    ', ' +
                                    data['city']['name_fr']),
                            imageUrl: imageUrl,
                            availableSpots: data['spots'] ?? 0,
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
        ],
      ),
    );
  }
}
