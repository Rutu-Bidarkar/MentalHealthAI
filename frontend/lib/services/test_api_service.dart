// services/test_api_service.dart
//
// API service for psychological tests
// Supports mock mode + real backend + auth token

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/test_models.dart';
import 'dart:developer';

class TestApiService {
  /// 🔗 Backend base URL (Android Emulator)
  static const String baseUrl = 'http://10.0.2.2:8000';

  /// Toggle mock vs real backend
  static const bool useMockData = false;

  /// 🔐 JWT token (set after login)
  static String? token;

  /// Common headers with auth
  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };

  /// ================= LOGIN =================
  static Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        token = data['access_token'];
        log('✅ Login success');
        return true;
      }

      log('❌ Login failed: ${response.statusCode}');
      return false;
    } catch (e) {
      log('❌ Login error: $e');
      return false;
    }
  }

  /// ================= LOAD TEST =================
  static Future<TestData> loadTest(String testId) async {
    if (useMockData) {
      return _loadMockTest(testId);
    } else {
      return _loadTestFromAPI(testId);
    }
  }

  static Future<TestData> _loadTestFromAPI(String testId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/assessment/$testId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return TestData.fromJson(data);
      } else {
        throw Exception('Failed to load test: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading test: $e');
    }
  }

  /// ================= SUBMIT RESULTS =================
  static Future<void> submitTestResults({
    required String testId,
    required Map<String, int> answers,
    required int rawScore,
    required int maxScore,
    required String interpretation,
  }) async {
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 300));
      log('Mock: Test results saved locally');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/assessment/$testId/submit'),
        headers: _headers,
        body: json.encode({
          'test_id': testId,
          'answers': answers,
          'raw_score': rawScore,
          'max_score': maxScore,
          'interpretation': interpretation,
          'submitted_at': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to submit results: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error submitting results: $e');
    }
  }

  /// ================= MOCK DATA =================
  static Future<TestData> _loadMockTest(String testId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    switch (testId) {
      case 'baseline':
        return TestData(
          id: 'baseline',
          title: 'Baseline Wellbeing',
          subtitle: 'WHO-5 Well-Being Index',
          icon: '🌱',
          description: 'Understand your overall mental wellbeing right now.',
          timeframe: 'Over the past 2 weeks...',
          questionCount: 5,
          estimatedTime: '1 minute',
          maxScore: 25,
          nextTestRoute: '/tests/anxiety-screening',
          questions: [
            TestQuestion(
              id: 'q1',
              text: 'I have felt cheerful and in good spirits.',
              type: 'scale',
              options: [
                'At no time',
                'Some of the time',
                'Less than half the time',
                'More than half the time',
                'Most of the time',
                'All of the time',
              ],
              values: [0, 1, 2, 3, 4, 5],
            ),
            TestQuestion(
              id: 'q2',
              text: 'I have felt calm and relaxed.',
              type: 'scale',
              options: [
                'At no time',
                'Some of the time',
                'Less than half the time',
                'More than half the time',
                'Most of the time',
                'All of the time',
              ],
              values: [0, 1, 2, 3, 4, 5],
            ),
            TestQuestion(
              id: 'q3',
              text: 'I have felt active and vigorous.',
              type: 'scale',
              options: [
                'At no time',
                'Some of the time',
                'Less than half the time',
                'More than half the time',
                'Most of the time',
                'All of the time',
              ],
              values: [0, 1, 2, 3, 4, 5],
            ),
            TestQuestion(
              id: 'q4',
              text: 'I woke up feeling fresh and rested.',
              type: 'scale',
              options: [
                'At no time',
                'Some of the time',
                'Less than half the time',
                'More than half the time',
                'Most of the time',
                'All of the time',
              ],
              values: [0, 1, 2, 3, 4, 5],
            ),
            TestQuestion(
              id: 'q5',
              text:
                  'My daily life has been filled with things that interest me.',
              type: 'scale',
              options: [
                'At no time',
                'Some of the time',
                'Less than half the time',
                'More than half the time',
                'Most of the time',
                'All of the time',
              ],
              values: [0, 1, 2, 3, 4, 5],
            ),
          ],
        );

      default:
        throw Exception('Test not found: $testId');
    }
  }
}
