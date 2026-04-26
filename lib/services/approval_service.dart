import 'package:cloud_firestore/cloud_firestore.dart';

class ApprovalService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getPendingApprovals() {
    return _db
        .collection('approvals')
        .where('status', isEqualTo: 'PENDING')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> updateApprovalStatus(
      String id,
      String status,
      ) async {

    print("Updating approval: $id -> $status");

    final doc = await _db.collection('approvals').doc(id).get();
    final data = doc.data() as Map<String, dynamic>;

    await _db.collection('approvals').doc(id).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    if (data['type'] == 'EVENT') {
      await _db.collection('events').doc(data['referenceId']).update({
        'status': status == 'APPROVED' ? 'Approved' : 'Rejected',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }
}