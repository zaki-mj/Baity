import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteService extends ChangeNotifier {
  FavoriteService._privateConstructor();
  static final FavoriteService instance = FavoriteService._privateConstructor();

  static const String _storageKey = 'favorite_houses';
  SharedPreferences? _prefs;
  Map<String, Map<String, dynamic>> _favorites = {};

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs!.getString(_storageKey);
    if (raw != null && raw.isNotEmpty) {
      try {
        final decoded = json.decode(raw) as Map<String, dynamic>;
        _favorites = decoded.map((key, value) => MapEntry(key, Map<String, dynamic>.from(value as Map)));
        // Ensure older saved favorites include explicit localized type labels
        await _migrateStoredFavorites();
      } catch (e) {
        _favorites = {};
      }
    }
    notifyListeners();
  }

  Map<String, Map<String, dynamic>> get favorites => Map.unmodifiable(_favorites);

  bool isFavorite(String? id) {
    if (id == null) return false;
    return _favorites.containsKey(id);
  }

  Future<void> addFavorite(String id, Map<String, dynamic> data) async {
    // Store the data map as-is; _encodeDeep will handle Firestore types for JSON safety
    print('========== DEBUG: addFavorite called ==========');
    print('ID: $id');
    print('FULL DATA BEFORE SAVE:');
    print(data);
    print('TYPE FIELD: ${data['type']}');
    print('TYPE IS MAP: ${data['type'] is Map}');
    if (data['type'] is Map) {
      print('TYPE[ar]: ${(data['type'] as Map)['ar']}');
      print('TYPE[fr]: ${(data['type'] as Map)['fr']}');
    }
    _favorites[id] = data;
    await _save();
    print('AFTER _save(), _favorites[$id] = ${_favorites[id]}');
    print('=========================================');
    notifyListeners();
  }

  Future<void> _migrateStoredFavorites() async {
    // No migration needed; data is stored and restored as-is
  }

  Future<void> removeFavorite(String id) async {
    _favorites.remove(id);
    await _save();
    notifyListeners();
  }

  Future<void> toggleFavorite(String id, Map<String, dynamic>? data) async {
    if (isFavorite(id)) {
      await removeFavorite(id);
    } else {
      if (data != null) await addFavorite(id, data);
    }
  }

  Future<void> _save() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
    // Convert any non-JSON-serializable Firestore types (e.g., Timestamp)
    final Map<String, dynamic> safeMap = _favorites.map((key, value) => MapEntry(key, _encodeDeep(value)));
    final encoded = json.encode(safeMap);
    await _prefs!.setString(_storageKey, encoded);
  }

  dynamic _encodeDeep(dynamic value) {
    if (value == null) return null;
    if (value is String || value is num || value is bool) return value;
    if (value is Timestamp) return value.toDate().toIso8601String();
    if (value is DateTime) return value.toIso8601String();
    if (value is GeoPoint) return {'latitude': value.latitude, 'longitude': value.longitude};
    if (value is DocumentReference) return value.path;
    if (value is Map) {
      return value.map((k, v) => MapEntry(k.toString(), _encodeDeep(v)));
    }
    if (value is Iterable) {
      return value.map((e) => _encodeDeep(e)).toList();
    }
    // Fallback to string representation
    return value.toString();
  }
}
