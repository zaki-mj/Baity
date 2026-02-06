import 'package:baity/pages/AdminDashboardPage.dart';
import 'package:baity/pages/AdminLoginPage.dart';
import 'package:baity/pages/ContributePage.dart';
import 'package:baity/services/location_service.dart';
import 'package:baity/widgets/TypeSelector.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:baity/l10n/app_localizations.dart';
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

class _DiscoveryPageState extends State<DiscoveryPage> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> states = [];

  String? selectedState;
  String? selectedType;
  String? queryType;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context);
    _loadStates(locale);
  }

  Future<void> _loadStates(Locale locale) async {
    states = await AlgeriaLocationService.getStates(locale);
    setState(() {});
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _buildQuery() {
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection('places');

    if (selectedState != null && selectedState!.isNotEmpty) {
      query = query.where('state.code', isEqualTo: selectedState);
    }
    if (queryType != null && queryType!.isNotEmpty) {
      query = query.where('type.ar', isEqualTo: queryType);
    }

    return query.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    bool isValidUrl(String? url) {
      if (url == null) return false;
      final uri = Uri.tryParse(url);
      return uri != null && uri.hasAbsolutePath && (uri.isScheme('http') || uri.isScheme('https'));
    }

    final loc = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isEnglish = Localizations.localeOf(context).languageCode == 'en';
    final theme = Theme.of(context);
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
                    Icon(Icons.home, size: 48, color: Theme.of(context).colorScheme.onPrimary),
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
                  Icons.add,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  loc.contribute,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.pop(context); // Close drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ContributePage(),
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
        ),
        body: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: loc.state,
                        prefixIcon: Icon(
                          Icons.location_city,
                          color: theme.colorScheme.primary,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: theme.colorScheme.surface,
                      ),
                      value: selectedState,
                      hint: Text(loc.state),
                      items: states.map((state) {
                        return DropdownMenuItem<String>(
                          value: state['code'],
                          child: isArabic
                              ? (Text(
                                  state['code'] + ' ' + state['name_ar'],
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ))
                              : (Text(
                                  state['code'] + ' ' + state['name_fr'],
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                )),
                        );
                      }).toList(),
                      onChanged: (value) {
                        print("User picked: $value");
                        setState(() {
                          selectedState = value;
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: TypeSelector(
                    selectedType: selectedType,
                    onTypeChanged: (value) {
                      setState(() {
                        selectedType = value;
                        if (value == "youth_house") {
                          queryType = "بيت الشباب";
                        } else if (value == "youth_camp") {
                          queryType = "مخيم الشباب";
                        }

                        print("User picked: $value");
                      });
                    },
                  ),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        selectedState = null;
                        selectedType = null;
                        queryType = null;
                      });
                    },
                    icon: Icon(Icons.clear))
              ],
            ),
            Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _buildQuery(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text(loc.errorNotFound));
                }
                final houses = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: houses.length,
                  itemBuilder: (context, index) {
                    final data = houses[index].data();
                    String imageUrl = isValidUrl(data['imageUrl']) ? data['imageUrl'] : 'https://i.ibb.co/sJvdxyHr/952285.webp';
                    return YouthHouseCard(
                      name: isArabic ? (data['type']['ar'] + ' ' + data['nameAR']) : (isEnglish ? (data['type']['en'] + ' ' + data['nameFR']) : data['type']['fr'] + ' ' + data['nameFR']),
                      location: isArabic ? (data['state']['name_ar'] + '، ' + data['city']['name_ar']) : (data['state']['name_fr'] + ', ' + data['city']['name_fr']),
                      imageUrl: imageUrl,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HouseDetailsPage(
                              name: isArabic ? (data['type']['ar'] + ' ' + data['nameAR']) : data['nameFR'],
                              location: isArabic ? (data['state']['name_ar'] + '، ' + data['city']['name_ar']) : (data['state']['name_fr'] + ', ' + data['city']['name_fr']),
                              imageUrl: imageUrl,
                              availableSpots: data['spots'] ?? 0,
                              phone: data['phone'] ?? '',
                              email: data['email'] ?? '',
                              facebookUrl: data['facebook'] ?? '',
                              instagramUrl: data['instagram'] ?? '',
                              twitterUrl: data['twitter'] ?? '',
                              address: data['address'] ?? '',
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            )),
          ],
        ));
  }
}
