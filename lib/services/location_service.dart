import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class AlgeriaLocationService {
  static List<dynamic>? _states;

  static Future<void> load() async {
    if (_states != null) return;
    final String data =
        await rootBundle.loadString('lib/assets/data/algeria_cities.json');
    _states = json.decode(data);
  }

  static Future<List<Map<String, dynamic>>> getStates(Locale locale) async {
    await load();
    String lang = locale.languageCode;
    return _states!
        .map<Map<String, dynamic>>((state) => {
              'code': state['code'],
              'name': lang == 'ar' ? state['name_ar'] : state['name_fr'],
              'name_ar': state['name_ar'],
              'name_fr': state['name_fr'],
              'cities': state['cities'],
            })
        .toList();
  }

  static Future<List<Map<String, dynamic>>> getCitiesForState(
      String stateCode, Locale locale) async {
    await load();
    String lang = locale.languageCode;
    final state =
        _states!.firstWhere((s) => s['code'] == stateCode, orElse: () => null);
    if (state == null) return [];
    return (state['cities'] as List)
        .map<Map<String, dynamic>>((city) => {
              'name': lang == 'ar' ? city['name_ar'] : city['name_fr'],
              'name_ar': city['name_ar'],
              'name_fr': city['name_fr'],
            })
        .toList();
  }
}
