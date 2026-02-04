import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../widgets/app_button.dart';

class Landing1 extends StatelessWidget {
  const Landing1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF7AAAD8),
              Color(0xFF9BC5C3),
            ],
          ),
        ),
        child: Column(
          children: [

            const Spacer(),

            // 🔵 Illustration placeholder
            CircleAvatar(
              radius: 70,
              backgroundColor: Colors.white.withOpacity(0.3),
              child: const Icon(
                Icons.self_improvement,
                size: 70,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 30),

            // 📝 Title
            Text(
              "Welcome to MindfulCare",
              style: AppTextStyles.heading.copyWith(color: Colors.white),
            ),

            const SizedBox(height: 12),

            // 🧾 Subtitle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Your personalized mental health companion",
                textAlign: TextAlign.center,
                style: AppTextStyles.subHeading.copyWith(
                  color: Colors.white70,
                ),
              ),
            ),

            const Spacer(),

            // ⚪ Page indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _dot(true),
                _dot(false),
                _dot(false),
                _dot(false),
              ],
            ),

            const SizedBox(height: 20),

            // 🔘 Continue Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: "Continue",
                  onPressed: () {
                    // Later navigate to Landing2
                  },
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Dot Widget
  Widget _dot(bool active) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: active ? 16 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? AppColors.primary : Colors.white54,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
