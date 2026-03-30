import 'package:cloud_firestore/cloud_firestore.dart';

class CommitteeService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Fetch all active committees
  Stream<QuerySnapshot> getCommittees() {
    return _db
        .collection('committees')
        .where('isActive', isEqualTo: true)
        .snapshots();
  }

  /// Create new committee
  Future<void> createCommittee(Map<String, dynamic> data) async {
    await _db.collection('committees').add({
      ...data,
      'isActive': true,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Update committee
  Future<void> updateCommittee(String id, Map<String, dynamic> data) {
    return _db.collection('committees').doc(id).update({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Deactivate committee
  Future<void> deactivateCommittee(String id) {
    return _db.collection('committees').doc(id).update({
      'isActive': false,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Reactivate committee
  Future<void> reactivateCommittee(String id) {
    return _db.collection('committees').doc(id).update({
      'isActive': true,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Fetch single committee
  Future<DocumentSnapshot> getCommitteeById(String id) {
    return _db.collection('committees').doc(id).get();
  }

  /// =========================
  /// Committee Members Section
  /// =========================

  /// Add member to committee
  Future<void> addCommitteeMember(Map<String, dynamic> data) {
    return _db.collection('committee_members').add({
      ...data,
      'joinedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Get committee members
  Stream<QuerySnapshot> getCommitteeMembers(String committeeId) {
    return _db
        .collection('committee_members')
        .where('committeeId', isEqualTo: committeeId)
        .snapshots();
  }

  /// Update member role
  Future<void> updateMemberRole(String memberId, String role) {
    return _db.collection('committee_members').doc(memberId).update({
      'role': role,
    });
  }

  /// Remove member
  Future<void> removeMember(String memberId) {
    return _db.collection('committee_members').doc(memberId).delete();
  }
}