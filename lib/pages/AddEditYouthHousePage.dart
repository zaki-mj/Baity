import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:baity/services/StoreServices.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:baity/services/location_service.dart';
import 'package:baity/widgets/SectionCard.dart';
import 'package:baity/widgets/CustomTextField.dart';
import 'package:baity/widgets/TypeSelector.dart';

StoreServices _storeservices = StoreServices();

class AddEditYouthHousePage extends StatefulWidget {
  final bool isEditing;
  final Map<String, dynamic>? houseData;
  final Map<String, dynamic>? houseType;

  const AddEditYouthHousePage({
    Key? key,
    required this.isEditing,
    this.houseData,
    this.houseType,
  }) : super(key: key);

  @override
  State<AddEditYouthHousePage> createState() => _AddEditYouthHousePageState();
}

Future<List<Map<String, dynamic>>> loadWilayas() async {
  final String jsonString = await rootBundle
      .loadString('assets/data/algeria_wilayas_communes_cleaned.json');
  final List<dynamic> jsonData = json.decode(jsonString);
  return jsonData.cast<Map<String, dynamic>>();
}

class _AddEditYouthHousePageState extends State<AddEditYouthHousePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameControllerAR = TextEditingController();
  final _nameControllerFR = TextEditingController();
  final _locationController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _NumberOfSpotsController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _facebookUrlController = TextEditingController();
  final _instagramUrlController = TextEditingController();
  final _twitterUrlController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedType;
  bool _isLoading = false;

  String? selectedStateCode;
  String? selectedCityName;
  List<Map<String, dynamic>> states = [];
  List<Map<String, dynamic>> cities = [];

  @override
  void initState() {
    super.initState();

    if (widget.isEditing && widget.houseData != null) {
      _nameControllerAR.text = widget.houseData!['nameAR'] ?? '';
      _nameControllerFR.text = widget.houseData!['nameFR'] ?? '';
      _locationController.text = widget.houseData!['location'] ?? '';
      _imageUrlController.text = widget.houseData!['imageUrl'] ?? '';
      _phoneController.text = widget.houseData!['phone'] ?? '';
      _emailController.text = widget.houseData!['email'] ?? '';
      _addressController.text = widget.houseData!['address'] ?? '';
      _facebookUrlController.text = widget.houseData!['facebook'] ?? '';
      _instagramUrlController.text = widget.houseData!['instagram'] ?? '';
      _twitterUrlController.text = widget.houseData!['twitter'] ?? '';
      final typeEn = widget.houseData!['type']?['en'];
      if (typeEn == 'Youth house') {
        _selectedType = 'youth_house';
      } else if (typeEn == 'Youth camp') {
        _selectedType = 'youth_camp';
      }

      _NumberOfSpotsController.text =
          (widget.houseData!['spots'] ?? 20).toString();

      // Just store state & city raw data for now
      selectedStateCode = widget.houseData!['state']?['code'];
      selectedCityName = widget.houseData!['city']?['name'];
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final locale = Localizations.localeOf(context);

    // Only load states & cities once
    if (states.isEmpty) {
      _loadStates(locale).then((_) {
        if (selectedStateCode != null) {
          _loadCities(selectedStateCode!, locale).then((_) {
            setState(() {
              // make sure the city is restored
            });
          });
        }
      });
    }
  }

  Future<void> _loadStates(Locale locale) async {
    states = await AlgeriaLocationService.getStates(locale);
    setState(() {});
  }

  Future<void> _loadCities(String stateCode, Locale locale) async {
    cities = await AlgeriaLocationService.getCitiesForState(stateCode, locale);
    setState(() {});
  }

  @override
  void dispose() {
    _nameControllerAR.dispose();
    _nameControllerFR.dispose();
    _locationController.dispose();
    _imageUrlController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _facebookUrlController.dispose();
    _instagramUrlController.dispose();
    _twitterUrlController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context);

    if (states.isEmpty) {
      _loadStates(locale);
    }

    return Scaffold(
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
              // Header
              Container(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.secondary,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        widget.isEditing ? Icons.edit : Icons.add,
                        color: theme.colorScheme.onPrimary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.isEditing
                                ? loc.editYouthHouse
                                : loc.addNewYouthHouse,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),

              // Form Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Basic Information Card
                        SectionCard(
                          theme,
                          loc.basicInformation,
                          Icons.info_outline,
                          [
                            CustomTextField(
                              controller: _nameControllerAR,
                              label: loc.nameArabic,
                              icon: Icons.language,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return loc.pleaseEnterName;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: _nameControllerFR,
                              label: loc.nameLatin,
                              icon: Icons.abc,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return loc.pleaseEnterName;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TypeSelector(
                              selectedType: _selectedType,
                              onTypeChanged: (value) {
                                setState(() {
                                  _selectedType = value;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: selectedStateCode,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.state,
                                prefixIcon: Icon(Icons.location_city,
                                    color: theme.colorScheme.primary),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: theme.colorScheme.outline,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: theme.colorScheme.outline
                                        .withOpacity(0.5),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: theme.colorScheme.primary,
                                    width: 2,
                                  ),
                                ),
                                filled: true,
                                fillColor: theme.colorScheme.surface,
                              ),
                              items: states.map((state) {
                                return DropdownMenuItem<String>(
                                  value: state['code'],
                                  child: Text(
                                      '${state['code']} - ${state['name']}'),
                                );
                              }).toList(),
                              onChanged: (value) async {
                                selectedStateCode = value;
                                selectedCityName = null;
                                await _loadCities(value!, locale);
                              },
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: selectedCityName,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.city,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: theme.colorScheme.outline,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: theme.colorScheme.outline
                                        .withOpacity(0.5),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: theme.colorScheme.primary,
                                    width: 2,
                                  ),
                                ),
                                filled: true,
                                fillColor: theme.colorScheme.surface,
                              ),
                              items: cities.map((city) {
                                return DropdownMenuItem<String>(
                                  value: city['name'],
                                  child: Text(city['name']),
                                );
                              }).toList(),
                              onChanged: selectedStateCode == null
                                  ? null
                                  : (value) {
                                      setState(() {
                                        selectedCityName = value;
                                      });
                                    },
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              keyboardType: TextInputType.number,
                              controller: _NumberOfSpotsController,
                              label: loc.availableSpots,
                              icon: Icons.hotel,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return loc.pleaseEnterLocation;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: _imageUrlController,
                              label: loc.imageUrl,
                              icon: Icons.image,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return loc.pleaseEnterImageUrl;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Contact Information Card
                        SectionCard(
                          theme,
                          loc.contactInformation,
                          Icons.contact_phone,
                          [
                            CustomTextField(
                              controller: _phoneController,
                              label: loc.phone,
                              icon: Icons.phone,
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: _emailController,
                              label: loc.email,
                              icon: Icons.email,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: _addressController,
                              label: loc.address,
                              icon: Icons.map,
                              maxLines: 2,
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Social Media Card
                        SectionCard(
                          theme,
                          loc.socialMedia,
                          Icons.share,
                          [
                            CustomTextField(
                              controller: _facebookUrlController,
                              label: loc.facebookUrl,
                              icon: Icons.facebook,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: _instagramUrlController,
                              label: loc.instagramUrl,
                              icon: Icons.camera_alt,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: _twitterUrlController,
                              label: loc.twitterUrl,
                              icon: Icons.alternate_email,
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Description Card

                        const SizedBox(height: 32),

                        // Save Button
                        Container(
                          width: double.infinity,
                          height: 56,
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
                                color:
                                    theme.colorScheme.primary.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            //onPressed: _isLoading ? null : _handleSave,
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() => _isLoading = true);

                                final selectedState = states.firstWhere(
                                  (state) => state['code'] == selectedStateCode,
                                  orElse: () => {},
                                );
                                final selectedCity = cities.firstWhere(
                                  (city) => city['name'] == selectedCityName,
                                  orElse: () => {},
                                );

                                final filteredState =
                                    Map<String, dynamic>.from(selectedState)
                                      ..remove('cities');

                                final placeData = {
                                  'nameAR': _nameControllerAR.text,
                                  'nameFR': _nameControllerFR.text,
                                  'location': selectedStateCode != null &&
                                          selectedCityName != null
                                      ? '${filteredState['name']} - ${selectedCity['name']}'
                                      : '',
                                  'type': {
                                    'ar': _selectedType == 'youth_house'
                                        ? 'دار الشباب'
                                        : 'مخيم الشباب',
                                    'fr': _selectedType == 'youth_house'
                                        ? 'Auberge des jeunes'
                                        : 'Camp des jeunes',
                                    'en': _selectedType == 'youth_house'
                                        ? 'Youth house'
                                        : 'Youth camp',
                                  },
                                  'spots': int.tryParse(
                                      _NumberOfSpotsController.text),
                                  'phone': _phoneController.text,
                                  'email': _emailController.text,
                                  'facebook': _facebookUrlController.text,
                                  'instagram': _instagramUrlController.text,
                                  'twitter': _twitterUrlController.text,
                                  'imageUrl': _imageUrlController.text
                                          .trim()
                                          .isEmpty
                                      ? 'https://i.ibb.co/4wP1LMmL/20530961.jpg'
                                      : _imageUrlController.text,
                                  'state': filteredState.isEmpty
                                      ? null
                                      : filteredState,
                                  'city': selectedCity.isEmpty
                                      ? null
                                      : selectedCity,
                                };

                                await _storeservices.savePlace(
                                  docId: widget.isEditing
                                      ? (widget.houseData != null
                                          ? widget.houseData!['id']
                                          : null)
                                      : null,
                                  data: placeData,
                                );

                                setState(() => _isLoading = false);

                                final loc = AppLocalizations.of(context)!;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(widget.isEditing
                                        ? loc.youthHouseUpdated
                                        : loc.youthHouseAdded),
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                );

                                Navigator.pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: _isLoading
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        theme.colorScheme.onPrimary,
                                      ),
                                    ),
                                  )
                                : Text(
                                    widget.isEditing ? loc.update : loc.save,
                                    style:
                                        theme.textTheme.titleMedium?.copyWith(
                                      color: theme.colorScheme.onPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
