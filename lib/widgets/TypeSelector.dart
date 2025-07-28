import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TypeSelector extends StatelessWidget {
  final String? selectedType;
  final ValueChanged<String?> onTypeChanged;

  const TypeSelector({
    Key? key,
    required this.selectedType,
    required this.onTypeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return DropdownButtonFormField<String>(
      value: selectedType,
      decoration: InputDecoration(
        labelText: loc.type,
        prefixIcon: Icon(
          Icons.category,
          color: theme.colorScheme.primary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: theme.colorScheme.surface,
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
      onChanged: onTypeChanged,
    );
  }
}
