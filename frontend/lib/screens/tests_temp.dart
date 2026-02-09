
// tests_page_with_provider.dart
// This version uses Provider for state management (like React Context)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'test_results_provider.dart';

// Theme constants (ideally in a separate theme.dart file)
class AppTheme {
  const AppTheme._();
  static const double borderRadius = 16.0;

  static final BoxShadow cardShadow = BoxShadow(
    color: const Color(0xFF6B9BD1).withAlpha(38), // 15% opacity
    blurRadius: 32,
    offset: const Offset(0, 8),
  );
}

class AppColors {
  const AppColors._();

  static const Color background = Color(0xFFF5F9FC);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF2D3748);
  static const Color textSecondary = Color(0xFF718096);
  static const Color primary = Color(0xFF6B9BD1);
  static const Color success = Color(0xFF48BB78);
}

// Test model
class TestItem {
  final String id;
  final String name;
  final String subtitle;
  final String duration;
  final int questions;
  final String icon;
  final String path;

  const TestItem({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.duration,
    required this.questions,
    required this.icon,
    required this.path,
  });
}

// Test info model
class TestInfo {
  final String id;
  final String title;
  final int max;

  const TestInfo({
    required this.id,
    required this.title,
    required this.max,
  });
}

class TestsPage extends StatelessWidget {
  const TestsPage({super.key});

  // Basic tests data
  final List<TestItem> basicTests = const [
    TestItem(
      id: "baseline",
      name: "Baseline Wellbeing",
      subtitle: "WHO-5 Well-Being Index",
      duration: "1 min",
      questions: 5,
      icon: "🌱",
      path: "/test/baseline",
    ),
    TestItem(
      id: "depression",
      name: "Depression Screening",
      subtitle: "PHQ-9 Patient Health Questionnaire",
      duration: "2 min",
      questions: 9,
      icon: "🌙",
      path: "/test/depression",
    ),
    TestItem(
      id: "anxiety",
      name: "Anxiety Screening",
      subtitle: "GAD-7 Generalized Anxiety Disorder Scale",
      duration: "1.5 min",
      questions: 7,
      icon: "🌊",
      path: "/test/anxiety",
    ),
    TestItem(
      id: "stress",
      name: "Stress & Resilience",
      subtitle: "Perceived Stress & Coping Assessment",
      duration: "3 min",
      questions: 20,
      icon: "🔥",
      path: "/test/stress",
    ),
  ];

  final List<TestInfo> testInfo = const [
    TestInfo(id: "baseline", title: "Baseline Wellbeing", max: 25),
    TestInfo(id: "depression", title: "Depression Screening", max: 27),
    TestInfo(id: "anxiety", title: "Anxiety Screening", max: 21),
    TestInfo(id: "stress", title: "Stress & Resilience", max: 80),
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TestResultsProvider(),
      child: Consumer<TestResultsProvider>(
        builder: (context, testResults, child) {
          final completedCount = testResults.getCompletedCount();
          final totalTests = basicTests.length;
          final allTestsCompleted = completedCount == totalTests;
          final daysLeft = testResults.getDaysUntilRetake();

          return Scaffold(
            backgroundColor: AppColors.background,
            body: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildOverviewCard(completedCount, totalTests),
                        const SizedBox(height: 24),
                        _buildTestList(context, testResults),
                        const SizedBox(height: 24),
                        if (allTestsCompleted) ...[
                          _buildCumulativeScoreSummary(context, testResults),
                          const SizedBox(height: 24),
                          _buildRetakeTimer(daysLeft),
                          const SizedBox(height: 24),
                          _buildAdditionalAssessment(isCompleted: true),
                        ] else
                          _buildAdditionalAssessment(isCompleted: false),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, size: 24),
            onPressed: () => Navigator.pop(context),
            color: AppColors.textPrimary,
            padding: const EdgeInsets.all(8),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mental Health Assessments',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Help us understand you better',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard(int completedCount, int totalTests) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Complete Basic Assessment',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '4 tests, 41 questions total • ~7.5 minutes',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xE6FFFFFF),
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Progress',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xE6FFFFFF),
                    ),
                  ),
                  Text(
                    '$completedCount/$totalTests completed',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: totalTests > 0 ? completedCount / totalTests : 0,
                  backgroundColor: Colors.white.withAlpha(77),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  minHeight: 8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTestList(BuildContext context, TestResultsProvider testResults) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Assessment Tests',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        ...basicTests.asMap().entries.map((entry) {
          final index = entry.key;
          final test = entry.value;
          final completed = testResults.isTestCompleted(test.id);
          final isLocked =
              index > 0 && !testResults.isTestCompleted(basicTests[index - 1].id);

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildTestCard(context, test, completed, isLocked),
          );
        }),
      ],
    );
  }

  Widget _buildTestCard(
    BuildContext context,
    TestItem test,
    bool completed,
    bool isLocked,
  ) {
    return Opacity(
      opacity: isLocked ? 0.6 : 1.0,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          boxShadow: [AppTheme.cardShadow],
          border: Border.all(
            color: completed ? AppColors.success : Colors.transparent,
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: (completed ? AppColors.success : AppColors.primary)
                        .withAlpha(51),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    completed ? '✓' : test.icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              test.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          if (completed)
                            const Icon(
                              Icons.check_circle,
                              size: 20,
                              color: AppColors.success,
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            test.duration,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            '${test.questions} questions',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (isLocked)
                        const Text(
                          'Complete previous test to unlock',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            fontStyle: FontStyle.italic,
                          ),
                        )
                      else if (!completed)
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => Navigator.pushNamed(context, test.path),
                            borderRadius: BorderRadius.circular(10),
                            child: Ink(
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              child: const Text(
                                'Start Test',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (isLocked)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: AppColors.textSecondary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCumulativeScoreSummary(
    BuildContext context,
    TestResultsProvider testResults,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        boxShadow: [AppTheme.cardShadow],
        border: Border.all(
          color: AppColors.success,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📊 Your Test Summary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'All assessments completed',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...testInfo.map((test) {
            final result = testResults.getTestResult(test.id);
            if (result == null) return const SizedBox.shrink();

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: result.color.withAlpha(17),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: result.color.withAlpha(51),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            test.title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            result.msg,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: result.color.withAlpha(34),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        result.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: result.color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRetakeTimer(int daysLeft) {
    return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          boxShadow: [AppTheme.cardShadow],
        ),
        child: Row(
          children: [
            const Icon(Icons.timer_outlined, color: AppColors.primary, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Retake Assessments",
                    style: TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.w600, 
                      color: AppColors.textPrimary
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "You can retake these tests in $daysLeft days to track your progress.",
                    style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _buildAdditionalAssessment({required bool isCompleted}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Row(
        children: [
          const Icon(Icons.star_outline, color: AppColors.primary, size: 28),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Additional Assessments",
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.w600, 
                    color: AppColors.textPrimary
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Explore more tests to gain deeper insights.",
                  style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("Explore"),
          ),
        ],
      ),
    );
  }
}
