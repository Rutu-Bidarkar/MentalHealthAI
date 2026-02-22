// crisis_interrupt_screen.dart
// Full-screen safety card shown when Module A items 1, 2, or 3 are answered Yes.

import 'package:flutter/material.dart';

class CrisisInterruptScreen extends StatelessWidget {
  /// Called when the user dismisses the card to return to the screening home.
  final VoidCallback onReturnHome;

  const CrisisInterruptScreen({super.key, required this.onReturnHome});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7B1FA2),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 52,
                  ),
                ),
                const SizedBox(height: 32),

                // Heading
                const Text(
                  "You're not alone.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 16),

                // Approved copy
                const Text(
                  "Please reach out right now — call or text",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),

                // 988 badge
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Text(
                    '988',
                    style: TextStyle(
                      color: Color(0xFF7B1FA2),
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                const Text(
                  'Suicide & Crisis Lifeline\nFree, confidential, 24/7',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 48),

                // Divider
                const Divider(color: Colors.white24, thickness: 1),
                const SizedBox(height: 24),

                const Text(
                  'When you feel ready, you can return to the screening home.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),

                TextButton(
                  onPressed: onReturnHome,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white70,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: const Text(
                    'Return to Screening Home',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
