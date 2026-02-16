import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // User data
  String userName = "Alex Johnson";
  String username = "@alexj_mindful";
  String email = "alex@example.com";
  String profilePicture = ""; // Path to profile picture
  DateTime memberSince = DateTime(2025, 1, 1);
  
  // Stats
  int streakDays = 12;
  int totalDays = 45;
  double completionRate = 0.89;
  int badges = 7;
  
  // Settings
  bool notificationsEnabled = true;
  bool dailyReminders = true;
  bool moodReminders = true;
  bool activitySuggestions = true;
  String selectedLanguage = "English";
  String selectedTheme = "Light";
  
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? "Alex Johnson";
      username = prefs.getString('username') ?? "@alexj_mindful";
      email = prefs.getString('email') ?? "alex@example.com";
      profilePicture = prefs.getString('profile_picture') ?? "";
      notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      dailyReminders = prefs.getBool('daily_reminders') ?? true;
      selectedLanguage = prefs.getString('language') ?? "English";
      selectedTheme = prefs.getString('theme') ?? "Light";
    });
  }

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', userName);
    await prefs.setString('username', username);
    await prefs.setString('email', email);
    await prefs.setString('profile_picture', profilePicture);
    await prefs.setBool('notifications_enabled', notificationsEnabled);
    await prefs.setBool('daily_reminders', dailyReminders);
    await prefs.setString('language', selectedLanguage);
    await prefs.setString('theme', selectedTheme);
  }

  Future<void> _pickProfilePicture() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        profilePicture = image.path;
      });
      _saveUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FC),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildProfileHeader(),
                const SizedBox(height: 16),
                _buildStatsCards(),
                const SizedBox(height: 24),
                _buildProgressSection(),
                const SizedBox(height: 16),
                _buildSettingsSection(),
                const SizedBox(height: 16),
                _buildSubscriptionCard(),
                const SizedBox(height: 16),
                _buildGoalsCard(),
                const SizedBox(height: 16),
                _buildAchievementsCard(),
                const SizedBox(height: 16),
                _buildResourcesCard(),
                const SizedBox(height: 16),
                _buildDataManagementCard(),
                const SizedBox(height: 24),
                _buildLogoutButton(),
                const SizedBox(height: 100), // Bottom nav spacing
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 100,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFF6B9BD1),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: _showEditProfileDialog,
        ),
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            // Navigate to full settings page
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6B9BD1), Color(0xFF8AB5DD)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6B9BD1).withValues(alpha: 0.15),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Picture
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6B9BD1), Color(0xFF8AB5DD)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6B9BD1).withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: profilePicture.isEmpty
                    ? Center(
                        child: Text(
                          userName.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : ClipOval(
                        child: Image.file(
                          File(profilePicture),
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _pickProfilePicture,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 16,
                      color: Color(0xFF6B9BD1),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Name
          Text(
            userName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 4),
          
          // Username
          Text(
            username,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF718096),
            ),
          ),
          const SizedBox(height: 8),
          
          // Member since
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F9FC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: Color(0xFF6B9BD1),
                ),
                const SizedBox(width: 6),
                Text(
                  'Member since ${_formatDate(memberSince)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF718096),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          _buildStatCard(
            totalDays.toString(),
            'Days',
            Icons.calendar_today,
            const Color(0xFF6B9BD1),
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            streakDays.toString(),
            'Streak',
            Icons.local_fire_department,
            const Color(0xFFF4C96F),
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            '${(completionRate * 100).toInt()}%',
            'Complete',
            Icons.check_circle,
            const Color(0xFF7FC29B),
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            badges.toString(),
            'Badges',
            Icons.emoji_events,
            const Color(0xFFF4A59C),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF718096),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection() {
    return _buildSection(
      title: '📊 My Progress',
      children: [
        _buildListTile(
          'Mood Trend',
          'View your emotional journey',
          Icons.show_chart,
          () => Navigator.pushNamed(context, '/mood-trend'),
        ),
        _buildListTile(
          'Activities Completed',
          '${(completionRate * 100).toInt()}% of recommended activities',
          Icons.check_box,
          () => Navigator.pushNamed(context, '/activity-history'),
        ),
        _buildListTile(
          'Assessment History',
          'Track your mental health scores',
          Icons.assessment,
          () => Navigator.pushNamed(context, '/assessment-history'),
        ),
        _buildListTile(
          'Journal Entries',
          '${totalDays} entries recorded',
          Icons.book,
          () => Navigator.pushNamed(context, '/journal'),
        ),
      ],
    );
  }

  Widget _buildSettingsSection() {
    return _buildSection(
      title: '⚙️ Settings & Preferences',
      children: [
        _buildListTile(
          'Account Settings',
          'Edit profile, email, password',
          Icons.person,
          _showEditProfileDialog,
        ),
        _buildSwitchTile(
          'Notifications',
          'Push notifications and alerts',
          Icons.notifications,
          notificationsEnabled,
          (value) {
            setState(() => notificationsEnabled = value);
            _saveUserData();
          },
        ),
        _buildSwitchTile(
          'Daily Mood Reminders',
          'Remind me to log my mood',
          Icons.alarm,
          dailyReminders,
          (value) {
            setState(() => dailyReminders = value);
            _saveUserData();
          },
        ),
        _buildListTile(
          'Privacy & Security',
          'Data privacy, biometric lock',
          Icons.security,
          _showPrivacySettings,
        ),
        _buildListTile(
          'Language',
          selectedLanguage,
          Icons.language,
          _showLanguageSelector,
        ),
        _buildListTile(
          'Theme',
          selectedTheme,
          Icons.palette,
          _showThemeSelector,
        ),
      ],
    );
  }

  Widget _buildSubscriptionCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6B9BD1), Color(0xFF8AB5DD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6B9BD1).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.workspace_premium,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Free Plan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Upgrade to Premium for unlimited access',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.check, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              const Text(
                'Unlimited mood tracking',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.check, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              const Text(
                'Advanced analytics & insights',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.check, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              const Text(
                'Priority support',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Navigate to subscription page
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF6B9BD1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            ),
            child: const Text(
              'Upgrade to Premium',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsCard() {
    return _buildSection(
      title: '🎯 Goals & Reminders',
      children: [
        _buildListTile(
          'Set Daily Goals',
          'Activities, mood check-ins, journaling',
          Icons.flag,
          () {},
        ),
        _buildListTile(
          'Reminder Schedule',
          'Customize notification times',
          Icons.schedule,
          () {},
        ),
        _buildListTile(
          'Weekly Targets',
          'Set weekly wellness objectives',
          Icons.trending_up,
          () {},
        ),
      ],
    );
  }

  Widget _buildAchievementsCard() {
    return _buildSection(
      title: '🏆 Achievements',
      children: [
        _buildListTile(
          'View All Badges',
          'You have $badges badges',
          Icons.emoji_events,
          () => Navigator.pushNamed(context, '/achievements'),
        ),
        const SizedBox(height: 12),
        _buildBadgeGrid(),
      ],
    );
  }

  Widget _buildBadgeGrid() {
    final badges = [
      {'icon': '🔥', 'name': '7-Day Streak', 'earned': true},
      {'icon': '✍️', 'name': 'First Journal', 'earned': true},
      {'icon': '🧘', 'name': '10 Activities', 'earned': true},
      {'icon': '📊', 'name': 'First Assessment', 'earned': true},
      {'icon': '🎯', 'name': 'Goal Setter', 'earned': false},
      {'icon': '💎', 'name': 'Premium Member', 'earned': false},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.start,
        children: badges.map((badge) {
          final earned = badge['earned'] as bool;
          final icon = badge['icon'] as String;
          final name = badge['name'] as String;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: earned ? const Color(0xFFFFF8E1) : Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20), // Pill shape
              border: Border.all(
                color: earned ? const Color(0xFFF4C96F) : Colors.transparent,
                width: 1,
              ),
              boxShadow: earned ? [
                 BoxShadow(
                  color: const Color(0xFFF4C96F).withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ] : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  icon,
                  style: TextStyle(
                    fontSize: 16,
                    color: earned ? null : Colors.grey,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: earned ? const Color(0xFF2D3748) : Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildResourcesCard() {
    return _buildSection(
      title: '📚 Resources & Help',
      children: [
        _buildListTile(
          'Help & Support',
          'FAQs, tutorials, contact us',
          Icons.help_outline,
          () {},
        ),
        _buildListTile(
          'Mental Health Resources',
          'Crisis hotlines, articles, videos',
          Icons.local_library,
          () {},
        ),
        _buildListTile(
          'About MindfulCare',
          'Version 1.0.0',
          Icons.info_outline,
          () {},
        ),
        _buildListTile(
          'Terms & Privacy',
          'Legal information',
          Icons.description,
          () {},
        ),
      ],
    );
  }

  Widget _buildDataManagementCard() {
    return _buildSection(
      title: '🗑️ Data & Account',
      children: [
        _buildListTile(
          'Export My Data',
          'Download all your data',
          Icons.download,
          _exportData,
          color: const Color(0xFF6B9BD1),
        ),
        _buildListTile(
          'Clear Mood Jar',
          'Reset your marble jar',
          Icons.delete_sweep,
          _confirmClearData,
          color: const Color(0xFFF4C96F),
        ),
        _buildListTile(
          'Delete Account',
          'Permanently delete your account',
          Icons.delete_forever,
          _confirmDeleteAccount,
          color: const Color(0xFFE89E98),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildListTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: (color ?? const Color(0xFF6B9BD1)).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: color ?? const Color(0xFF6B9BD1),
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF718096),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: const Color(0xFF718096).withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF6B9BD1).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF6B9BD1),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF718096),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF6B9BD1),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ElevatedButton(
        onPressed: _confirmLogout,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFFE89E98),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFE89E98), width: 2),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          minimumSize: const Size(double.infinity, 50),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout),
            SizedBox(width: 8),
            Text(
              'Logout',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dialog methods
  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: userName);
    final usernameController = TextEditingController(text: username);
    final emailController = TextEditingController(text: email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                prefixIcon: Icon(Icons.alternate_email),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                userName = nameController.text;
                username = usernameController.text;
                email = emailController.text;
              });
              _saveUserData();
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showLanguageSelector() {
    final languages = [
      'English',
      'हिन्दी (Hindi)',
      'मराठी (Marathi)',
      'ગુજરાતી (Gujarati)',
      'தமிழ் (Tamil)',
      'తెలుగు (Telugu)',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.map((lang) {
            return RadioListTile<String>(
              title: Text(lang),
              value: lang.split(' ').first,
              groupValue: selectedLanguage,
              onChanged: (value) {
                setState(() => selectedLanguage = value!);
                _saveUserData();
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showThemeSelector() {
    final themeService = Provider.of<ThemeService>(context, listen: false);
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Theme',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.light_mode),
                title: const Text('Light'),
                trailing: !themeService.isDarkMode ? const Icon(Icons.check, color: Color(0xFF6B9BD1)) : null,
                onTap: () {
                  if (themeService.isDarkMode) themeService.toggleTheme();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.dark_mode),
                title: const Text('Dark'),
                trailing: themeService.isDarkMode ? const Icon(Icons.check, color: Color(0xFF6B9BD1)) : null,
                onTap: () {
                  if (!themeService.isDarkMode) themeService.toggleTheme();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPrivacySettings() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy & Security',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            SwitchListTile(
              title: const Text('Biometric Lock'),
              subtitle: const Text('Use fingerprint/face ID'),
              value: false,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: const Text('Share Usage Data'),
              subtitle: const Text('Help improve the app'),
              value: true,
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Change Password'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.shield),
              title: const Text('Two-Factor Authentication'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  void _confirmClearData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Mood Jar?'),
        content: const Text(
          'This will permanently delete all marbles from your jar. '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // In a real app, clear data provider
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Mood jar cleared')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF4C96F),
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account?'),
        content: const Text(
          'Are you sure you want to delete your account? '
          'All your data will be permanently lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to login or perform delete logic
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE89E98),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _exportData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: const Text(
          'Your data will be exported as a ZIP file including:\n\n'
          '• Mood jar history\n'
          '• Journal entries\n'
          '• Assessment results\n'
          '• Activity logs\n\n'
          'This may take a few moments.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data export started! Check your downloads.'),
                ),
              );
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout?'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE89E98),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}