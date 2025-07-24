import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StoreServices {
  Future<void> createPlace({
    required String name,
    String? location,
    String? type,
    String? numberOfSpots,
    String? phone,
    String? email,
    String? facebook,
    String? instagram,
    String? twitter,
    String? description,
    String? ImageUrl,
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
      'facebbok': facebook,
      'instagram': instagram,
      'twitter': description,
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
