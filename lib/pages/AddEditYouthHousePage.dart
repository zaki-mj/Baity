import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:baity/services/StoreServices.dart';

StoreServices _storeservices = StoreServices();

class AddEditYouthHousePage extends StatefulWidget {
  final bool isEditing;
  final Map<String, dynamic>? houseData;

  const AddEditYouthHousePage({
    Key? key,
    required this.isEditing,
    this.houseData,
  }) : super(key: key);

  @override
  State<AddEditYouthHousePage> createState() => _AddEditYouthHousePageState();
}

class _AddEditYouthHousePageState extends State<AddEditYouthHousePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _facebookUrlController = TextEditingController();
  final _instagramUrlController = TextEditingController();
  final _twitterUrlController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedType = 'youth_house';
  int _availableSpots = 20;
  double _latitude = 35.0786;
  double _longitude = -2.2047;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.houseData != null) {
      _nameController.text = widget.houseData!['name'] ?? '';
      _locationController.text = widget.houseData!['location'] ?? '';
      _imageUrlController.text = widget.houseData!['imageUrl'] ?? '';
      _phoneController.text = widget.houseData!['phone'] ?? '';
      _emailController.text = widget.houseData!['email'] ?? '';
      _addressController.text = widget.houseData!['address'] ?? '';
      _facebookUrlController.text = widget.houseData!['facebookUrl'] ?? '';
      _instagramUrlController.text = widget.houseData!['instagramUrl'] ?? '';
      _twitterUrlController.text = widget.houseData!['twitterUrl'] ?? '';
      _descriptionController.text = widget.houseData!['description'] ?? '';
      _selectedType = widget.houseData!['type'] ?? 'youth_house';
      _availableSpots = widget.houseData!['availableSpots'] ?? 20;
      _latitude = widget.houseData!['latitude'] ?? 35.0786;
      _longitude = widget.houseData!['longitude'] ?? -2.2047;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
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

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate save delay
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _isLoading = false;
        });

        final loc = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                widget.isEditing ? loc.youthHouseUpdated : loc.youthHouseAdded),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );

        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

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
                          Text(
                            widget.isEditing
                                ? loc.updateYouthHouseInfo
                                : loc.createNewYouthHouse,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.7),
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
                        _buildSectionCard(
                          theme,
                          loc.basicInformation,
                          Icons.info_outline,
                          [
                            _buildTextField(
                              controller: _nameController,
                              label: loc.name,
                              icon: Icons.home,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return loc.pleaseEnterName;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _locationController,
                              label: loc.location,
                              icon: Icons.location_on,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return loc.pleaseEnterLocation;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
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
                            _buildTypeSelector(theme, loc),
                            const SizedBox(height: 16),
                            _buildSpotsSelector(theme, loc),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Contact Information Card
                        _buildSectionCard(
                          theme,
                          loc.contactInformation,
                          Icons.contact_phone,
                          [
                            _buildTextField(
                              controller: _phoneController,
                              label: loc.phone,
                              icon: Icons.phone,
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _emailController,
                              label: loc.email,
                              icon: Icons.email,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _addressController,
                              label: loc.address,
                              icon: Icons.map,
                              maxLines: 2,
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Social Media Card
                        _buildSectionCard(
                          theme,
                          loc.socialMedia,
                          Icons.share,
                          [
                            _buildTextField(
                              controller: _facebookUrlController,
                              label: loc.facebookUrl,
                              icon: Icons.facebook,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _instagramUrlController,
                              label: loc.instagramUrl,
                              icon: Icons.camera_alt,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _twitterUrlController,
                              label: loc.twitterUrl,
                              icon: Icons.alternate_email,
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Description Card
                        _buildSectionCard(
                          theme,
                          loc.description,
                          Icons.description,
                          [
                            _buildTextField(
                              controller: _descriptionController,
                              label: loc.description,
                              icon: Icons.text_fields,
                              maxLines: 4,
                            ),
                          ],
                        ),

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
                            onPressed: () {
                              StoreServices().createPlace(
                                name: _nameController.text,
                                location: _addressController.text,
                                facebook: _facebookUrlController.text,
                                instagram: _instagramUrlController.text,
                                email: _emailController.text,
                                phone: _phoneController.text,
                                twitter: _twitterUrlController.text,
                                description: _descriptionController.text,
                              );
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

  Widget _buildSectionCard(
      ThemeData theme, String title, IconData icon, List<Widget> children) {
    return Card(
      elevation: 6,
      shadowColor: theme.colorScheme.primary.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surface.withOpacity(0.9),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          color: theme.colorScheme.primary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.colorScheme.outline,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.5),
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
    );
  }

  Widget _buildTypeSelector(ThemeData theme, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.type,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.5),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedType,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.category,
                color: theme.colorScheme.primary,
              ),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            items: [
              DropdownMenuItem(
                value: 'youth_house',
                child: Text(loc.tabYouthHouses),
              ),
              DropdownMenuItem(
                value: 'youth_camp',
                child: Text(loc.tabYouthCamps),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _selectedType = value!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSpotsSelector(ThemeData theme, AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${loc.availableSpots}: $_availableSpots',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Slider(
          value: _availableSpots.toDouble(),
          min: 1,
          max: 100,
          divisions: 99,
          activeColor: theme.colorScheme.primary,
          inactiveColor: theme.colorScheme.primary.withOpacity(0.3),
          onChanged: (value) {
            setState(() {
              _availableSpots = value.round();
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '1',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            Text(
              '100',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
