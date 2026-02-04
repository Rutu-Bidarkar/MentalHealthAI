import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

/// Placeholder home screen. Replace with your main app content.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'MindfulCare',
          style: AppTextStyles.heading.copyWith(fontSize: 20),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 64, color: AppColors.primary),
            const SizedBox(height: 24),
            Text(
              'You\'re signed in',
              style: AppTextStyles.heading,
            ),
            const SizedBox(height: 8),
            Text(
              'Home screen – add your content here',
              style: AppTextStyles.subHeading,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
