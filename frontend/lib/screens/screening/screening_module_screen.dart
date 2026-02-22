// screening_module_screen.dart
// Shows one question at a time with a progress bar.
// Handles Yes/No (tap tiles) and Likert (chip row) responses.
// Module 3 (Psychosis) safety items trigger crisis interrupt on positive answer.
// Module 8 (Cognitive Decline) has an optional informant section of 5 questions.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'screening_data.dart';
import 'screening_results_screen.dart';
import 'crisis_interrupt_screen.dart';
import 'ai_report.dart';

class ScreeningModuleScreen extends StatefulWidget {
  final ScreeningModule module;
  final VoidCallback onReturnHome;

  const ScreeningModuleScreen({
    super.key,
    required this.module,
    required this.onReturnHome,
  });

  @override
  State<ScreeningModuleScreen> createState() => _ScreeningModuleScreenState();
}

class _ScreeningModuleScreenState extends State<ScreeningModuleScreen> {
  // Primary question list for the current module
  late List<ScreeningQuestion> _questions;

  // For Module 8: optional informant section
  bool _inInformantSection = false;
  bool _informantChosen = false;
  bool _doInformant = false;

  // Index within the current section
  int _currentIndex = 0;

  // Answers: questionId → numeric value (0/1 for Yes/No, 0–4 for Likert)
  final Map<String, int> _answers = {};
  final Map<String, int> _informantAnswers = {};

  // Currently selected value for the displayed question
  int? _selectedValue;

  @override
  void initState() {
    super.initState();
    _questions = questionsForModule(widget.module);
  }

  // ── Current question helpers ────────────────────────────────────────────────

  ScreeningQuestion get _currentQuestion {
    if (_inInformantSection) {
      return informantQuestionsForModule(widget.module)[_currentIndex];
    }
    return _questions[_currentIndex];
  }

  int? _savedAnswerForCurrent() {
    final q = _currentQuestion;
    if (_inInformantSection) return _informantAnswers[q.id];
    return _answers[q.id];
  }

  int get _globalIndex {
    if (_inInformantSection) {
      return _questions.length + _currentIndex;
    }
    return _currentIndex;
  }

  int get _totalQuestions {
    if (_inInformantSection || _doInformant) {
      return _questions.length +
          informantQuestionsForModule(widget.module).length;
    }
    return _questions.length;
  }

  bool get _isLastQuestion {
    if (_inInformantSection) {
      return _currentIndex ==
          informantQuestionsForModule(widget.module).length - 1;
    }
    return _currentIndex == _questions.length - 1;
  }

  // ── Navigation ──────────────────────────────────────────────────────────────

  void _handleBack() {
    setState(() {
      _selectedValue = null;
      if (_inInformantSection && _currentIndex == 0) {
        // Back to informant choice screen
        _inInformantSection = false;
        _informantChosen = false;
        _currentIndex = _questions.length - 1;
        _selectedValue = _answers[_currentQuestion.id];
      } else if (_currentIndex > 0) {
        _currentIndex--;
        _selectedValue = _inInformantSection
            ? _informantAnswers[_currentQuestion.id]
            : _answers[_currentQuestion.id];
      } else {
        Navigator.pop(context);
      }
    });
  }

  void _handleNext() {
    if (_selectedValue == null) return;
    final q = _currentQuestion;

    // Save answer
    if (_inInformantSection) {
      _informantAnswers[q.id] = _selectedValue!;
    } else {
      _answers[q.id] = _selectedValue!;
    }

    // Safety check: any module with safety items (e.g. Module 3, Module 7 item m7_7)
    if (q.isSafetyItem && _selectedValue == 1) {
      _triggerCrisisInterrupt();
      return;
    }

    if (_isLastQuestion) {
      _finishSection();
    } else {
      setState(() {
        _currentIndex++;
        _selectedValue = _inInformantSection
            ? _informantAnswers[_currentQuestion.id]
            : _answers[_currentQuestion.id];
      });
    }
  }

  void _finishSection() {
    final hasInformant = moduleHasInformant(widget.module);
    if (hasInformant && !_inInformantSection && !_informantChosen) {
      // Offer informant section for Module 8
      setState(() {
        _informantChosen = true;
        _selectedValue = null;
      });
    } else {
      _showResults();
    }
  }

  void _triggerCrisisInterrupt() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => CrisisInterruptScreen(
          onReturnHome: widget.onReturnHome,
        ),
      ),
    );
  }

  Future<void> _showResults() async {
    final band = _computeBand();
    _postSession(band);

    // Show loading overlay while Gemini generates the report
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _ReportLoadingDialog(),
    );

    AiReport? report;
    try {
      final payload = {
        'module': widget.module.name,
        'module_name': _moduleTitle(),
        'answers': _answers,
        if (moduleHasInformant(widget.module))
          'informant_answers': _informantAnswers,
        'result_band': band.label,
        'safety_flags': questionsForModule(widget.module)
            .where((q) => q.isSafetyItem && (_answers[q.id] ?? 0) >= 1)
            .map((q) => q.id)
            .toList(),
      };
      final res = await http.post(
        Uri.parse('http://127.0.0.1:5000/api/screening/report'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      ).timeout(const Duration(seconds: 30));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['report'] != null) {
          report = AiReport.fromJson(data['report']);
        }
      }
    } catch (e) {
      debugPrint('AI Report Error: $e');
      // Silently fall back — report will be null
    }

    if (!mounted) return;
    Navigator.pop(context); // close loading dialog

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ScreeningResultsScreen(
          band: band,
          moduleName: _moduleTitle(),
          report: report,
          onReturnHome: widget.onReturnHome,
        ),
      ),
    );
  }

  ScreeningResultBand _computeBand() {
    switch (widget.module) {
      case ScreeningModule.m1:
        return scoreModule1(_answers);
      case ScreeningModule.m2:
        return scoreModule2(_answers);
      case ScreeningModule.m3:
        return scoreModule3(_answers);
      case ScreeningModule.m4:
        return scoreModule4(_answers);
      case ScreeningModule.m5:
        return scoreModule5(_answers);
      case ScreeningModule.m6:
        return scoreModule6(_answers);
      case ScreeningModule.m7:
        return scoreModule7(_answers);
      case ScreeningModule.m8:
        return scoreModule8(_answers, _informantAnswers);
      case ScreeningModule.m9:
        return scoreModule9(_answers);
    }
  }

  String _moduleTitle() {
    final meta = allModules.firstWhere((m) => m.module == widget.module);
    return meta.title;
  }

  Future<void> _postSession(ScreeningResultBand band) async {
    try {
      final payload = {
        'module': widget.module.name,
        'module_name': _moduleTitle(),
        'disclaimer_acknowledged': true,
        'answers': _answers,
        if (moduleHasInformant(widget.module))
          'informant_answers': _informantAnswers,
        'result_band': band.label,
        'submitted_at': DateTime.now().toIso8601String(),
      };
      await http.post(
        Uri.parse('http://127.0.0.1:5000/api/screening/session'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );
    } catch (e) {
      debugPrint('Session Post Error: $e');
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Module 8 — informant choice interstitial
    if (moduleHasInformant(widget.module) &&
        _informantChosen &&
        !_inInformantSection) {
      return _buildInformantChoiceScreen(theme);
    }

    final q = _currentQuestion;
    final savedAnswer = _savedAnswerForCurrent();
    if (_selectedValue == null && savedAnswer != null) {
      _selectedValue = savedAnswer;
    }

    final totalQ = _totalQuestions;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ───────────────────────────────────────────────────────
            Container(
              color: theme.cardColor,
              padding: const EdgeInsets.fromLTRB(8, 12, 16, 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: _handleBack,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _moduleTitle(),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${_globalIndex + 1} of $totalQ',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Progress bar ─────────────────────────────────────────────────
            LinearProgressIndicator(
              value: (_globalIndex + 1) / totalQ,
              minHeight: 4,
              backgroundColor: theme.dividerColor,
              valueColor: const AlwaysStoppedAnimation(Color(0xFF6B9BD1)),
            ),

            // ── Question area ─────────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question label chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6B9BD1).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _inInformantSection
                            ? 'Informant · ${_currentIndex + 1} of ${informantQuestionsForModule(widget.module).length}'
                            : 'Question ${_currentIndex + 1}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B9BD1),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Question text
                    Text(
                      q.text,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 17,
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Answer options
                    if (q.type == QuestionType.yesNo)
                      _buildYesNo()
                    else
                      _buildLikert(theme),
                  ],
                ),
              ),
            ),

            // ── Navigation buttons ────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              decoration: BoxDecoration(
                color: theme.cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  OutlinedButton(
                    onPressed: _handleBack,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: theme.dividerColor),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('← Back',
                        style: TextStyle(color: Color(0xFF718096))),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _selectedValue != null ? _handleNext : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6B9BD1),
                        disabledBackgroundColor:
                            const Color(0xFF6B9BD1).withValues(alpha: 0.3),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                      child: Text(
                        _isLastQuestion ? 'See Results' : 'Next →',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Yes / No tap tiles ──────────────────────────────────────────────────────

  Widget _buildYesNo() {
    return Column(
      children: [
        _yesNoTile('Yes', 1),
        const SizedBox(height: 12),
        _yesNoTile('No', 0),
      ],
    );
  }

  Widget _yesNoTile(String label, int value) {
    final isSelected = _selectedValue == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedValue = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF6B9BD1).withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF6B9BD1)
                : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 22,
              color: isSelected
                  ? const Color(0xFF6B9BD1)
                  : const Color(0xFFCBD5E0),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? const Color(0xFF6B9BD1)
                    : const Color(0xFF2D3748),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Likert chip row ─────────────────────────────────────────────────────────

  Widget _buildLikert(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 10,
          children: List.generate(likertLabels.length, (i) {
            final isSelected = _selectedValue == i;
            return GestureDetector(
              onTap: () => setState(() => _selectedValue = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF6B9BD1)
                      : theme.cardColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF6B9BD1)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Text(
                  likertLabels[i],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected ? Colors.white : const Color(0xFF2D3748),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 12),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('0 = Never',
                style: TextStyle(fontSize: 11, color: Color(0xFF718096))),
            Text('4 = Almost Always',
                style: TextStyle(fontSize: 11, color: Color(0xFF718096))),
          ],
        ),
      ],
    );
  }

  // ── Module 8 Informant choice screen ────────────────────────────────────────

  Widget _buildInformantChoiceScreen(ThemeData theme) {
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.cardColor,
        elevation: 0,
        title: Text('Cognitive Decline',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              _informantChosen = false;
              _currentIndex = _questions.length - 1;
              _selectedValue = _answers[_currentQuestion.id];
            });
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.group_outlined,
                size: 40, color: Color(0xFF6B9BD1)),
            const SizedBox(height: 20),
            Text('Optional: Informant Section',
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text(
              'There are 5 optional questions for someone who knows you well '
              '(a family member, friend, or carer). Their input can help '
              'provide a fuller picture of your cognitive health.',
              style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF718096),
                  height: 1.6),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _doInformant = true;
                    _inInformantSection = true;
                    _currentIndex = 0;
                    _selectedValue = null;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B9BD1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: const Text('Add Informant Responses',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  _doInformant = false;
                  _showResults();
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Skip & See Results',
                    style:
                        TextStyle(color: Color(0xFF718096), fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Loading dialog shown while Gemini generates the report ───────────────────

class _ReportLoadingDialog extends StatelessWidget {
  const _ReportLoadingDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 52,
              height: 52,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor:
                    AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Generating your report…',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Our AI is analysing your responses.\nThis takes a few seconds.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF718096),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
