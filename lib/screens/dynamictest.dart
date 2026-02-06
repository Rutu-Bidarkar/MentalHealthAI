// dynamic_test_page.dart
//
// Dynamic mental health test page that works for all test types
// Replace static test pages with this single dynamic component
//
// Usage in router:
// - /tests/baseline
// - /tests/anxiety-screening
// - /tests/depression-screening
// - /tests/stress-resilience

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ============================================================================
// DATA MODELS
// ============================================================================

class TestQuestion {
  final String id;
  final String text;
  final String type;
  final List<String> options;
  final List<int> values;

  TestQuestion({
    required this.id,
    required this.text,
    required this.type,
    required this.options,
    required this.values,
  });

  factory TestQuestion.fromJson(Map<String, dynamic> json) {
    return TestQuestion(
      id: json['id'],
      text: json['text'],
      type: json['type'],
      options: List<String>.from(json['options']),
      values: List<int>.from(json['values']),
    );
  }
}

class TestInterpretation {
  final String label;
  final Color color;
  final String message;

  TestInterpretation({
    required this.label,
    required this.color,
    required this.message,
  });
}

class TestData {
  final String id;
  final String title;
  final String subtitle;
  final String icon;
  final String description;
  final String timeframe;
  final int questionCount;
  final String estimatedTime;
  final List<TestQuestion> questions;
  final int maxScore;
  final String? nextTestRoute;

  TestData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.description,
    required this.timeframe,
    required this.questionCount,
    required this.estimatedTime,
    required this.questions,
    required this.maxScore,
    this.nextTestRoute,
  });

  factory TestData.fromJson(Map<String, dynamic> json) {
    return TestData(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      icon: json['icon'],
      description: json['description'],
      timeframe: json['timeframe'],
      questionCount: json['questionCount'],
      estimatedTime: json['estimatedTime'],
      questions: (json['questions'] as List)
          .map((q) => TestQuestion.fromJson(q))
          .toList(),
      maxScore: json['maxScore'],
      nextTestRoute: json['nextTest'],
    );
  }

  // Interpretation logic
  TestInterpretation interpret(int rawScore) {
    switch (id) {
      case 'baseline':
        final scaledScore = rawScore * 4;
        if (scaledScore <= 28) {
          return TestInterpretation(
            label: 'Very Low',
            color: const Color(0xFFE89E98),
            message:
                'Your wellbeing score is very low. Professional support is strongly recommended.',
          );
        } else if (scaledScore <= 49) {
          return TestInterpretation(
            label: 'Low',
            color: const Color(0xFFF4C96F),
            message:
                'Your wellbeing is below the healthy threshold. Consider self-care practices and speaking to a professional.',
          );
        } else if (scaledScore <= 70) {
          return TestInterpretation(
            label: 'Moderate',
            color: const Color(0xFFF4A59C),
            message:
                'You\'re in an average range. Keep monitoring and nurturing your wellbeing.',
          );
        }
        return TestInterpretation(
          label: 'Good',
          color: const Color(0xFF7FC29B),
          message: 'Your wellbeing is healthy! Keep up the positive routines.',
        );

      case 'anxiety-screening':
        if (rawScore <= 4) {
          return TestInterpretation(
            label: 'Minimal',
            color: const Color(0xFF7FC29B),
            message: 'Your anxiety levels are minimal.',
          );
        } else if (rawScore <= 9) {
          return TestInterpretation(
            label: 'Mild',
            color: const Color(0xFFF4C96F),
            message:
                'You\'re experiencing mild anxiety. Self-care and monitoring recommended.',
          );
        } else if (rawScore <= 14) {
          return TestInterpretation(
            label: 'Moderate',
            color: const Color(0xFFF4A59C),
            message:
                'Moderate anxiety detected. Consider speaking with a professional.',
          );
        }
        return TestInterpretation(
          label: 'Severe',
          color: const Color(0xFFE89E98),
          message:
              'Severe anxiety detected. Professional support is strongly recommended.',
        );

      case 'depression-screening':
        if (rawScore <= 4) {
          return TestInterpretation(
            label: 'Minimal',
            color: const Color(0xFF7FC29B),
            message: 'Minimal or no depression.',
          );
        } else if (rawScore <= 9) {
          return TestInterpretation(
            label: 'Mild',
            color: const Color(0xFFF4C96F),
            message: 'Mild depression. Monitor your symptoms.',
          );
        } else if (rawScore <= 14) {
          return TestInterpretation(
            label: 'Moderate',
            color: const Color(0xFFF4A59C),
            message: 'Moderate depression. Consider professional support.',
          );
        } else if (rawScore <= 19) {
          return TestInterpretation(
            label: 'Moderately Severe',
            color: const Color(0xFFE89E98),
            message:
                'Moderately severe depression. Professional help recommended.',
          );
        }
        return TestInterpretation(
          label: 'Severe',
          color: const Color(0xFFE89E98),
          message:
              'Severe depression. Immediate professional support is strongly recommended.',
        );

      case 'stress-resilience':
        final percentage = (rawScore / maxScore) * 100;
        if (percentage <= 25) {
          return TestInterpretation(
            label: 'Low Stress',
            color: const Color(0xFF7FC29B),
            message: 'You\'re managing stress well.',
          );
        } else if (percentage <= 50) {
          return TestInterpretation(
            label: 'Moderate Stress',
            color: const Color(0xFFF4C96F),
            message: 'Some stress present. Practice self-care.',
          );
        } else if (percentage <= 75) {
          return TestInterpretation(
            label: 'High Stress',
            color: const Color(0xFFF4A59C),
            message:
                'High stress levels. Consider stress management techniques.',
          );
        }
        return TestInterpretation(
          label: 'Very High Stress',
          color: const Color(0xFFE89E98),
          message: 'Very high stress. Professional support recommended.',
        );

      default:
        return TestInterpretation(
          label: 'Complete',
          color: const Color(0xFF7FC29B),
          message: 'Assessment complete.',
        );
    }
  }
}

// ============================================================================
// MOCK DATA (Replace with API when bot is ready)
// ============================================================================

class MockTestData {
  static Future<TestData> loadTest(String testId) async {
    // Simulate network delay
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
                'All of the time'
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
                'All of the time'
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
                'All of the time'
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
                'All of the time'
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
                'All of the time'
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
            (index) => TestQuestion(
              id: 'q${index + 1}',
              text: 'Anxiety question ${index + 1} - [Bot will generate this]',
              type: 'scale',
              options: [
                'Not at all',
                'Several days',
                'More than half the days',
                'Nearly every day'
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
            (index) => TestQuestion(
              id: 'q${index + 1}',
              text:
                  'Depression question ${index + 1} - [Bot will generate this]',
              type: 'scale',
              options: [
                'Not at all',
                'Several days',
                'More than half the days',
                'Nearly every day'
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
            (index) => TestQuestion(
              id: 'q${index + 1}',
              text: 'Stress question ${index + 1} - [Bot will generate this]',
              type: 'scale',
              options: [
                'Never',
                'Rarely',
                'Sometimes',
                'Often',
                'Very Often'
              ],
              values: [0, 1, 2, 3, 4],
            ),
          ),
        );

      default:
        throw Exception('Test not found: $testId');
    }
  }

// TODO: Replace with real API call when bot is ready
// static Future<TestData> fetchTestFromAPI(String testId) async {
//   final response = await http.get(
//     Uri.parse('YOUR_FLASK_API_URL/api/tests/$testId'),
//   );
//
//   if (response.statusCode == 200) {
//     return TestData.fromJson(json.decode(response.body));
//   } else {
//     throw Exception('Failed to load test');
//   }
// }
}

// ============================================================================
// MAIN WIDGET
// ============================================================================

class DynamicTestPage extends StatefulWidget {
  final String testId;

  const DynamicTestPage({super.key, required this.testId});

  @override
  State<DynamicTestPage> createState() => _DynamicTestPageState();
}

class _DynamicTestPageState extends State<DynamicTestPage> {
  TestData? _testData;
  bool _isLoading = true;
  String? _errorMessage;
  final Map<String, int> _answers = {};
  bool _showResults = false;
  TestInterpretation? _result;

  // Theme colors
  static const Color primaryColor = Color(0xFF6B9BD1);
  static const Color secondaryColor = Color(0xFFA8C5A5);
  static const Color backgroundColor = Color(0xFFF5F1E8);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF6C7A89);
  static const Color borderColor = Color(0xFFE0E0E0);

  @override
  void initState() {
    super.initState();
    _loadTest();
  }

  Future<void> _loadTest() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // TODO: Replace with API call when bot is ready
      // final testData = await MockTestData.fetchTestFromAPI(widget.testId);
      final testData = await MockTestData.loadTest(widget.testId);

      setState(() {
        _testData = testData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  double get _progress {
    if (_testData == null) return 0.0;
    return _answers.length / _testData!.questions.length;
  }

  void _handleSubmit() {
    if (_testData == null) return;

    final rawScore = _testData!.questions.fold<int>(
      0,
      (sum, question) => sum + (_answers[question.id] ?? 0),
    );

    final interpretation = _testData!.interpret(rawScore);

    setState(() {
      _result = interpretation;
      _showResults = true;
    });

    // TODO: Save results to backend/local storage
  }

  void _goToNextTest() {
    if (_testData?.nextTestRoute != null) {
      setState(() {
        _answers.clear();
        _showResults = false;
        _result = null;
      });

      // Extract test ID from route
      final nextTestId = _testData!.nextTestRoute!.split('/').last;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DynamicTestPage(testId: nextTestId),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingView();
    }

    if (_errorMessage != null || _testData == null) {
      return _buildErrorView();
    }

    if (_showResults && _result != null) {
      return _buildResultsView();
    }

    return _buildQuestionView();
  }

  // ============================================================================
  // LOADING VIEW
  // ============================================================================

  Widget _buildLoadingView() {
    return const Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '⏳',
              style: TextStyle(fontSize: 48),
            ),
            SizedBox(height: 16),
            Text(
              'Loading test questions from bot...',
              style: TextStyle(
                color: textSecondary,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'This may take a few seconds',
              style: TextStyle(
                color: textSecondary,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 24),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // ERROR VIEW
  // ============================================================================

  Widget _buildErrorView() {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '❌',
                style: TextStyle(fontSize: 48),
              ),
              const SizedBox(height: 16),
              const Text(
                'Test not found',
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'The test you\'re looking for doesn\'t exist or couldn\'t be loaded.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  '← Back to Tests',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // RESULTS VIEW
  // ============================================================================

  Widget _buildResultsView() {
    final testData = _testData!;
    final result = _result!;
    final rawScore = testData.questions.fold<int>(
      0,
      (sum, question) => sum + (_answers[question.id] ?? 0),
    );
    final percentage = (rawScore / testData.maxScore) * 100;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          // Header
          Container(
            color: cardBackground,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: textPrimary),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            testData.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: textPrimary,
                            ),
                          ),
                          Text(
                            testData.subtitle,
                            style: const TextStyle(
                              fontSize: 14,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Results Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: cardBackground,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(20),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Icon
                    Text(
                      testData.icon,
                      style: const TextStyle(fontSize: 48),
                    ),
                    const SizedBox(height: 16),

                    // Title
                    const Text(
                      'Your Results',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Score Circle
                    SizedBox(
                      width: 160,
                      height: 160,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Background circle
                          const SizedBox(
                            width: 160,
                            height: 160,
                            child: CircularProgressIndicator(
                              value: 1.0,
                              strokeWidth: 10,
                              backgroundColor: borderColor,
                              valueColor:
                                  AlwaysStoppedAnimation(borderColor),
                            ),
                          ),
                          // Progress circle
                          SizedBox(
                            width: 160,
                            height: 160,
                            child: TweenAnimationBuilder<double>(
                              duration: const Duration(milliseconds: 1000),
                              curve: Curves.easeOut,
                              tween: Tween(begin: 0.0, end: percentage / 100),
                              builder: (context, value, child) {
                                return CircularProgressIndicator(
                                  value: value,
                                  strokeWidth: 10,
                                  backgroundColor: Colors.transparent,
                                  valueColor:
                                      AlwaysStoppedAnimation(result.color),
                                  strokeCap: StrokeCap.round,
                                );
                              },
                            ),
                          ),
                          // Score text
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                rawScore.toString(),
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                  color: result.color,
                                ),
                              ),
                              Text(
                                '/ ${testData.maxScore}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Label badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 6),
                      decoration: BoxDecoration(
                        color: result.color.withAlpha(38),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        result.label,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: result.color,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Interpretation box
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '📋 What this means',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            result.message,
                            style: const TextStyle(
                              fontSize: 14.5,
                              color: textPrimary,
                              height: 1.55,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Disclaimer
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor),
                      ),
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 12.5,
                            color: textSecondary,
                            height: 1.5,
                          ),
                          children: [
                            TextSpan(text: '⚠️ '),
                            TextSpan(
                              text: 'Disclaimer: ',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: textPrimary,
                              ),
                            ),
                            TextSpan(
                              text:
                                  'This screening is for informational purposes only and is not a clinical diagnosis. If you are experiencing distress, please consult a licensed mental health professional or contact a helpline.',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                            ),
                            child: const Text(
                              '← Back to Tests',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        if (testData.nextTestRoute != null) ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _goToNextTest,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: secondaryColor,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                              ),
                              child: const Text(
                                'Next Test →',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // QUESTION VIEW
  // ============================================================================

  Widget _buildQuestionView() {
    final testData = _testData!;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          // Header
          Container(
            color: cardBackground,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: textPrimary),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            testData.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: textPrimary,
                            ),
                          ),
                          Text(
                            testData.subtitle,
                            style: const TextStyle(
                              fontSize: 14,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Progress bar
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${testData.icon} ${testData.title}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: textSecondary,
                      ),
                    ),
                    Text(
                      '${_answers.length}/${testData.questions.length}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: _progress,
                    minHeight: 6,
                    backgroundColor: borderColor,
                    valueColor: const AlwaysStoppedAnimation(primaryColor),
                  ),
                ),
              ],
            ),
          ),

          // Questions
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                // Instructions card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardBackground,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(20),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        testData.icon,
                        style: const TextStyle(fontSize: 40),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        testData.timeframe,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Question cards
                ...testData.questions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final question = entry.value;
                  final isAnswered = _answers.containsKey(question.id);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: _buildQuestionCard(question, index, isAnswered),
                  );
                }),

                // Submit button
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 40),
                  child: ElevatedButton(
                    onPressed: _answers.length == testData.questions.length
                        ? _handleSubmit
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: primaryColor.withAlpha(102),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      'See My Results →',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(TestQuestion question, int index, bool isAnswered) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isAnswered ? primaryColor.withAlpha(26) : cardBackground,
        border: Border.all(
          color: isAnswered ? primaryColor : borderColor,
          width: isAnswered ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: isAnswered
            ? [
                BoxShadow(
                  color: primaryColor.withAlpha(51),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isAnswered ? primaryColor : borderColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    question.text,
                    style: const TextStyle(
                      fontSize: 15,
                      color: textPrimary,
                      height: 1.45,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Options
          Padding(
            padding: const EdgeInsets.only(left: 38),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: question.options.asMap().entries.map((entry) {
                final optIndex = entry.key;
                final option = entry.value;
                final value = question.values[optIndex];
                final isSelected = _answers[question.id] == value;

                return InkWell(
                  onTap: () {
                    setState(() {
                      _answers[question.id] = value;
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? primaryColor : backgroundColor,
                      border: Border.all(
                        color: isSelected ? primaryColor : borderColor,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: 13,
                        color: isSelected ? Colors.white : textSecondary,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
