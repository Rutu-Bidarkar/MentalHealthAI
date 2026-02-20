import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/auth/login.dart';
import 'screens/auth/signup.dart';
import 'screens/dynamictest.dart';
import 'screens/home/home.dart';
import 'screens/landing1.dart';
import 'screens/tests_temp.dart';
import 'screens/test_results_provider.dart';
import 'screens/games/games_page.dart';
import 'screens/community/community_page.dart';
import 'screens/consultancy/consultancy_page.dart';

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
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Inter'),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const Landing1(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/home': (context) => const HomeScreen(),
        '/tests': (context) => TestsPage(),
        '/test/baseline': (context) =>
            const DynamicTestPage(testId: 'baseline'),
        '/test/anxiety': (context) =>
            const DynamicTestPage(testId: 'anxiety-screening'),
        '/test/depression': (context) =>
            const DynamicTestPage(testId: 'depression-screening'),
        '/test/stress': (context) =>
            const DynamicTestPage(testId: 'stress-resilience'),
        '/games': (context) => const GamesPage(),
        '/community': (context) => const CommunityPage(),
        '/consultancy': (context) => ConsultancyPage(),
      },
    );
  }
}
