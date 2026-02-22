// screening_results_screen.dart
// Coloured result band header + AI-generated clinical report card.

import 'package:flutter/material.dart';
import 'screening_data.dart';
import 'ai_report.dart';

class ScreeningResultsScreen extends StatelessWidget {
  final ScreeningResultBand band;
  final String moduleName;
  final AiReport? report;
  final VoidCallback onReturnHome;

  const ScreeningResultsScreen({
    super.key,
    required this.band,
    required this.moduleName,
    this.report,
    required this.onReturnHome,
  });

  @override
  Widget build(BuildContext context) {
    final color = band.color;
    final bgColor = color.withValues(alpha: 0.08);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Coloured band header ──────────────────────────────────────────
            Container(
              color: color,
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                children: [
                  Icon(
                    band.label == 'Low'
                        ? Icons.check_circle_outline
                        : band.label == 'Monitor'
                            ? Icons.info_outline
                            : Icons.warning_amber_outlined,
                    color: Colors.white,
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    band.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    moduleName,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // ── Scrollable body ───────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Band copy box
                    _SectionCard(
                      color: color,
                      bgColor: bgColor,
                      child: Text(
                        band.copy,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF2D3748),
                          height: 1.6,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    if (report != null) ...[
                      const SizedBox(height: 20),

                      // ── AI Report ──────────────────────────────────────────
                      _reportHeader(),

                      const SizedBox(height: 14),

                      // Score summary
                      _ReportSection(
                        icon: Icons.assessment_outlined,
                        iconColor: const Color(0xFF6366F1),
                        title: 'Score Summary',
                        child: Text(
                          report!.scoreSummary,
                          style: _bodyStyle,
                        ),
                      ),

                      if (report!.elevatedAreas.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _ReportSection(
                          icon: Icons.trending_up,
                          iconColor: const Color(0xFFEF4444),
                          title: 'Elevated Areas',
                          child: _BulletList(
                            items: report!.elevatedAreas,
                            bulletColor: const Color(0xFFEF4444),
                          ),
                        ),
                      ],

                      const SizedBox(height: 12),
                      _ReportSection(
                        icon: Icons.find_in_page_outlined,
                        iconColor: const Color(0xFF0EA5E9),
                        title: 'Key Findings',
                        child: _BulletList(
                          items: report!.keyFindings,
                          bulletColor: const Color(0xFF0EA5E9),
                        ),
                      ),

                      if (report!.patternFlags.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _ReportSection(
                          icon: Icons.flag_outlined,
                          iconColor: const Color(0xFFF59E0B),
                          title: 'Pattern Flags',
                          child: _BulletList(
                            items: report!.patternFlags,
                            bulletColor: const Color(0xFFF59E0B),
                          ),
                        ),
                      ],

                      const SizedBox(height: 12),
                      _ReportSection(
                        icon: Icons.directions_outlined,
                        iconColor: const Color(0xFF14B8A6),
                        title: 'Recommended Next Steps',
                        child: Text(
                          report!.nextSteps,
                          style: _bodyStyle,
                        ),
                      ),

                      const SizedBox(height: 16),
                      // AI disclaimer
                      _AiDisclaimerBox(text: report!.disclaimer),
                    ],

                    const SizedBox(height: 16),
                    // Screening disclaimer
                    _DisclaimerBox(
                      text:
                          'This screening is for educational purposes only. It is not a diagnosis. If you are in crisis, call or text 988.',
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // ── Return button ─────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: ElevatedButton(
                onPressed: onReturnHome,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B9BD1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                child: const Text(
                  'Return to Screening Home',
                  style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _reportHeader() {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.auto_awesome,
              size: 20, color: Color(0xFF6366F1)),
        ),
        const SizedBox(width: 12),
        const Text(
          'AI Clinical Report',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A202C),
            letterSpacing: 0.2,
          ),
        ),
        const Spacer(),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Gemini AI',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF6366F1),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  static const TextStyle _bodyStyle = TextStyle(
    fontSize: 14,
    color: Color(0xFF374151),
    height: 1.65,
  );
}

// ── Sub-widgets ─────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final Color color;
  final Color bgColor;
  final Widget child;
  const _SectionCard(
      {required this.color, required this.bgColor, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: child,
    );
  }
}

class _ReportSection extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Widget child;
  const _ReportSection({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              children: [
                Icon(icon, size: 16, color: iconColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: iconColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 14, thickness: 0.5, indent: 16, endIndent: 16),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _BulletList extends StatelessWidget {
  final List<String> items;
  final Color bulletColor;
  const _BulletList({required this.items, required this.bulletColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: bulletColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF374151),
                        height: 1.55,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _AiDisclaimerBox extends StatelessWidget {
  final String text;
  const _AiDisclaimerBox({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFBAE6FD)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.smart_toy_outlined,
              size: 15, color: Color(0xFF0369A1)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF0369A1),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DisclaimerBox extends StatelessWidget {
  final String text;
  const _DisclaimerBox({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 15, color: Color(0xFF718096)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF718096),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
