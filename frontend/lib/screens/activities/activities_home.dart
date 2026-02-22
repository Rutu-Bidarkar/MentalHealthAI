import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'breathing_exercise.dart';
import 'anger_release.dart';
import 'video_player_screen.dart';
import 'boundary_practice.dart';
import 'gratitude_exchange.dart';
import 'mood_rating_popup.dart';

class ActivitiesPage extends StatelessWidget {
  const ActivitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FC),
      appBar: AppBar(
        title: Text(
          'Activities & Exercises',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D3748),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF2D3748)),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Quick Relief (< 5 min)'),
            _buildActivityCard(
              context,
              title: 'Physiological Sigh',
              subtitle: '2 min | Breathing',
              description: 'Fastest stress relief technique.',
              icon: Icons.air,
              color: const Color(0xFF6B9BD1),
              destination: const BreathingExercise(),
            ),
            _buildActivityCard(
              context,
              title: 'Anger Release',
              subtitle: '1-2 min | Emotional',
              description: 'Validate and release your feelings.',
              icon: Icons.local_fire_department,
              color: const Color(0xFFE89E98),
              destination: const AngerRelease(),
            ),
            
            const SizedBox(height: 24),
            _buildSectionHeader('Movement & Body'),
            _buildActivityCard(
              context,
              title: 'Yoga for Anxiety',
              subtitle: '10 min | Video',
              description: 'Trauma-informed gentle practice.',
              icon: Icons.self_improvement,
              color: const Color(0xFF7FC29B),
              destination: VideoPlayerScreen(
                title: 'Yoga for Anxiety',
                videoId: 'bJJWArDfKA8', // Placeholder ID
                description: 'A gentle yoga session to calm the nervous system.',
              ),
            ),
            _buildActivityCard(
              context,
              title: 'Desk Stretches',
              subtitle: '7 min | Video',
              description: 'Relieve tension from sitting.',
              icon: Icons.accessibility_new,
              color: const Color(0xFFF4C96F),
              destination: VideoPlayerScreen(
                title: 'Desk Stretches',
                videoId: 'nZtbq2r750M', // Placeholder ID
                description: 'Quick stretches to do right at your desk.',
              ),
            ),

            const SizedBox(height: 24),
            _buildSectionHeader('Mental Health Skills'),
            _buildActivityCard(
              context,
              title: 'Boundary Practice',
              subtitle: '5 min | Interactive',
              description: 'Learn to say no effectively.',
              icon: Icons.shield,
              color: const Color(0xFF8B5CF6),
              destination: const BoundaryPractice(),
            ),

            const SizedBox(height: 24),
            _buildSectionHeader('Connection'),
            _buildActivityCard(
              context,
              title: 'Gratitude Exchange',
              subtitle: '3 min | Social',
              description: 'Give & receive gratitude anonymously.',
              icon: Icons.volunteer_activism, // Hand holding heart
              color: const Color(0xFFEC4899),
              destination: const GratitudeExchange(),
            ),
             const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF4A5568),
        ),
      ),
    );
  }

  Widget _buildActivityCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
    required Color color,
    required Widget destination,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 0, // Flat design with shadow via Container
        child: InkWell(
          onTap: () => _showMoodRating(context, title: title, color: color, destination: destination),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                 BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                 ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF718096),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFFA0AEC0),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFFCBD5E0)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMoodRating(BuildContext context, {required String title, required Color color, required Widget destination}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => MoodRatingPopup(
        title: "How are you feeling?",
        question: "What are you hoping to feel after this activity?",
        activityColor: color,
        onCompleted: () async {
          Navigator.pop(sheetContext); // Close Pre-Popup
          
          // Wait for activity to finish
          final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => destination));
          
          // Post-activity rating
          if (context.mounted) {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (postSheetContext) => MoodRatingPopup(
                title: "How are you feeling now?",
                question: "Did this activity help you feel better?",
                activityColor: color,
                isPost: true,
                onCompleted: () {
                  Navigator.pop(postSheetContext); // Close Post-Popup
                  if (result == 'home') {
                    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                  }
                },
              ),
            );
          }
        },
      ),
    );
  }
}
