import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MoodRatingPopup extends StatefulWidget {
  final String title;
  final String question;
  final Color activityColor;
  final bool isPost;
  final VoidCallback onCompleted;

  const MoodRatingPopup({
    super.key,
    required this.title,
    required this.question,
    required this.activityColor,
    this.isPost = false,
    required this.onCompleted,
  });

  @override
  State<MoodRatingPopup> createState() => _MoodRatingPopupState();
}

class _MoodRatingPopupState extends State<MoodRatingPopup> {
  double _rating = 5.0;
  final List<String> _selectedTags = [];

  Map<String, List<Map<String, dynamic>>> get _tagCategories {
    if (widget.isPost) {
      return {
        'Positive Outcomes': [
          {'name': 'Calmer', 'icon': Icons.spa},
          {'name': 'Happier', 'icon': Icons.sentiment_satisfied_alt},
          {'name': 'Empowered', 'icon': Icons.fitness_center},
          {'name': 'Peaceful', 'icon': Icons.self_improvement},
          {'name': 'Relieved', 'icon': Icons.check_circle_outline},
          {'name': 'Energized', 'icon': Icons.flash_on},
          {'name': 'Focused', 'icon': Icons.track_changes},
          {'name': 'Connected', 'icon': Icons.favorite},
          {'name': 'Hopeful', 'icon': Icons.wb_sunny},
          {'name': 'Less Anxious', 'icon': Icons.lock_open},
          {'name': 'Can Breathe Better', 'icon': Icons.air},
          {'name': 'Less Tense', 'icon': Icons.accessibility_new},
          {'name': 'Clear-Headed', 'icon': Icons.psychology},
          {'name': 'Accomplished', 'icon': Icons.task_alt},
        ],
        'Neutral/Mixed': [
          {'name': 'About the Same', 'icon': Icons.horizontal_rule},
          {'name': 'Uncertain', 'icon': Icons.help_outline},
          {'name': 'Tired (good tired)', 'icon': Icons.bedtime},
          {'name': 'Slightly Better', 'icon': Icons.trending_up},
        ],
        'Negative Outcomes': [
          {'name': 'More Anxious', 'icon': Icons.warning_amber},
          {'name': 'Sad', 'icon': Icons.sentiment_dissatisfied},
          {'name': 'Frustrated', 'icon': Icons.sick},
          {'name': 'Exhausted', 'icon': Icons.battery_alert},
          {'name': 'Disconnected', 'icon': Icons.cloud_off},
          {'name': 'Overwhelmed', 'icon': Icons.error_outline},
          {'name': 'Angry', 'icon': Icons.mood_bad},
          {'name': 'Worse Than Before', 'icon': Icons.trending_down},
        ],
      };
    }
    return {
      'Emotional States': [
        {'name': 'Calmer', 'icon': Icons.spa},
        {'name': 'Happier', 'icon': Icons.sentiment_satisfied_alt},
        {'name': 'Stronger', 'icon': Icons.fitness_center},
        {'name': 'More Peaceful', 'icon': Icons.self_improvement},
        {'name': 'Relaxed', 'icon': Icons.bedtime},
        {'name': 'Energized', 'icon': Icons.flash_on},
        {'name': 'Focused', 'icon': Icons.track_changes},
        {'name': 'Loved/Connected', 'icon': Icons.favorite},
        {'name': 'Less Angry', 'icon': Icons.sentiment_very_satisfied},
        {'name': 'Hopeful', 'icon': Icons.wb_sunny},
      ],
      'Physical States': [
        {'name': 'Less Tense', 'icon': Icons.accessibility_new},
        {'name': 'Able to Breathe', 'icon': Icons.air},
        {'name': 'Ready to Sleep', 'icon': Icons.nights_stay},
        {'name': 'More Active', 'icon': Icons.directions_run},
      ],
      'Mental States': [
        {'name': 'Clear-Headed', 'icon': Icons.psychology},
        {'name': 'Motivated', 'icon': Icons.rocket_launch},
        {'name': 'Less Anxious', 'icon': Icons.health_and_safety},
        {'name': 'Able to Process', 'icon': Icons.assignment},
        {'name': 'Creative', 'icon': Icons.palette},
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset('assets/images/Logo.png', height: 40),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Color(0xFF718096)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.title,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 32),
          _buildSliderSection(),
          const SizedBox(height: 32),
          Flexible(
            child: SingleChildScrollView(
              child: _buildTagsSection(),
            ),
          ),
          const SizedBox(height: 24),
          _buildActionButton(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSliderSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Troubled', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF718096))),
            Text('Elated', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF718096))),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: widget.activityColor,
            inactiveTrackColor: widget.activityColor.withValues(alpha: 0.1),
            thumbColor: widget.activityColor,
            overlayColor: widget.activityColor.withValues(alpha: 0.2),
            valueIndicatorColor: widget.activityColor,
            valueIndicatorTextStyle: const TextStyle(color: Colors.white),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
          ),
          child: Slider(
            value: _rating,
            min: 1,
            max: 10,
            divisions: 9,
            label: _rating.round().toString(),
            onChanged: (val) => setState(() => _rating = val),
          ),
        ),
        Text(
          _rating.round().toString(),
          style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: widget.activityColor),
        ),
      ],
    );
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.question,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF4A5568)),
        ),
        const SizedBox(height: 16),
        ..._tagCategories.entries.map((entry) => _buildTagCategory(entry.key, entry.value)),
      ],
    );
  }

  Widget _buildTagCategory(String category, List<Map<String, dynamic>> tags) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, top: 12),
          child: Text(
            category,
            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFFA0AEC0)),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags.map((tag) => _buildTagChip(tag)).toList(),
        ),
      ],
    );
  }

  Widget _buildTagChip(Map<String, dynamic> tag) {
    final isSelected = _selectedTags.contains(tag['name']);
    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedTags.remove(tag['name']);
          } else {
            _selectedTags.add(tag['name']);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? widget.activityColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? widget.activityColor : const Color(0xFFE2E8F0),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(tag['icon'], size: 14, color: isSelected ? Colors.white : widget.activityColor),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                tag['name'],
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : const Color(0xFF4A5568),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: widget.onCompleted,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.activityColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: Text(
          widget.isPost ? 'Complete' : 'Continue',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
