import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// GET STRING SETTING
  Future<String?> getSetting(String key) async {
    try {
      final doc = await _db.collection('settings').doc(key).get();

      if (doc.exists) {
        return doc['value'].toString();
      }

      return null;
    } catch (e) {
      print("Error getting setting: $e");
      return null;
    }
  }

  /// GET BOOL SETTING
  Future<bool?> getBoolSetting(String key) async {
    try {
      final doc = await _db.collection('settings').doc(key).get();

      if (doc.exists) {
        return doc['value'] as bool;
      }

      return null;
    } catch (e) {
      print("Error getting bool setting: $e");
      return null;
    }
  }

  /// UPDATE / CREATE SETTING
  Future<void> updateSetting(String key, dynamic value) async {
    try {
      await _db.collection('settings').doc(key).set({
        'key': key,
        'value': value,
        'updatedAt': FieldValue.serverTimestamp(),
      });

    } catch (e) {
      print("Error updating setting: $e");
    }
  }
}