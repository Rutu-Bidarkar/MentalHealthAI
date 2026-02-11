import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/Auth/login.dart';
import 'screens/Auth/signup.dart';
import 'screens/dynamictest.dart';
import 'screens/home.dart';
import 'screens/landing1.dart';
import 'screens/tests.dart';
import 'screens/journal.dart';
import 'screens/profile_screen.dart';
import 'screens/activities.dart';
import 'screens/community.dart';
import 'screens/test_results_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TestResultsProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mental Health AI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Inter',
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const Landing1(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/home': (context) => const HomeScreen(),
        '/tests': (context) => TestsPage(),
        '/journal': (context) => const JournalPage(),
        '/test/baseline': (context) => const DynamicTestPage(testId: 'baseline'),
        '/test/anxiety-screening': (context) => const DynamicTestPage(testId: 'anxiety-screening'),
        '/test/depression-screening': (context) => const DynamicTestPage(testId: 'depression-screening'),
        '/test/stress-resilience': (context) => const DynamicTestPage(testId: 'stress-resilience'),
        '/mood-trend': (context) => Scaffold(appBar: AppBar(title: const Text('Mood Trend')), body: const Center(child: Text('Coming Soon'))),
        '/activity-history': (context) => Scaffold(appBar: AppBar(title: const Text('Activity History')), body: const Center(child: Text('Coming Soon'))),
        '/assessment-history': (context) => Scaffold(appBar: AppBar(title: const Text('Assessment History')), body: const Center(child: Text('Coming Soon'))),
        '/achievements': (context) => Scaffold(appBar: AppBar(title: const Text('Achievements')), body: const Center(child: Text('Coming Soon'))),
        // Placeholder for profile page to prevent navigation errors
        '/profile': (context) => const ProfileScreen(), // Assuming ProfileScreen exists and is imported
        '/games': (context) => Scaffold(appBar: AppBar(title: const Text('Games')), body: const Center(child: Text('Games Page'))),
        '/activities': (context) => const ActivitiesPage(), // Assuming ActivitiesPage exists
        '/community': (context) => const CommunityPage(), // Assuming CommunityPage exists
        '/consult': (context) => Scaffold(appBar: AppBar(title: const Text('Consult')), body: const Center(child: Text('Consult Page'))),
        '/reports': (context) => Scaffold(appBar: AppBar(title: const Text('Reports')), body: const Center(child: Text('Reports Page'))),
        '/test-construction': (context) => Scaffold(appBar: AppBar(title: const Text('Mental Health Test')), body: const Center(child: Text('Under Construction'))),
      },
    );
  }
}
