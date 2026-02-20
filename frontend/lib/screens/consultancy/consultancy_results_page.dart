import 'package:flutter/material.dart';

class ConsultancyResultsPage extends StatelessWidget {
  final List psychologists;

  const ConsultancyResultsPage({super.key, required this.psychologists});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F1E9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F1E9),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Nearby Psychologists",
          style: TextStyle(
            color: Color(0xFF3E3A39),
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF3E3A39)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: psychologists.length,
        itemBuilder: (context, index) {
          final p = psychologists[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // avatar
                Container(
                  width: 46,
                  height: 46,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEDE5D8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.psychology, color: Color(0xFF8E7C6F)),
                ),

                const SizedBox(width: 14),

                // text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p["name"] ?? "",
                        style: const TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF3E3A39),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        p["address"] ?? "",
                        style: const TextStyle(
                          fontSize: 13.5,
                          color: Color(0xFF6D645C),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // rating
                Column(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(height: 2),
                    Text(
                      (p["rating"] ?? "-").toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6D645C),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
