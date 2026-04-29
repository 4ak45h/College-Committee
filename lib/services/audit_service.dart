import 'package:cloud_firestore/cloud_firestore.dart';

class AuditService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> logAction({
    required String action,
    required String performedBy,
    required String entityType,
    required String entityId,
    String? details,
  }) async {
    await _db.collection('audit_logs').add({
      'action': action,
      'performedBy': performedBy,
      'entityType': entityType,
      'entityId': entityId,
      'details': details ?? '',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}