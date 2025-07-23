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
}) async {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  await FirebaseFirestore.instance.collection('places').add({
    'name': name,
    'location': location,
    'type': type,
    'spots': numberOfSpots,
    'phone': phone,
    'email':email,
    'facebbok':facebook,
    'instagram': instagram,
    'twitter': description,
    'createdBy': uid,
    'createdAt': FieldValue.serverTimestamp(),
  });
}
}
