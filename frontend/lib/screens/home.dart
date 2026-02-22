// home_page.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../widgets/physics_marble_jar.dart';
import '../constants/app_gradients.dart';
import '../models/mood_model.dart';
import '../constants/home_theme.dart';
import 'activities.dart';
import 'community.dart';
import 'profile_screen.dart';
import 'tests.dart';
import 'journal.dart'; 
import 'ai_chat_screen.dart';

import 'package:provider/provider.dart';
import '../services/theme_service.dart';

// QuickAccessTab class
class QuickAccessTab {
  final IconData icon;
  final String label;
  final String path;
  final Gradient gradient;
  final String imagePath;

  const QuickAccessTab({
    required this.icon,
    required this.label,
    required this.path,
    required this.gradient,
    required this.imagePath,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  final List<QuickAccessTab> quickAccessTabs = const [
    QuickAccessTab(
        icon: Icons.games_outlined,
        label: "Games",
        imagePath: 'assets/images/Games.png', // Capitalized G
        path: "/games",
        gradient: AppGradients.games),
    QuickAccessTab(
        icon: Icons.local_activity_outlined,
        label: "Activities",
        imagePath: 'assets/images/Activities.png',
        path: "/activities",
        gradient: AppGradients.activities),
    QuickAccessTab(
        icon: Icons.people_outline,
        label: "Community",
        imagePath: 'assets/images/Community lp.png',
        path: "/community",
        gradient: AppGradients.community),
    QuickAccessTab(
        icon: Icons.dashboard_outlined,
        label: "Dashboard",
        imagePath: 'assets/images/Reports.png',
        path: "/reports", // Changed from /profile
        gradient: AppGradients.reports),
    QuickAccessTab(
        icon: Icons.book_outlined,
        label: "Journal",
        imagePath: 'assets/images/Journal.png',
        path: "/journal",
        gradient: AppGradients.journal),
    QuickAccessTab(
        icon: Icons.medical_services_outlined,
        label: "Consult",
        imagePath: 'assets/images/consult.png', // Lowercase c
        path: "/consult",
        gradient: AppGradients.consult),
  ];

  List<MarbleData> collectedMarbles = [];
  bool showAssessmentBanner = true;
  final String userName = "Alex";
  
  static const int maxMarbles = 50;

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

  List<MarbleData> _generatePastMarbles() {
    final marbles = <MarbleData>[];
    final today = DateTime.now();
    final random = math.Random(); 
    final moods = Mood.all;

    for (int i = 0; i < 15; i++) {
      final randomMood = moods[random.nextInt(moods.length)];
      final date = today.subtract(Duration(days: i));

      marbles.add(MarbleData(
        id: 'past-$i',
        mood: randomMood,
        date: date,
        x: 0,
        y: 0,
      ));
    }
    return marbles;
  }

  void _addMarbleToJar(Mood mood) {
    if (collectedMarbles.length >= maxMarbles) {
      // Auto-clear logic or show warning
      _showJarFullDialog();
      return;
    }

    final newMarble = MarbleData(
      id: 'marble-${DateTime.now().millisecondsSinceEpoch}',
      mood: mood,
      date: DateTime.now(),
      x: 0,
      y: 0,
    );

    setState(() {
      collectedMarbles.insert(0, newMarble);
    });
    
    // Check if full after adding
    if (collectedMarbles.length >= maxMarbles) {
       Future.delayed(const Duration(milliseconds: 500), _showJarFullDialog);
    }
  }

  void _showJarFullDialog() {
      showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Jar Full!'),
        content: const Text('Your mood jar has reached 50 marbles. It will be cleared to make space for new memories.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _clearJar();
            },
            child: const Text('Clear Now'),
          ),
        ],
      ),
    );
  }

  void _clearJar() {
    setState(() {
      collectedMarbles.clear();
    });
  }

  void _addToReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mood jar data has been added to your dashboard!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // List of pages for Bottom Navigation
    final List<Widget> pages = [
      _buildHomeContent(context), // Pass context
      const TestsPage(),
      const JournalPage(), 
      const ProfileScreen(),
    ];

    if (_selectedIndex >= pages.length) {
      _selectedIndex = 0;
    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(context),
      body: pages[_selectedIndex],
      floatingActionButton: _selectedIndex == 0 
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AiChatScreen()),
                );
              },
              backgroundColor: theme.colorScheme.primary,
              child: const Icon(Icons.smart_toy, color: Colors.white),
              tooltip: "AI Assistant",
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: isDark ? Colors.grey[400] : HomeColors.textSecondary,
        backgroundColor: theme.cardColor,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
            label: 'Tests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            activeIcon: Icon(Icons.book),
            label: 'Journal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final theme = Theme.of(context);
    final themeService = Provider.of<ThemeService>(context, listen: false);
    
    return Drawer(
      child: Container(
        color: theme.scaffoldBackgroundColor,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              accountName: const Text("Avantika", style: TextStyle(fontWeight: FontWeight.bold)),
              accountEmail: const Text("avantika@example.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  "A",
                  style: TextStyle(fontSize: 24, color: theme.colorScheme.primary),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Quick Access Items from the list
                  ...quickAccessTabs.map((tab) => ListTile(
                    leading: Icon(tab.icon, color: theme.iconTheme.color),
                    title: Text(tab.label, style: TextStyle(color: theme.textTheme.bodyLarge?.color)),
                    onTap: () {
                      Navigator.pop(context); // Close drawer
                      Navigator.pushNamed(context, tab.path);
                    },
                  )),
                  const Divider(),
                  // Theme Toggle in Drawer
                  Consumer<ThemeService>(
                    builder: (context, service, _) => SwitchListTile(
                      title: Text("Dark Mode", style: TextStyle(color: theme.textTheme.bodyLarge?.color)),
                      secondary: Icon(service.isDarkMode ? Icons.dark_mode : Icons.light_mode, color: theme.iconTheme.color),
                      value: service.isDarkMode,
                      onChanged: (_) => service.toggleTheme(),
                      activeColor: theme.colorScheme.primary,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.settings, color: theme.iconTheme.color),
                    title: Text("Settings", style: TextStyle(color: theme.textTheme.bodyLarge?.color)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/profile'); // Or settings page
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "MindfulCare v1.0",
                style: TextStyle(color: theme.disabledColor, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildHomeContent(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.scaffoldBackgroundColor,
            theme.cardColor,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          // Background texture
          Positioned.fill(
            child: Opacity(
              opacity: isDark ? 0.02 : 0.05,
              child: CustomPaint(
                painter: DotPatternPainter(color: theme.colorScheme.primary),
              ),
            ),
          ),

          // Main content
          Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildGreeting(context),
                      const SizedBox(height: 24),
                      _buildMoodJarSection(context),
                      const SizedBox(height: 24),
                      _buildQuickAccess(context),
                      const SizedBox(height: 20), 
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 16),
      decoration: BoxDecoration(
        color: theme.appBarTheme.backgroundColor?.withAlpha(204) ?? theme.cardColor.withAlpha(204),
        boxShadow: [HomeTheme.cardShadow],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.menu, color: theme.iconTheme.color),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          Row(
            children: [
              const Text('🧘', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Text(
                'MindfulCare',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.titleLarge?.color ?? theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          Row(
            children: [
              // Theme Toggle
              Consumer<ThemeService>(
                builder: (context, service, _) => IconButton(
                  icon: Icon(
                    service.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    color: theme.iconTheme.color,
                  ),
                  onPressed: service.toggleTheme,
                ),
              ),
              const SizedBox(width: 8),
              // Profile Button - Go to Profile Screen
              GestureDetector(
                onTap: () {
                  // Direct navigation to Profile Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  );
                }, 
                child: CircleAvatar(
                  backgroundColor: theme.colorScheme.primary.withAlpha(50),
                  child: Text(
                    userName.substring(0, 1),
                    style: TextStyle(
                        color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$greeting, $userName! $greetingEmoji",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: theme.textTheme.bodyLarge?.color ?? theme.colorScheme.onBackground,
          ),
        ),
        const SizedBox(height: 8),
        if (showAssessmentBanner) _buildAssessmentBanner(),
      ],
    );
  }

  Widget _buildAssessmentBanner() {
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = 1),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: AppGradients.primaryGlow,
          borderRadius: BorderRadius.circular(HomeTheme.borderRadius),
          boxShadow: [HomeTheme.softShadow],
        ),
        child: Row(
          children: [
            const Icon(Icons.assignment_late_outlined, color: Colors.white, size: 32),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pending Assessment",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    "Take it now to track your progress!",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodJarSection(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(HomeTheme.borderRadius),
            boxShadow: [HomeTheme.cardShadow],
          ),
          child: PhysicsMarbleJar(
            marbles: collectedMarbles.map((m) => m.mood).toList(),
            onMarbleAdded: _addMarbleToJar,
            onClearJar: _showJarFullDialog,
            onReport: _addToReport,
          ),
        ),
         const SizedBox(height: 16),
         HoverButton(
           onPressed: () => Navigator.pushNamed(context, '/screening'),
           label: "Take a Mental Health Test",
           icon: Icons.assignment_outlined,
           gradient: AppGradients.ocean,
         ),
      ],
    );
  }

  Widget _buildQuickAccess(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Access",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.8,
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
}


class HoverButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String label;
  final IconData icon;
  final Gradient gradient;

  const HoverButton({
    required this.onPressed,
    required this.label,
    required this.icon,
    required this.gradient,
    super.key,
  });

  @override
  State<HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<HoverButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedScale(
          scale: _isHovered ? 1.05 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: Container(
             padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
             decoration: BoxDecoration(
               gradient: widget.gradient,
               borderRadius: BorderRadius.circular(12),
               boxShadow: [
                 if (_isHovered)
                   BoxShadow(
                     color: Colors.blue.withValues(alpha: 0.3),
                     blurRadius: 12,
                     offset: const Offset(0, 4),
                   ),
               ],
             ),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Icon(widget.icon, color: Colors.white),
                 const SizedBox(width: 8),
                 Text(
                   widget.label,
                   style: const TextStyle(
                     color: Colors.white,
                     fontWeight: FontWeight.w600,
                     fontSize: 16,
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


class _QuickAccessCard extends StatefulWidget {
  final QuickAccessTab tab;
  const _QuickAccessCard({required this.tab});

  @override
  State<_QuickAccessCard> createState() => _QuickAccessCardState();
}

class _QuickAccessCardState extends State<_QuickAccessCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, widget.tab.path),
        child: AnimatedScale(
          scale: _isHovered ? 1.05 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                 BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: widget.tab.label == "Dashboard" 
                        ? const EdgeInsets.all(28)
                        : const EdgeInsets.all(20), 
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: widget.tab.gradient,
                    ),
                    child: Center(
                      child: Image.asset(widget.tab.imagePath, fit: BoxFit.contain), 
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    widget.tab.label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: theme.textTheme.bodyMedium?.color,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
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

class DotPatternPainter extends CustomPainter {
  final Color color;
  DotPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withAlpha(25)
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
