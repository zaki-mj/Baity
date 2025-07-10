import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final List<Map<String, String>> allHouses = [
      {
        'name': loc.youthHouseName1,
        'location': loc.youthHouseLocation1,
      },
      {
        'name': loc.youthHouseName2,
        'location': loc.youthHouseLocation2,
      },
      {
        'name': loc.youthHouseName3,
        'location': loc.youthHouseLocation3,
      },
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.editData),
      ),
      body: ListView.builder(
        itemCount: allHouses.length,
        itemBuilder: (context, index) {
          final house = allHouses[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.home),
              title: Text(house['name']!),
              subtitle: Text(house['location']!),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // TODO: Implement edit logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Edit ${house['name']}')),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
