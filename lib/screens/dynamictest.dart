// dynamic_test_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/test_models.dart';
import '../services/test_api_service.dart';
import 'test_results_provider.dart';

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
      final testData = await TestApiService.loadTest(widget.testId);
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

  Future<void> _handleSubmit() async {
    if (_testData == null) return;

    final rawScore = _testData!.questions.fold<int>(
      0,
      (sum, question) => sum + (_answers[question.id] ?? 0),
    );

    final interpretation = _testData!.interpret(rawScore);

    await TestApiService.submitTestResults(
      testId: _testData!.id,
      answers: _answers,
      rawScore: rawScore,
      maxScore: _testData!.maxScore,
      interpretation: interpretation.label,
    );

    // Update provider
    final resultsProvider = context.read<TestResultsProvider>();
    resultsProvider.addTestResult(TestResult(
      testId: _testData!.id,
      score: rawScore,
      label: interpretation.label,
      msg: interpretation.message,
      color: interpretation.color,
      date: DateTime.now(),
    ));

    setState(() {
      _result = interpretation;
      _showResults = true;
    });
  }

  void _goToNextTest() {
    if (_testData?.nextTestRoute != null) {
      // Extract test ID from route
      final nextTestId = _testData!.nextTestRoute!.split('/').last;
      Navigator.pushReplacementNamed(context, '/test/$nextTestId');
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
