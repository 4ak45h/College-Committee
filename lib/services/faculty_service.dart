import 'package:cloud_firestore/cloud_firestore.dart';

class FacultyService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getFaculty() {
    return _db.collection('faculty').snapshots();
  }

  Future<void> addFaculty(Map<String, dynamic> data) {
    return _db.collection('faculty').add({
      ...data,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
