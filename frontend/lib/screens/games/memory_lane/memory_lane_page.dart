import 'package:flutter/material.dart';

class MemoryLanePage extends StatelessWidget {
  const MemoryLanePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Memory Lane')),
      body: const Center(
        child: Text(
          'Memory Lane\nGame coming soon',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
