import 'package:cloud_firestore/cloud_firestore.dart';

class CommitteeService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Fetch all committees (real-time)
  Stream<QuerySnapshot> getCommittees() {
    return _db
        .collection('committees')
        .where('isActive', isEqualTo: true)
        .snapshots();
  }

  /// Create new committee
  Future<void> createCommittee(Map<String, dynamic> data) {
    return _db.collection('committees').add({
      ...data,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Fetch single committee
  Future<DocumentSnapshot> getCommitteeById(String id) {
    return _db.collection('committees').doc(id).get();
  }
}
