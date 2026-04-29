import 'package:cloud_firestore/cloud_firestore.dart';
import 'audit_service.dart';

class ApprovalService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final AuditService _auditService = AuditService();

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

    /// UPDATE APPROVAL
    await _db.collection('approvals').doc(id).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    /// SYNC EVENT
    if (data['type'] == 'EVENT') {
      await _db.collection('events').doc(data['referenceId']).update({
        'status': status == 'APPROVED' ? 'Approved' : 'Rejected',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      /// 🔥 AUDIT LOG
      await _auditService.logAction(
        action: status == "APPROVED"
            ? "APPROVE_EVENT"
            : "REJECT_EVENT",
        performedBy: "admin123",
        entityType: "event",
        entityId: data['referenceId'],
        details: "Approval updated",
      );
    }
  }
}