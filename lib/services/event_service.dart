import 'package:cloud_firestore/cloud_firestore.dart';

class EventService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// ✅ Approved events only
  Stream<QuerySnapshot> getEvents() {
    return _db
        .collection('events')
        .where('status', isEqualTo: 'Approved')
        .snapshots();
  }

  /// ✅ Upcoming approved meetings
  Stream<QuerySnapshot> getUpcomingMeetings() {
    return _db
        .collection('events')
        .where('type', isEqualTo: 'MEETING')
        .where('status', isEqualTo: 'Approved')
        .where('date', isGreaterThan: Timestamp.now())
        .limit(5)
        .snapshots();
  }

  /// ✅ CLEAN CREATE (DATA CONSISTENCY FIX)
  Future<void> createEvent(Map<String, dynamic> data) async {
    final docRef = await _db.collection('events').add({
      'title': data['title'] ?? '',
      'committee': data['committee'] ?? '',
      'committeeName': data['committeeName'] ?? '',
      'committeeId': data['committeeId'] ?? '',
      'venue': data['venue'] ?? '',
      'time': data['time'] ?? '',
      'type': data['type'] ?? 'MEETING',

      'date': data['date'], // Timestamp
      'status': 'Draft',

      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await _db.collection('approvals').add({
      'type': 'EVENT',
      'referenceId': docRef.id,
      'title': data['title'],
      'committee': data['committee'],
      'status': 'PENDING',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateEvent(String id, Map<String, dynamic> data) async {
    await _db.collection('events').doc(id).update({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteEvent(String id) async {
    final approvalQuery = await _db
        .collection('approvals')
        .where('referenceId', isEqualTo: id)
        .get();

    for (var doc in approvalQuery.docs) {
      await _db.collection('approvals').doc(doc.id).delete();
    }

    await _db.collection('events').doc(id).delete();
  }

  Future<DocumentSnapshot> getEventById(String id) async {
    return await _db.collection('events').doc(id).get();
  }
}