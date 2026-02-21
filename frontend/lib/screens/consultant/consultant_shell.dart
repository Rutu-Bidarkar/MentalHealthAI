import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'patients_screen.dart';
import 'schedule_screen.dart';
import 'billing_screen.dart';
import 'profile_screen_consultant.dart';

/// Shared shell for all consultant portal screens after login.
/// Uses NavigationRail on wide screens, BottomNavigationBar on mobile.
class ConsultantShell extends StatefulWidget {
  final int initialIndex;
  const ConsultantShell({super.key, this.initialIndex = 0});

  @override
  State<ConsultantShell> createState() => _ConsultantShellState();
}

class _ConsultantShellState extends State<ConsultantShell> {
  late int _idx;

  static const _navItems = [
    _NavItem(icon: Icons.dashboard_outlined,        activeIcon: Icons.dashboard,        label: 'Dashboard', index: 0),
    _NavItem(icon: Icons.people_outline,            activeIcon: Icons.people,           label: 'Patients',  index: 1),
    _NavItem(icon: Icons.calendar_today_outlined,  activeIcon: Icons.calendar_today,   label: 'Schedule',  index: 2),
    _NavItem(icon: Icons.receipt_long_outlined,    activeIcon: Icons.receipt_long,     label: 'Billing',   index: 3),
    _NavItem(icon: Icons.manage_accounts_outlined, activeIcon: Icons.manage_accounts,  label: 'Profile',   index: 4),
  ];

  @override
  void initState() {
    super.initState();
    _idx = widget.initialIndex;
  }

  Widget _page() {
    switch (_idx) {
      case 0: return const ConsultantDashboardScreen();
      case 1: return const ConsultantPatientsScreen();
      case 2: return const ConsultantScheduleScreen();
      case 3: return const ConsultantBillingScreen();
      case 4: return const ConsultantProfileScreen();
      default: return const ConsultantDashboardScreen();
    }
  }


  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 720;
    final theme = Theme.of(context);

    if (isWide) {
      // ── Wide: NavigationRail sidebar ────────────────────────────────
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _idx,
              onDestinationSelected: (i) => setState(() => _idx = i),
              extended: MediaQuery.of(context).size.width >= 1000,
              backgroundColor: const Color(0xFF1a2f4e),
              selectedIconTheme: const IconThemeData(color: Color(0xFF6B9BD1)),
              unselectedIconTheme: IconThemeData(color: Colors.white.withOpacity(0.55)),
              selectedLabelTextStyle: const TextStyle(color: Color(0xFF6B9BD1), fontWeight: FontWeight.w700, fontSize: 12),
              unselectedLabelTextStyle: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 12),
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    Image.asset('assets/images/Logo.png', width: 36, height: 36),
                    const SizedBox(height: 4),
                    Text(
                      'MindfulCare',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      'CONSULTANT',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.40),
                        fontSize: 10,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),

              trailing: Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: const Color(0xFF6B9BD1),
                          child: const Text('PS', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(height: 6),
                        Text('Dr. Priya', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11)),
                      ],
                    ),
                  ),
                ),
              ),
              destinations: _navItems
                  .map((n) => NavigationRailDestination(
                        icon: Icon(n.icon),
                        selectedIcon: Icon(n.activeIcon),
                        label: Text(n.label),
                      ))
                  .toList(),
            ),
            const VerticalDivider(thickness: 0, width: 0),
            Expanded(child: _page()),
          ],
        ),
      );
    } else {
      // ── Narrow: BottomNavigationBar ─────────────────────────────────

      return Scaffold(
        body: _page(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _idx.clamp(0, _navItems.length - 1),
          onTap: (i) => setState(() => _idx = i),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: theme.colorScheme.primary,
          items: _navItems.map((n) => BottomNavigationBarItem(
            icon: Icon(n.icon),
            activeIcon: Icon(n.activeIcon),
            label: n.label,
          )).toList(),
        ),
      );
    }
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int index;
  const _NavItem({required this.icon, required this.activeIcon, required this.label, required this.index});
}
