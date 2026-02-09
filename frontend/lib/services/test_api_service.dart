// services/test_api_service.dart
//
// API service for loading test data from bot
// Switch between mock data and real API easily

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/test_models.dart';
import 'dart:developer';

class TestApiService {
  // todo: Replace with your Flask API URL
  static const String baseUrl = 'YOUR_FLASK_API_URL';

  // Set to true to use mock data, false to use real API
  static const bool useMockData = true;

  /// Load test data from API or mock
  static Future<TestData> loadTest(String testId) async {
    if (useMockData) {
      return _loadMockTest(testId);
    } else {
      return _loadTestFromAPI(testId);
    }
  }

  /// Real API call (use when bot is ready)
  static Future<TestData> _loadTestFromAPI(String testId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/tests/$testId'),
        headers: {'Content-Type': 'application/json'},
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

  /// Submit test results to backend
  static Future<void> submitTestResults({
    required String testId,
    required Map<String, int> answers,
    required int rawScore,
    required int maxScore,
    required String interpretation,
  }) async {
    if (useMockData) {
      // Simulate API call
      await Future.delayed(Duration(milliseconds: 300));
      log('Mock: Test results saved locally');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/tests/$testId/submit'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'test_id': testId,
          'answers': answers,
          'raw_score': rawScore,
          'max_score': maxScore,
          'interpretation': interpretation,
          'submitted_at': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to submit results: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error submitting results: $e');
    }
  }

  /// Mock data for testing (same as TypeScript version)
  static Future<TestData> _loadMockTest(String testId) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500));

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

      case 'anxiety-screening':
        return TestData(
          id: 'anxiety-screening',
          title: 'Anxiety Screening',
          subtitle: 'GAD-7 Assessment',
          icon: '🧠',
          description: 'Measure anxiety levels over the past two weeks.',
          timeframe:
              'Over the past 2 weeks, how often have you been bothered by...',
          questionCount: 7,
          estimatedTime: '2 minutes',
          maxScore: 21,
          nextTestRoute: '/tests/depression-screening',
          questions: List.generate(
            7,
            (i) => TestQuestion(
              id: 'q${i + 1}',
              text: 'Anxiety question ${i + 1} - [Bot will generate this]',
              type: 'scale',
              options: [
                'Not at all',
                'Several days',
                'More than half the days',
                'Nearly every day',
              ],
              values: [0, 1, 2, 3],
            ),
          ),
        );

      case 'depression-screening':
        return TestData(
          id: 'depression-screening',
          title: 'Depression Screening',
          subtitle: 'PHQ-9 Assessment',
          icon: '💙',
          description: 'Screen for depression symptoms.',
          timeframe:
              'Over the past 2 weeks, how often have you been bothered by...',
          questionCount: 9,
          estimatedTime: '3 minutes',
          maxScore: 27,
          nextTestRoute: '/tests/stress-resilience',
          questions: List.generate(
            9,
            (i) => TestQuestion(
              id: 'q${i + 1}',
              text: 'Depression question ${i + 1} - [Bot will generate this]',
              type: 'scale',
              options: [
                'Not at all',
                'Several days',
                'More than half the days',
                'Nearly every day',
              ],
              values: [0, 1, 2, 3],
            ),
          ),
        );

      case 'stress-resilience':
        return TestData(
          id: 'stress-resilience',
          title: 'Stress & Resilience',
          subtitle: 'Comprehensive Assessment',
          icon: '⚡',
          description: 'Evaluate your stress levels and coping mechanisms.',
          timeframe: 'In the past month...',
          questionCount: 20,
          estimatedTime: '5 minutes',
          maxScore: 80,
          nextTestRoute: null,
          questions: List.generate(
            20,
            (i) => TestQuestion(
              id: 'q${i + 1}',
              text: 'Stress question ${i + 1} - [Bot will generate this]',
              type: 'scale',
              options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Very Often'],
              values: [0, 1, 2, 3, 4],
            ),
          ),
        );

      default:
        throw Exception('Test not found: $testId');
    }
  }
}
