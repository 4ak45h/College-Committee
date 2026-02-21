import 'package:cloud_firestore/cloud_firestore.dart';

class EventService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// All events & meetings
  Stream<QuerySnapshot> getEvents() {
    return _db
        .collection('events')
        .orderBy('date')
        .snapshots();
  }

  /// Upcoming meetings (Dashboard dropdown)
  Stream<QuerySnapshot> getUpcomingMeetings() {
    return _db
        .collection('events')
        .where('type', isEqualTo: 'MEETING')
        .where('date', isGreaterThan: Timestamp.now())
        .orderBy('date')
        .limit(5)
        .snapshots();
  }

  Future<void> createEvent(Map<String, dynamic> data) {
    return _db.collection('events').add({
      ...data,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
