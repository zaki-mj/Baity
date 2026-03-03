import 'package:baity/services/location_service.dart';
import 'package:baity/widgets/TypeSelector.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:baity/l10n/app_localizations.dart';
import 'package:baity/widgets/YouthHouseCard.dart';
import 'package:baity/pages/HouseDetailsPage.dart';

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

  // Add this: a key or counter to force stream rebuild on refresh
  int _refreshKey = 0; // ← incrementing this forces StreamBuilder to re-subscribe

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

  // Extract the stream creation so we can rebuild it
  Stream<QuerySnapshot<Map<String, dynamic>>> _buildQuery() {
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection('places');

    if (selectedState != null && selectedState!.isNotEmpty) {
      query = query.where('state.code', isEqualTo: selectedState);
    }
    if (queryType != null && queryType!.isNotEmpty) {
      query = query.where('type.ar', isEqualTo: queryType);
    }

    // Optional: add orderBy if you want consistent sort
    // query = query.orderBy('nameAR'); // or createdAt, etc.

    return query.snapshots();
  }

  // Refresh handler: just increment key → forces new stream instance
  Future<void> _onRefresh() async {
    setState(() {
      _refreshKey++; // This causes StreamBuilder to rebuild and get a fresh stream
    });
    // Optional: small delay to let user see the spinner
    await Future.delayed(const Duration(milliseconds: 400));
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isEnglish = Localizations.localeOf(context).languageCode == 'en';
    final theme = Theme.of(context);

    bool isValidUrl(String? url) {
      if (url == null) return false;
      final uri = Uri.tryParse(url);
      return uri != null && uri.hasAbsolutePath && (uri.isScheme('http') || uri.isScheme('https'));
    }

    return Scaffold(
      body: Column(
        children: [
          // Your filters row (unchanged)
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
                      prefixIcon: Icon(Icons.location_city, color: theme.colorScheme.primary),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                    ),
                    value: selectedState,
                    hint: Text(loc.state),
                    items: states.map((state) {
                      return DropdownMenuItem<String>(
                        value: state['code'],
                        child: isArabic
                            ? Text(
                                '${state['code']} ${state['name_ar']}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              )
                            : Text(
                                '${state['code']} ${state['name_fr']}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => selectedState = value);
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
                      queryType = value == "youth_house"
                          ? "بيت الشباب"
                          : value == "youth_camp"
                              ? "مخيم الشباب"
                              : null;
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
                icon: const Icon(Icons.clear),
              ),
            ],
          ),

          // Main content with RefreshIndicator
          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              color: theme.colorScheme.primary, // optional: match your theme
              backgroundColor: theme.colorScheme.surface,
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                key: ValueKey(_refreshKey), // ← this forces rebuild on refresh
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
                    physics: const AlwaysScrollableScrollPhysics(), // ← important for refresh with few items
                    itemCount: houses.length,
                    itemBuilder: (context, index) {
                      final data = houses[index].data();
                      String imageUrl = isValidUrl(data['imageUrl']) ? data['imageUrl'] : 'https://i.ibb.co/sJvdxyHr/952285.webp';

                      return YouthHouseCard(
                        key: ValueKey(houses[index].id), // good practice
                        name: isArabic ? '${data['type']['ar']} ${data['nameAR']}' : (isEnglish ? '${data['type']['en']} ${data['nameFR']}' : '${data['type']['fr']} ${data['nameFR']}'),
                        location: isArabic ? '${data['state']['name_ar']}، ${data['city']['name_ar']}' : '${data['state']['name_fr']}, ${data['city']['name_fr']}',
                        imageUrl: imageUrl,
                        id: houses[index].id,
                        fullData: data,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HouseDetailsPage(
                                name: isArabic ? '${data['type']['ar']} ${data['nameAR']}' : data['nameFR'],
                                location: isArabic ? '${data['state']['name_ar']}، ${data['city']['name_ar']}' : '${data['state']['name_fr']}, ${data['city']['name_fr']}',
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
