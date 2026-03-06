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

  // ── Collapsible filter state ──────────────────────────────────────────────
  bool _filtersExpanded = false;
  late final AnimationController _filterAnimController;
  late final Animation<double> _filterHeightFactor;

  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _filterAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _filterHeightFactor = CurvedAnimation(
      parent: _filterAnimController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final locale = Localizations.localeOf(context);
      _loadStates(locale);
    }
  }

  @override
  void dispose() {
    _filterAnimController.dispose();
    super.dispose();
  }

  Future<void> _loadStates(Locale locale) async {
    states = await AlgeriaLocationService.getStates(locale);
    if (mounted) setState(() {});
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _buildStream() {
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection('places');
    if (selectedState != null && selectedState!.isNotEmpty) {
      query = query.where('state.code', isEqualTo: selectedState);
    }
    if (queryType != null && queryType!.isNotEmpty) {
      query = query.where('type.ar', isEqualTo: queryType);
    }
    return query.snapshots();
  }

  void _toggleFilters() {
    setState(() => _filtersExpanded = !_filtersExpanded);
    if (_filtersExpanded) {
      _filterAnimController.forward();
    } else {
      _filterAnimController.reverse();
    }
  }

  void _clearFilters() {
    setState(() {
      selectedState = null;
      selectedType = null;
      queryType = null;
    });
  }

  bool get _hasActiveFilters => (selectedState != null && selectedState!.isNotEmpty) || (selectedType != null && selectedType!.isNotEmpty);

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
          _CollapsibleFilterBar(
            loc: loc,
            theme: theme,
            isArabic: isArabic,
            states: states,
            selectedState: selectedState,
            selectedType: selectedType,
            hasActiveFilters: _hasActiveFilters,
            filtersExpanded: _filtersExpanded,
            filterHeightFactor: _filterHeightFactor,
            onToggle: _toggleFilters,
            onClear: _clearFilters,
            onStateChanged: (value) => setState(() => selectedState = value),
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
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _buildStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text(loc.errorNotFound));
                }
                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) {
                  return Center(child: Text(loc.errorNotFound));
                }

                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data();
                    final imageUrl = isValidUrl(data['imageUrl']) ? data['imageUrl'] : 'https://i.ibb.co/sJvdxyHr/952285.webp';

                    return YouthHouseCard(
                      key: ValueKey(docs[index].id),
                      name: isArabic ? '${data['type']['ar']} ${data['nameAR']}' : (isEnglish ? '${data['type']['en']} ${data['nameFR']}' : '${data['type']['fr']} ${data['nameFR']}'),
                      location: isArabic ? '${data['state']['name_ar']}، ${data['city']['name_ar']}' : '${data['state']['name_fr']}, ${data['city']['name_fr']}',
                      imageUrl: imageUrl,
                      id: docs[index].id,
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
        ],
      ),
    );
  }
}

// ── Extracted collapsible filter widget ────────────────────────────────────────
class _CollapsibleFilterBar extends StatelessWidget {
  final dynamic loc;
  final ThemeData theme;
  final bool isArabic;
  final List<Map<String, dynamic>> states;
  final String? selectedState;
  final String? selectedType;
  final bool hasActiveFilters;
  final bool filtersExpanded;
  final Animation<double> filterHeightFactor;
  final VoidCallback onToggle;
  final VoidCallback onClear;
  final ValueChanged<String?> onStateChanged;
  final ValueChanged<String?> onTypeChanged;

  const _CollapsibleFilterBar({
    required this.loc,
    required this.theme,
    required this.isArabic,
    required this.states,
    required this.selectedState,
    required this.selectedType,
    required this.hasActiveFilters,
    required this.filtersExpanded,
    required this.filterHeightFactor,
    required this.onToggle,
    required this.onClear,
    required this.onStateChanged,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: filtersExpanded ? 4 : 1,
      shadowColor: theme.colorScheme.primary.withOpacity(0.15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: hasActiveFilters ? theme.colorScheme.primary : theme.iconTheme.color,
                  ),
                  const SizedBox(width: 10),
                  const Spacer(),
                  if (hasActiveFilters)
                    IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: onClear,
                      tooltip: 'Clear filters',
                      visualDensity: VisualDensity.compact,
                    ),
                  AnimatedRotation(
                    turns: filtersExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 280),
                    child: const Icon(Icons.keyboard_arrow_down_rounded),
                  ),
                ],
              ),
            ),
          ),
          SizeTransition(
            sizeFactor: filterHeightFactor,
            axisAlignment: -1,
            child: Container(
              color: theme.colorScheme.surface,
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.location_city, color: theme.colorScheme.primary),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.4),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      ),
                      value: selectedState,
                      hint: Text(loc.state),
                      items: states.map((state) {
                        return DropdownMenuItem<String>(
                          value: state['code'],
                          child: Text(
                            isArabic ? '${state['code']} ${state['name_ar']}' : '${state['code']} ${state['name_fr']}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        );
                      }).toList(),
                      onChanged: onStateChanged,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TypeSelector(
                      selectedType: selectedType,
                      onTypeChanged: onTypeChanged,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
