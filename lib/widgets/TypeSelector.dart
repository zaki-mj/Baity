import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TypeSelector extends StatelessWidget {
  final String selectedType;
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
            value: selectedType,
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
            onChanged: onTypeChanged,
          ),
        ),
      ],
    );
  }
}
