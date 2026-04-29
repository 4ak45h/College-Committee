import 'package:cloud_firestore/cloud_firestore.dart';
import 'audit_service.dart';
import 'settings_service.dart';

class EventService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final AuditService _auditService = AuditService();
  final SettingsService _settingsService = SettingsService();

  /// APPROVED EVENTS ONLY
  Stream<QuerySnapshot> getEvents() {
    return _db
        .collection('events')
        .where('status', isEqualTo: 'Approved')
        .snapshots();
  }

  /// UPCOMING APPROVED MEETINGS
  Stream<QuerySnapshot> getUpcomingMeetings() {
    return _db
        .collection('events')
        .where('type', isEqualTo: 'MEETING')
        .where('status', isEqualTo: 'Approved')
        .where('date', isGreaterThan: Timestamp.now())
        .limit(5)
        .snapshots();
  }

  /// CREATE EVENT
  Future<void> createEvent(Map<String, dynamic> data) async {

    bool approvalRequired = true;
    String defaultStatus = "Draft";

    try {

      final approvalSetting =
      await _settingsService.getBoolSetting("approval_required");

      final statusSetting =
      await _settingsService.getSetting("default_meeting_status");

      if (approvalSetting != null) {
        approvalRequired = approvalSetting;
      }

      if (statusSetting != null && statusSetting.isNotEmpty) {
        defaultStatus = statusSetting;
      }

    } catch (e) {
      print("⚠ Settings fallback used: $e");
    }

    /// 🔥 AUTO APPROVAL LOGIC
    final finalStatus =
    approvalRequired ? defaultStatus : "Approved";

    /// CREATE EVENT
    final docRef = await _db.collection('events').add({
      'title': data['title'] ?? '',
      'committee': data['committee'] ?? '',
      'committeeName': data['committeeName'] ?? '',
      'committeeId': data['committeeId'] ?? '',
      'venue': data['venue'] ?? '',
      'time': data['time'] ?? '',
      'type': data['type'] ?? 'MEETING',
      'date': data['date'],
      'status': finalStatus,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    /// CREATE APPROVAL ONLY IF ENABLED
    if (approvalRequired) {
      await _db.collection('approvals').add({
        'type': 'EVENT',
        'referenceId': docRef.id,
        'title': data['title'],
        'committee': data['committee'],
        'status': 'PENDING',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    /// AUDIT LOG
    await _auditService.logAction(
      action: "CREATE_EVENT",
      performedBy: "admin123",
      entityType: "event",
      entityId: docRef.id,
      details: "Event created: ${data['title']}",
    );
  }

  /// UPDATE EVENT
  Future<void> updateEvent(String id, Map<String, dynamic> data) async {
    await _db.collection('events').doc(id).update({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// DELETE EVENT
  Future<void> deleteEvent(String id) async {

    final approvalQuery = await _db
        .collection('approvals')
        .where('referenceId', isEqualTo: id)
        .get();

    for (var doc in approvalQuery.docs) {
      await _db.collection('approvals').doc(doc.id).delete();
    }

    await _db.collection('events').doc(id).delete();

    /// AUDIT LOG
    await _auditService.logAction(
      action: "DELETE_EVENT",
      performedBy: "admin123",
      entityType: "event",
      entityId: id,
      details: "Event deleted",
    );
  }

  /// GET SINGLE EVENT
  Future<DocumentSnapshot> getEventById(String id) async {
    return await _db.collection('events').doc(id).get();
  }
}