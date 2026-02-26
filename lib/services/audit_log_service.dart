import 'package:flutter/material.dart';

class AuditLogModel {
  final String action;
  final String category;
  final DateTime timestamp;

  AuditLogModel({
    required this.action,
    required this.category,
    required this.timestamp,
  });
}

class AuditLogService extends ChangeNotifier {
  static final AuditLogService _instance = AuditLogService._internal();
  factory AuditLogService() => _instance;
  AuditLogService._internal();

  final List<AuditLogModel> _logs = [];

  List<AuditLogModel> get logs => List.unmodifiable(_logs);

  void addLog(String action, String category) {
    _logs.insert(
      0,
      AuditLogModel(
        action: action,
        category: category,
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void clearLogs() {
    _logs.clear();
    notifyListeners();
  }
}