import 'package:baity/services/location_service.dart';
import 'package:baity/widgets/TypeSelector.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:baity/pages/AddEditYouthHousePage.dart';
import 'package:baity/widgets/AppDrawer.dart';
import 'package:baity/widgets/AdminYouthHouseCard.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({Key? key}) : super(key: key);

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int numberOfHouses = -1;
  List<Map<String, dynamic>> states = [];
  String? selectedState;
  String? selectedType;
  String? queryType;

  @override
  void initState() {
    super.initState();
    fetchNumberOfHouses();
  }

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

  Future<void> fetchNumberOfHouses() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('places').get();

      if (!mounted) return;

      setState(() {
        numberOfHouses = querySnapshot.docs.length;
      });
    } catch (e) {
      print('Error fetching number of houses: $e');

      if (!mounted) return;

      setState(() {
        numberOfHouses = 0;
      });
    }
  }

  /// Helper function to check if URL is valid
  bool isValidUrl(String? url) {
    if (url == null) return false;
    final uri = Uri.tryParse(url);
    return uri != null &&
        uri.hasAbsolutePath &&
        (uri.isScheme('http') || uri.isScheme('https'));
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    Stream<QuerySnapshot<Map<String, dynamic>>> _buildQuery() {
      Query<Map<String, dynamic>> query =
          FirebaseFirestore.instance.collection('places');

      if (selectedState != null && selectedState!.isNotEmpty) {
        query = query.where('state.code', isEqualTo: selectedState);
      }
      if (queryType != null && queryType!.isNotEmpty) {
        query = query.where('type.ar', isEqualTo: queryType);
      }

      return query.snapshots();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.appTitle),
      ),
      drawer: const AppDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withOpacity(0.1),
              theme.colorScheme.secondary.withOpacity(0.05),
              theme.colorScheme.tertiary.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: theme.colorScheme.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$numberOfHouses ${loc.numberofinstitution}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
                            queryType = value;
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

              // Content Section
              Expanded(
                child: StreamBuilder(
                  stream: _buildQuery(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text('Error loading data'));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final docs = snapshot.data!.docs;

                    if (docs.isEmpty) {
                      return const Center(child: Text('No places found'));
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final doc = docs[index];
                        final house = doc.data() as Map<String, dynamic>;

                        // Validate the image URL
                        String imageUrl = isValidUrl(house['imageUrl'])
                            ? house['imageUrl']
                            : 'https://i.ibb.co/sJvdxyHr/952285.webp';

                        return AdminYouthHouseCard(
                          house: house,
                          imageUrl: imageUrl,
                          onEdit: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddEditYouthHousePage(
                                  isEditing: true,
                                  houseData: {
                                    'id':
                                        doc.id, // attach Firestore document id
                                    ...house,
                                  },
                                ),
                              ),
                            );
                          },
                          onDelete: () {
                            _showDeleteDialog(context, house['nameAR'], doc.id);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.secondary,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddEditYouthHousePage(
                  isEditing: false,
                ),
              ),
            );
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          icon: Icon(
            Icons.add,
            color: theme.colorScheme.onPrimary,
          ),
          label: Text(
            'Add New',
            style: TextStyle(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String houseName, String docId) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final loc = AppLocalizations.of(dialogContext)!;

        return AlertDialog(
          title: Text('Delete $houseName?'),
          content: Text(loc.deleteConfirmation),
          actions: [
            TextButton(
              child: Text(loc.cancel),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child:
                  Text(loc.delete, style: const TextStyle(color: Colors.red)),
              onPressed: () async {
                Navigator.of(dialogContext).pop();

                try {
                  await FirebaseFirestore.instance
                      .collection('places')
                      .doc(docId)
                      .delete();

                  scaffoldMessenger.showSnackBar(
                    SnackBar(content: Text('$houseName deleted successfully')),
                  );

                  setState(() {
                    numberOfHouses = numberOfHouses - 1;
                  });
                } catch (e) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(content: Text('Error deleting: $e')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
