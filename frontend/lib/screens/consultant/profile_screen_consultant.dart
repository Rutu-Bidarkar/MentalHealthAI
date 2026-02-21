import 'package:flutter/material.dart';

class ConsultantProfileScreen extends StatefulWidget {
  const ConsultantProfileScreen({super.key});

  @override
  State<ConsultantProfileScreen> createState() => _ConsultantProfileScreenState();
}

class _ConsultantProfileScreenState extends State<ConsultantProfileScreen> {
  bool _videoEnabled = true;
  bool _audioEnabled = false;
  bool _notifications = true;
  bool _autoAccept = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FC),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            expandedHeight: 200,
            backgroundColor: const Color(0xFF1a2f4e),
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFF1a2f4e), Color(0xFF4a7ab5)],
                      begin: Alignment.topLeft, end: Alignment.bottomRight),
                ),
                child: SafeArea(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const SizedBox(height: 16),
                    Stack(children: [
                      const CircleAvatar(radius: 42, backgroundColor: Color(0xFF6B9BD1),
                          child: Text('PS', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800))),
                      Positioned(bottom: 0, right: 0, child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Color(0xFF7FC29B), shape: BoxShape.circle),
                        child: const Icon(Icons.check, color: Colors.white, size: 14),
                      )),
                    ]),
                    const SizedBox(height: 10),
                    const Text('Dr. Priya Sharma', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                    const Text('Clinical Psychologist · RCI Certified', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFF7FC29B), borderRadius: BorderRadius.circular(20)),
                      child: const Text('✓ Verified Professional', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                    ),
                  ]),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(delegate: SliverChildListDelegate([

              // ── Performance stats ─────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: const Color(0xFF6B9BD1).withOpacity(.08), blurRadius: 12)]),
                child: Row(children: [
                  for (final item in const [
                    ('10', 'Patients', '👥'),
                    ('105', 'Sessions', '📋'),
                    ('4.8', 'Rating', '⭐'),
                    ('6', 'Years', '🏆'),
                  ])
                    Expanded(child: Column(children: [
                      Text(item.$3, style: const TextStyle(fontSize: 22)),
                      Text(item.$1, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF2D3748))),
                      Text(item.$2, style: const TextStyle(fontSize: 10, color: Color(0xFF718096))),
                    ])),
                ]),
              ),
              const SizedBox(height: 14),

              // ── Personal info ─────────────────────────────────────────
              _Section(title: '👤 Personal Information', children: [
                _InfoRow('Name', 'Dr. Priya Sharma'),
                _InfoRow('Email', 'priya.sharma@example.com'),
                _InfoRow('Phone', '+91 98765 43210'),
                _InfoRow('City', 'Mumbai, Maharashtra'),
                _InfoRow('Languages', 'Hindi, English, Marathi'),
              ], action: TextButton(onPressed: () {}, child: const Text('Edit', style: TextStyle(fontSize: 12)))),
              const SizedBox(height: 14),

              // ── Professional info ─────────────────────────────────────
              _Section(title: '🏥 Professional Details', children: [
                _InfoRow('Degree', 'PhD (Clinical Psychology)'),
                _InfoRow('Council', 'Rehabilitation Council of India (RCI)'),
                _InfoRow('Reg. No.', 'RCI/2019/PSYCH/45823'),
                _InfoRow('Experience', '6 years'),
                _InfoRow('Bio', '"I specialise in CBT and mindfulness-based therapy for anxiety, depression, and trauma."'),
              ], action: null),
              const SizedBox(height: 14),

              // ── Specializations ────────────────────────────────────────
              _Section(title: '🎯 Specializations', children: [
                Wrap(spacing: 8, runSpacing: 8, children: [
                  for (final s in const ['Anxiety', 'Depression', 'Trauma & PTSD', 'Workplace Stress', 'Relationship Issues'])
                    Chip(label: Text(s, style: const TextStyle(fontSize: 11)), backgroundColor: const Color(0xFFE8F2FD),
                        side: BorderSide.none, visualDensity: VisualDensity.compact),
                ]),
              ], action: null),
              const SizedBox(height: 14),

              // ── Consultation settings ──────────────────────────────────
              _Section(title: '⚙️ Consultation Settings', children: [
                _SwitchRow('Video Consultations', 'Patients can book video sessions', _videoEnabled, (v) => setState(() => _videoEnabled = v)),
                _SwitchRow('Audio-Only Sessions', 'Audio-only sessions available', _audioEnabled, (v) => setState(() => _audioEnabled = v)),
                _SwitchRow('Session Reminders', 'Email/SMS reminders before sessions', _notifications, (v) => setState(() => _notifications = v)),
                _SwitchRow('Auto-Accept Bookings', 'For existing patients only', _autoAccept, (v) => setState(() => _autoAccept = v)),
              ], action: null),
              const SizedBox(height: 14),

              // ── Actions ────────────────────────────────────────────────
              Row(children: [
                Expanded(child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.logout, size: 16, color: Color(0xFF718096)),
                  label: const Text('Sign Out', style: TextStyle(color: Color(0xFF718096))),
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFFE2E8F0))),
                )),
                const SizedBox(width: 12),
                Expanded(child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.badge, size: 16),
                  label: const Text('View Certificate'),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6B9BD1), foregroundColor: Colors.white),
                )),
              ]),
              const SizedBox(height: 24),
            ])),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Widget? action;
  const _Section({required this.title, required this.children, this.action});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: const Color(0xFF6B9BD1).withOpacity(.08), blurRadius: 12)]),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Expanded(child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800))),
        if (action != null) action!,
      ]),
      const SizedBox(height: 12),
      ...children,
    ]),
  );
}

class _InfoRow extends StatelessWidget {
  final String label, value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(width: 82, child: Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF718096)))),
      Expanded(child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2D3748)))),
    ]),
  );
}

class _SwitchRow extends StatelessWidget {
  final String title, sub;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _SwitchRow(this.title, this.sub, this.value, this.onChanged);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(children: [
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        Text(sub, style: const TextStyle(fontSize: 11, color: Color(0xFF718096))),
      ])),
      Switch(value: value, onChanged: onChanged, activeColor: const Color(0xFF6B9BD1)),
    ]),
  );
}
