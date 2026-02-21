import 'package:cloud_firestore/cloud_firestore.dart';

class ApprovalService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Pending approvals
  Stream<QuerySnapshot> getPendingApprovals() {
    return _db
        .collection('approvals')
        .where('status', isEqualTo: 'PENDING')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// Approve / Reject
  Future<void> updateApprovalStatus(
      String id,
      String status,
      ) {
    return _db.collection('approvals').doc(id).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
