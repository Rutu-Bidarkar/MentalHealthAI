import 'package:flutter/material.dart';
import '../../models/game_item.dart';
import '../../widgets/game_card.dart';

// individual game pages
import 'pop_and_slash/pop_and_slash_page.dart';
import 'memory_lane/memory_lane_page.dart';
import 'brain_pretzel/brain_pretzel_page.dart';

class GamesPage extends StatelessWidget {
  const GamesPage({super.key});

  static const List<GameItem> games = [
    GameItem(
      id: 'pop_and_slash',
      title: 'Pop and Slash',
      description: 'Reaction & focus',
      imagePath: 'assets/images/PopandSlash.png',
    ),
    GameItem(
      id: 'memory_lane',
      title: 'Memory Lane',
      description: 'Short-term memory',
      imagePath: 'assets/images/MemoryLane.png',
    ),
    GameItem(
      id: 'brain_pretzel',
      title: 'Brain Pretzel',
      description: 'Problem-solving',
      imagePath: 'assets/images/brainPretzel.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Games'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),

      body: Stack(
        children: [
          /// 🌿 Base gradient (calm)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFF7FAFC), // very soft blue-white
                  Color(0xFFEFF3F7), // calm grey-blue
                ],
              ),
            ),
          ),

          /// ✨ Soft texture overlay (very subtle)
          Positioned.fill(
            child: Opacity(
              opacity: 0.04,
              child: CustomPaint(painter: _SoftDotPainter()),
            ),
          ),

          /// 🎮 Content
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.builder(
                  itemCount: games.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    final game = games[index];
                    return GameCard(
                      title: game.title,
                      description: game.description,
                      imagePath: game.imagePath,
                      onTap: () => _openGame(context, game.id),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openGame(BuildContext context, String gameId) {
    switch (gameId) {
      case 'pop_and_slash':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PopAndSlashPage()),
        );
        break;

      case 'memory_lane':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MemoryLanePage()),
        );
        break;

      case 'brain_pretzel':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BrainPretzelPage()),
        );
        break;
    }
  }
}

/// 🌫️ Ultra-soft dot texture (calming, not noisy)
class _SoftDotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;

    const spacing = 28.0;
    const radius = 1.0;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
