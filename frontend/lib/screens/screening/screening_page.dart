// screening_page.dart
// Mental Health Screening home: disclaimer banner + 9 module cards.
// Disclaimer must be acknowledged before any module can be started.

import 'package:flutter/material.dart';
import 'screening_data.dart';
import 'screening_module_screen.dart';

class ScreeningPage extends StatefulWidget {
  const ScreeningPage({super.key});

  @override
  State<ScreeningPage> createState() => _ScreeningPageState();
}

class _ScreeningPageState extends State<ScreeningPage> {
  bool _disclaimerChecked = false;
  bool _disclaimerAcknowledged = false;

  void _acknowledgeDisclaimer() {
    if (_disclaimerChecked) {
      setState(() => _disclaimerAcknowledged = true);
    }
  }

  void _startModule(ScreeningModule module) {
    if (!_disclaimerAcknowledged) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ScreeningModuleScreen(
          module: module,
          onReturnHome: () =>
              Navigator.popUntil(context, ModalRoute.withName('/screening')),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── App bar row ──────────────────────────────────────────────────
            Container(
              color: theme.cardColor,
              padding: const EdgeInsets.fromLTRB(8, 12, 20, 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mental Health Screening',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Educational · Not a diagnosis',
                          style: TextStyle(
                              fontSize: 12, color: Color(0xFF718096)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Disclaimer banner ────────────────────────────────────
                    _buildDisclaimerBanner(theme),
                    const SizedBox(height: 28),

                    // ── Module cards ─────────────────────────────────────────
                    Text(
                      'Choose a screening area',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF718096),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ...allModules.map((meta) => Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _disclaimerAcknowledged
                              ? _moduleCard(theme, meta)
                              : _lockedCard(theme, meta),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Disclaimer banner ──────────────────────────────────────────────────────

  Widget _buildDisclaimerBanner(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, size: 18, color: Color(0xFFF59E0B)),
              SizedBox(width: 8),
              Text(
                'Important Disclaimer',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF92400E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'This screening is for educational purposes only. It is not a '
            'diagnosis and does not replace professional evaluation. '
            'If you are in crisis, call or text 988.',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF78350F),
              height: 1.55,
            ),
          ),
          if (!_disclaimerAcknowledged) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Checkbox(
                    value: _disclaimerChecked,
                    onChanged: (v) =>
                        setState(() => _disclaimerChecked = v ?? false),
                    activeColor: const Color(0xFF6B9BD1),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'I understand this is for educational use only',
                  style: TextStyle(fontSize: 13, color: Color(0xFF78350F)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    _disclaimerChecked ? _acknowledgeDisclaimer : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  disabledBackgroundColor:
                      const Color(0xFFF59E0B).withValues(alpha: 0.3),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: const Text(
                  'Continue to Screening',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ),
            ),
          ] else ...[
            const SizedBox(height: 10),
            const Row(
              children: [
                Icon(Icons.check_circle, size: 16, color: Color(0xFF4CAF50)),
                SizedBox(width: 6),
                Text(
                  'Acknowledged',
                  style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF4CAF50),
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ── Unlocked module card ───────────────────────────────────────────────────

  Widget _moduleCard(ThemeData theme, ModuleMeta meta) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon badge
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: meta.iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(meta.icon, color: meta.iconColor, size: 26),
            ),
            const SizedBox(width: 14),

            // Text + metadata
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meta.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    meta.subtitle,
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF718096)),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _chip(Icons.help_outline, meta.subtitle),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _startModule(meta.module),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: meta.iconColor,
                        foregroundColor: Colors.white,
                        padding:
                            const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                      child: const Text('Start',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14)),
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

  Widget _chip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F8),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: const Color(0xFF718096)),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(fontSize: 11, color: Color(0xFF718096))),
        ],
      ),
    );
  }

  // ── Locked card (disclaimer not yet acknowledged) ──────────────────────────

  Widget _lockedCard(ThemeData theme, ModuleMeta meta) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: meta.iconColor.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(meta.icon,
                color: meta.iconColor.withValues(alpha: 0.4), size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              meta.title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: theme.textTheme.bodyMedium?.color
                    ?.withValues(alpha: 0.4),
              ),
            ),
          ),
          const Icon(Icons.lock_outline, size: 18, color: Color(0xFFCBD5E0)),
        ],
      ),
    );
  }
}
