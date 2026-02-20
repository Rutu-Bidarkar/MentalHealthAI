import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ConsultancyPage extends StatefulWidget {
  const ConsultancyPage({super.key});

  @override
  State<ConsultancyPage> createState() => _ConsultancyPageState();
}

class _ConsultancyPageState extends State<ConsultancyPage> {
  final TextEditingController locationController = TextEditingController();

  Future<void> searchPsychologists() async {
    final location = locationController.text.trim();

    if (location.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter a location")));
      return;
    }

    try {
      final uri = Uri.http('localhost:8000', '/api/psychologists/nearby', {
        'location': location,
      });

      final res = await http.get(uri);

      if (res.statusCode != 200) {
        throw Exception("Failed to fetch psychologists");
      }

      final data = jsonDecode(res.body);

      if (data is List && data.isEmpty) {
        throw Exception("No psychologists found");
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PsychologistListScreen(psychologists: data),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 🌿 FULL BACKGROUND IMAGE
          SizedBox.expand(
            child: Image.asset(
              "assets/images/consultancy_image.png",
              fit: BoxFit.cover,
            ),
          ),

          /// 🌿 SOFT BEIGE OVERLAY
          Container(color: const Color(0xFFF6F1E9).withOpacity(0.90)),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 30),

                const Text(
                  "Find trusted psychologists near you",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF3E3A39),
                  ),
                ),

                const SizedBox(height: 10),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "Enter your location to discover professional mental health support around you",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.5, color: Color(0xFF6D645C)),
                  ),
                ),

                const SizedBox(height: 30),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: locationController,
                          decoration: InputDecoration(
                            hintText: "Enter city or area",
                            prefixIcon: const Icon(Icons.location_on_outlined),
                            filled: true,
                            fillColor: const Color(0xFFF7F3EE),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: searchPsychologists,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8E7C6F),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              "Search Nearby",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Image.asset(
                    "assets/images/consultancy_image.png",
                    height: 240,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PsychologistListScreen extends StatelessWidget {
  final List psychologists;

  const PsychologistListScreen({super.key, required this.psychologists});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// BACKGROUND
          SizedBox.expand(
            child: Image.asset(
              "assets/images/consultancy_image.png",
              fit: BoxFit.cover,
            ),
          ),

          Container(color: const Color(0xFFF6F1E9).withOpacity(0.92)),

          SafeArea(
            child: Column(
              children: [
                /// APP BAR
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        "Nearby Psychologists",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF3E3A39),
                        ),
                      ),
                    ],
                  ),
                ),

                /// LIST
                Expanded(
                  child: psychologists.isEmpty
                      ? const Center(
                          child: Text(
                            "No psychologists found",
                            style: TextStyle(color: Color(0xFF6D645C)),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          itemCount: psychologists.length,
                          itemBuilder: (context, index) {
                            final p = psychologists[index];

                            return Container(
                              margin: const EdgeInsets.only(bottom: 14),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF1E8DD),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.psychology,
                                      color: Color(0xFF8E7C6F),
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          p["name"] ?? "",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF3E3A39),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          p["address"] ?? "",
                                          style: const TextStyle(
                                            fontSize: 13.5,
                                            color: Color(0xFF6D645C),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  if (p["rating"] != null)
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          size: 18,
                                          color: Colors.amber,
                                        ),
                                        const SizedBox(width: 3),
                                        Text(
                                          p["rating"].toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
