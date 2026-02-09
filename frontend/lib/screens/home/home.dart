// home_page.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;

// Theme constants (ideally in a separate theme.dart file)
class AppTheme {
  const AppTheme._();
  static const borderRadius = 16.0;

  static final BoxShadow cardShadow = BoxShadow(
    color: const Color(0xFF6B9BD1).withAlpha(38), // 15% opacity
    blurRadius: 32,
    offset: const Offset(0, 8),
  );

  static final BoxShadow softShadow = BoxShadow(
    color: Colors.black.withAlpha(13), // 5% opacity
    blurRadius: 8,
    offset: const Offset(0, 2),
  );
}

class AppColors {
  const AppColors._();

  static const Color background = Color(0xFFF5F9FC);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF2D3748);
  static const Color textSecondary = Color(0xFF718096);
  static const Color primary = Color(0xFF6B9BD1);
}

class AppGradients {
  const AppGradients._();

  static const primaryGlow = LinearGradient(
    colors: [Color(0xFF6B9BD1), Color(0xFF8AB5DD)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const serenity = LinearGradient(
    colors: [Color(0xFFA8C5A5), Color(0xFFC2D9BF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const warmth = LinearGradient(
    colors: [Color(0xFFF4C96F), Color(0xFFFFDB89)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const peace = LinearGradient(
    colors: [Color(0xFF9B9BE8), Color(0xFFAFAFF4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const ocean = LinearGradient(
    colors: [Color(0xFF6DD5D5), Color(0xFF8FE5E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const sunset = LinearGradient(
    colors: [Color(0xFFE89E98), Color(0xFFF4A59C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const positivity = LinearGradient(
    colors: [Color(0xFF7FC29B), Color(0xFF9FD4B5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

// Models
class Mood {
  final String emoji;
  final String label;
  final Gradient color;
  final Color baseColor;
  final String imagePath;

  const Mood({
    required this.emoji,
    required this.label,
    required this.color,
    required this.baseColor,
    required this.imagePath,
  });
}

class MarbleData {
  final String id;
  final Mood mood;
  final DateTime date;
  final double x;
  final double y;

  MarbleData({
    required this.id,
    required this.mood,
    required this.date,
    required this.x,
    required this.y,
  });
}

class QuickAccessTab {
  final IconData icon;
  final String label;
  final String path;
  final Gradient gradient;

  const QuickAccessTab({
    required this.icon,
    required this.label,
    required this.path,
    required this.gradient,
    required String imagePath,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final List<Mood> moods = const [
    Mood(
      emoji: "😠",
      label: "Angry",
      color: AppGradients.sunset,
      baseColor: Color(0xFFE89E98),
      imagePath: 'assets/images/angry marble.png',
    ),
    Mood(
      emoji: "😨",
      label: "Scared",
      color: AppGradients.peace,
      baseColor: Color(0xFF9B9BE8),
      imagePath: 'assets/images/Scared marble.png',
    ),
    Mood(
      emoji: "😢",
      label: "Sad",
      color: AppGradients.primaryGlow,
      baseColor: Color(0xFF6B9BD1),
      imagePath: 'assets/images/sad marble.png',
    ),
    Mood(
      emoji: "😐",
      label: "Neutral",
      color: AppGradients.ocean,
      baseColor: Color(0xFF6DD5D5),
      imagePath: 'assets/images/neutral marble.png',
    ),
    Mood(
      emoji: "😊",
      label: "Good",
      color: AppGradients.warmth,
      baseColor: Color(0xFFF4C96F),
      imagePath: 'assets/images/Good marble.png',
    ),
    Mood(
      emoji: "😄",
      label: "Great",
      color: AppGradients.positivity,
      baseColor: Color(0xFF7FC29B),
      imagePath: 'assets/images/great marble.png',
    ),
  ];

  final List<QuickAccessTab> quickAccessTabs = const [
    QuickAccessTab(
      icon: Icons.games_outlined,
      label: "Games",
      imagePath: 'assets/images/games.png',
      path: "/games",
      gradient: AppGradients.primaryGlow,
    ),
    QuickAccessTab(
      icon: Icons.local_activity_outlined,
      label: "Activities",
      imagePath: 'assets/images/Activities.png',
      path: "/activities",
      gradient: AppGradients.serenity,
    ),
    QuickAccessTab(
      icon: Icons.people_outline,
      label: "Community",
      imagePath: 'assets/images/Community lp.png',
      path: "/community",
      gradient: AppGradients.warmth,
    ),
    QuickAccessTab(
      icon: Icons.bar_chart,
      label: "Reports",
      imagePath: 'assets/images/Reports.png',
      path: "/report",
      gradient: AppGradients.peace,
    ),
    QuickAccessTab(
      icon: Icons.book_outlined,
      label: "Journal",
      imagePath: 'assets/images/Journal.png',
      path: "/journal",
      gradient: AppGradients.ocean,
    ),
    QuickAccessTab(
      icon: Icons.medical_services_outlined,
      label: "Book Consult",
      imagePath: 'assets/images/Consult.png',
      path: "/consultancy",
      gradient: AppGradients.sunset,
    ),
  ];

  List<MarbleData> collectedMarbles = [];
  bool showWidgetPrompt = false;
  bool showInfoPrompt = false;
  bool showAssessmentBanner = true;
  final String userName = "Alex";

  @override
  void initState() {
    super.initState();
    collectedMarbles = _generatePastMarbles();
  }

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 18) return "Good Afternoon";
    return "Good Evening";
  }

  String get greetingEmoji {
    final hour = DateTime.now().hour;
    if (hour < 12) return "☀️";
    if (hour < 18) return "🌤️";
    return "🌙";
  }

  Map<String, double> _generateNextMarblePosition(int existingCount) {
    const marbleSize = 32.0;
    const spacing = 7.0;
    const containerWidth = 280.0;
    const containerHeight = 320.0;
    const cols = 7;

    final index = existingCount;
    final row = (index / cols).floor();
    final col = index % cols;

    final gridWidth =
        (cols - 1) * ((containerWidth - marbleSize) / (cols - 1)) + marbleSize;
    final centerOffset = (containerWidth - gridWidth) / 2;

    final baseX =
        centerOffset +
        (col * ((containerWidth - marbleSize - centerOffset * 2) / (cols - 1)));
    final baseY =
        containerHeight - (row * (marbleSize + spacing)) - marbleSize - 10;

    final random = math.Random();
    final offsetX = (random.nextDouble() - 0.5) * 6;
    final offsetY = (random.nextDouble() - 0.5) * 3;

    return {'x': baseX + offsetX, 'y': baseY + offsetY};
  }

  List<MarbleData> _generatePastMarbles() {
    final marbles = <MarbleData>[];
    final today = DateTime.now();
    final random = math.Random();

    for (int i = 0; i < 25; i++) {
      final randomMood = moods[random.nextInt(moods.length)];
      final date = today.subtract(Duration(days: i));
      final position = _generateNextMarblePosition(i);

      marbles.add(
        MarbleData(
          id: 'past-\$i',
          mood: randomMood,
          date: date,
          x: position['x']!,
          y: position['y']!,
        ),
      );
    }
    return marbles;
  }

  void _addMarbleToJar(Mood mood) {
    if (collectedMarbles.length >= 50) return;

    final position = _generateNextMarblePosition(collectedMarbles.length);
    final newMarble = MarbleData(
      id: 'marble-\${DateTime.now().millisecondsSinceEpoch}',
      mood: mood,
      date: DateTime.now(),
      x: position['x']!,
      y: position['y']!,
    );

    setState(() {
      collectedMarbles.insert(0, newMarble);
    });
  }

  void _clearJar() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Mood Jar'),
        content: const Text('Are you sure you want to clear your mood jar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                collectedMarbles.clear();
              });
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _addToReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mood jar data has been added to your report!'),
      ),
    );
  }

  // ignore: unused_element
  void _handleAddToHomeScreen() {
    setState(() {
      showWidgetPrompt = true;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          showWidgetPrompt = false;
        });
      }
    });
  }

  // ignore: unused_element
  void _toggleInfo() {
    setState(() {
      showInfoPrompt = !showInfoPrompt;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.background, AppColors.cardBackground],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // Background texture
            Positioned.fill(
              child: Opacity(
                opacity: 0.05,
                child: CustomPaint(painter: DotPatternPainter()),
              ),
            ),

            // Main content
            Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildGreeting(),
                        const SizedBox(height: 24),
                        _buildMoodJar(),
                        const SizedBox(height: 24),
                        _buildQuickAccess(),
                        const SizedBox(height: 80), // Space for bottom nav
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Bottom navigation
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(204),
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
          const Row(
            children: [
              Text('🧘', style: TextStyle(fontSize: 24)),
              SizedBox(width: 8),
              Text(
                'MindfulCare',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/profile'),
            child: CircleAvatar(
              backgroundColor: AppColors.primary.withAlpha(50),
              child: Text(
                userName.substring(0, 1),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "\$greeting, \$userName! \$greetingEmoji",
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        if (showAssessmentBanner) _buildAssessmentBanner(),
      ],
    );
  }

  Widget _buildAssessmentBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppGradients.primaryGlow,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        boxShadow: [AppTheme.softShadow],
      ),
      child: Row(
        children: [
          const Icon(Icons.description_outlined, color: Colors.white, size: 32),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              "You have a pending assessment. Take it now to track your progress!",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => setState(() => showAssessmentBanner = false),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodJar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Column(
        children: [
          _buildJarHeader(),
          const SizedBox(height: 16),
          _buildJarVisual(),
          const SizedBox(height: 16),
          _buildMoodSelector(),
        ],
      ),
    );
  }

  Widget _buildJarHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Your Mood Jar",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.bar_chart),
              onPressed: _addToReport,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _clearJar,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildJarVisual() {
    return SizedBox(
      height: 320,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset('assets/images/jar.png', width: 280, fit: BoxFit.contain),
          ...collectedMarbles.map(
            (marble) => Positioned(
              left: marble.x,
              top: marble.y,
              child: Image.asset(marble.mood.imagePath, width: 32, height: 32),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "How are you feeling today?",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: moods
              .map(
                (mood) => GestureDetector(
                  onTap: () => _addMarbleToJar(mood),
                  child: Tooltip(
                    message: mood.label,
                    child: Text(
                      mood.emoji,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildQuickAccess() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Quick Access",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.9,
          ),
          itemCount: quickAccessTabs.length,
          itemBuilder: (context, index) {
            final tab = quickAccessTabs[index];
            return _QuickAccessCard(tab: tab);
          },
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 65,
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(230),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [AppTheme.cardShadow],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomNavItem(Icons.home_filled, 'Home', true, 0),
            _buildBottomNavItem(Icons.explore_outlined, 'Explore', false, 1),
            _buildBottomNavItem(Icons.chat_bubble_outline, 'Chat', false, 2),
            _buildBottomNavItem(Icons.person_outline, 'Profile', false, 3),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(
    IconData icon,
    String label,
    bool isActive,
    int index,
  ) {
    return InkWell(
      onTap: () {
        // Handle navigation
      },
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? AppColors.primary : AppColors.textSecondary,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? AppColors.primary : AppColors.textSecondary,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  final QuickAccessTab tab;
  const _QuickAccessCard({required this.tab});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context, rootNavigator: true).pushNamed(tab.path);
      },
      borderRadius: BorderRadius.circular(AppTheme.borderRadius),
      child: Container(
        decoration: BoxDecoration(
          gradient: tab.gradient,
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          boxShadow: [AppTheme.softShadow],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(tab.icon, color: Colors.white, size: 32),
            const SizedBox(height: 8),
            Text(
              tab.label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withAlpha(25)
      ..style = PaintingStyle.fill;

    const spacing = 25.0;
    const dotRadius = 1.0;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
