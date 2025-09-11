import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StoreServices {
  Future<void> createPlace({
    required String nameAR,
    required String nameFR,
    String? location,
    int? numberOfSpots,
    String? phone,
    String? email,
    String? facebook,
    String? instagram,
    String? twitter,
    String? ImageUrl,
    Map<String, dynamic>? state, // Add state object
    Map<String, dynamic>? city,
    Map<String, dynamic>? type, // Add city object
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection('places').add({
      'nameAR': nameAR,
      'nameFR': nameFR,
      'location': location,
      'imageUrl': ImageUrl,
      'type': type,
      'spots': numberOfSpots,
      'phone': phone,
      'email': email,
      'facebook': facebook,
      'instagram': instagram,
      'twitter': twitter,
      'state': state,
      'city': city,
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

  Future<void> updatePlace(String docId, Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance
          .collection('places')
          .doc(docId)
          .update(data);
    } catch (e) {
      print("Error updating place: $e");
      rethrow;
    }
  }

  /// save function
  Future<void> savePlace({
    String? docId, // if null -> create, else update
    required Map<String, dynamic> data,
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    if (docId == null) {
      //  Create new
      await FirebaseFirestore.instance.collection('places').add({
        ...data,
        'createdBy': uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } else {
      //  Update existing
      await FirebaseFirestore.instance.collection('places').doc(docId).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }


}
