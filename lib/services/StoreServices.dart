import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StoreServices {
  Future<void> createPlace({
    required String name,
    String? location,
    String? type,
    int? numberOfSpots,
    String? phone,
    String? email,
    String? facebook,
    String? instagram,
    String? twitter,
    String? description,
    String? ImageUrl,
    Map<String, dynamic>? state, // Add state object
    Map<String, dynamic>? city,  // Add city object
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection('places').add({
      'name': name,
      'location': location,
      'ImageUrl': ImageUrl,
      'type': type,
      'spots': numberOfSpots,
      'phone': phone,
      'email': email,
      'facebook': facebook,
      'instagram': instagram,
      'twitter': twitter,
      'description': description,
      'state': state, // Store the state object
      'city': city,   // Store the city object
      'createdBy': uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getAllPlaces() {
    return FirebaseFirestore.instance
        .collection('places')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
