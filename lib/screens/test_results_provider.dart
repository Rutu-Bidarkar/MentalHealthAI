
import 'package:flutter/material.dart';
import 'dart:math';

// Model for a single test result
class TestResult {
  final String testId;
  final int score;
  final String label;
  final String msg;
  final Color color;
  final DateTime date;

  TestResult({
    required this.testId,
    required this.score,
    required this.label,
    required this.msg,
    required this.color,
    required this.date,
  });
}

// Manages the state of test results
class TestResultsProvider with ChangeNotifier {
  final Map<String, TestResult> _results = {};

  // Mock data for demonstration
  TestResultsProvider() {
    _results['baseline'] = TestResult(
      testId: 'baseline',
      score: 18,
      label: 'Moderate',
      msg: "You're in an average range.",
      color: const Color(0xFFF4A59C),
      date: DateTime.now().subtract(const Duration(days: 2)),
    );
    _results['depression'] = TestResult(
      testId: 'depression',
      score: 12,
      label: 'Moderate',
      msg: "Moderate depression.",
      color: const Color(0xFFF4A59C),
      date: DateTime.now().subtract(const Duration(days: 1)),
    );
  }

  Map<String, TestResult> get results => _results;

  bool isTestCompleted(String testId) {
    return _results.containsKey(testId);
  }

  int getCompletedCount() {
    return _results.length;
  }

  TestResult? getTestResult(String testId) {
    return _results[testId];
  }

  int getDaysUntilRetake() {
    if (_results.length < 4) return 30; // Assuming 4 basic tests

    DateTime? latestTestDate =
        _results.values.map((r) => r.date).reduce((a, b) => a.isAfter(b) ? a : b);
    final nextRetakeDate = latestTestDate.add(const Duration(days: 30));
    final difference = nextRetakeDate.difference(DateTime.now()).inDays;
    return max(0, difference);
  }

  void addTestResult(TestResult result) {
    _results[result.testId] = result;
    notifyListeners();
  }
}
