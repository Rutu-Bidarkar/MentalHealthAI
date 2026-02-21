import 'package:flutter/material.dart';
import 'data/dummy_data.dart';

class ConsultantScheduleScreen extends StatefulWidget {
  const ConsultantScheduleScreen({super.key});

  @override
  State<ConsultantScheduleScreen> createState() => _ConsultantScheduleScreenState();
}

class _ConsultantScheduleScreenState extends State<ConsultantScheduleScreen> {
  int _weekOffset = 0;

  static final _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  static final _times = ['9 AM', '10 AM', '11 AM', '12 PM', '1 PM', '2 PM', '3 PM', '4 PM', '5 PM'];

  // Grid: [timeIndex][dayIndex] -> status
  static const _grid = [
    ['blocked', '', '', '', '', ''],         // 9 AM
    ['', 'booked', '', '', '', ''],          // 10 AM
    ['', '', '', 'booked', '', ''],          // 11 AM
    ['available', '', '', '', '', ''],       // 12 PM
    ['blocked', 'blocked', 'blocked', 'blocked', 'blocked', 'blocked'], // 1 PM (lunch)
    ['available', 'available', '', '', 'booked', ''],   // 2 PM
    ['', '', 'booked', '', '', ''],          // 3 PM
    ['booked', '', '', 'booked', '', ''],    // 4 PM
    ['', 'available', 'available', '', 'available', ''], // 5 PM
  ];

  static const _labels = [
    ['Blocked', '', '', '', '', ''],
    ['', 'Rahul M.', '', '', '', ''],
    ['', '', '', 'Meera P.', '', ''],
    ['Open', '', '', '', '', ''],
    ['Lunch', 'Lunch', 'Lunch', 'Lunch', 'Lunch', 'Lunch'],
    ['Open', 'Open', '', '', 'Kavya I.', ''],
    ['', '', 'Ananya D.', '', '', ''],
    ['Arjun S.', '', '', 'Pooja V.', '', ''],
    ['', 'Open', 'Open', '', 'Open', ''],
  ];

  Color _cellColor(String s) {
    switch (s) {
      case 'booked':    return const Color(0xFF6B9BD1);
      case 'available': return const Color(0xFF7FC29B);
      case 'blocked':   return const Color(0xFFE2E8F0);
      default:          return const Color(0xFFF5F9FC);
    }
  }

  Color _cellText(String s) {
    switch (s) {
      case 'booked':    return Colors.white;
      case 'available': return const Color(0xFF1e8449);
      case 'blocked':   return const Color(0xFF718096);
      default:          return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime(2025, 2, 24).add(Duration(days: _weekOffset * 7));
    final weekStart = now.subtract(Duration(days: now.weekday - 1));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FC),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0.5,
            title: const Text('Schedule & Appointments', style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF2D3748))),
            actions: [
              IconButton(icon: const Icon(Icons.chevron_left, color: Color(0xFF2D3748)), onPressed: () => setState(() => _weekOffset--)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text('Feb ${weekStart.day}–${weekStart.add(const Duration(days: 5)).day}',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF2D3748))),
              ),
              IconButton(icon: const Icon(Icons.chevron_right, color: Color(0xFF2D3748)), onPressed: () => setState(() => _weekOffset++)),
              const SizedBox(width: 8),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(delegate: SliverChildListDelegate([

              // ── Rate card ─────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: const Color(0xFF6B9BD1).withOpacity(.08), blurRadius: 12)]),
                child: Column(children: [
                  Row(children: [
                    for (final item in const [('₹1,500', 'Initial'), ('₹1,200', 'Follow-up'), ('₹800', 'Group'), ('₹2,000', 'Urgent')])
                      Expanded(child: Column(children: [
                        Text(item.$1, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF6B9BD1))),
                        Text(item.$2, style: const TextStyle(fontSize: 10, color: Color(0xFF718096))),
                      ])),
                  ]),
                ]),
              ),

              // ── Legend ────────────────────────────────────────────────
              Row(children: [
                for (final item in const [
                  ('Booked', Color(0xFF6B9BD1)),
                  ('Available', Color(0xFF7FC29B)),
                  ('Blocked', Color(0xFFE2E8F0)),
                ])
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Row(children: [
                      Container(width: 12, height: 12, decoration: BoxDecoration(color: item.$2, borderRadius: BorderRadius.circular(3))),
                      const SizedBox(width: 4),
                      Text(item.$1, style: const TextStyle(fontSize: 11, color: Color(0xFF718096))),
                    ]),
                  ),
              ]),
              const SizedBox(height: 12),

              // ── Calendar grid ─────────────────────────────────────────
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: const Color(0xFF6B9BD1).withOpacity(.08), blurRadius: 12)]),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      // Day headers
                      Row(children: [
                        const SizedBox(width: 56),
                        for (int d = 0; d < 6; d++)
                          SizedBox(width: 90, child: Column(children: [
                            Text(_days[d], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF718096))),
                            Text('${weekStart.add(Duration(days: d)).day}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF2D3748))),
                          ])),
                      ]),
                      const SizedBox(height: 8),
                      // Time rows
                      for (int t = 0; t < _times.length; t++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(children: [
                            SizedBox(width: 56, child: Text(_times[t], style: const TextStyle(fontSize: 10, color: Color(0xFF718096)), textAlign: TextAlign.right)),
                            const SizedBox(width: 6),
                            for (int d = 0; d < 6; d++)
                              SizedBox(
                                width: 90, height: 48,
                                child: Container(
                                  margin: const EdgeInsets.all(2),
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: _cellColor(_grid[t][d]),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    _labels[t][d],
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: _cellText(_grid[t][d])),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                          ]),
                        ),
                    ]),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── Upcoming sessions ─────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: const Color(0xFF6B9BD1).withOpacity(.08), blurRadius: 12)]),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('📋 Upcoming Sessions', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                  const SizedBox(height: 12),
                  for (final p in ConsultantDummyData.patients.take(4))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(children: [
                        CircleAvatar(radius: 18, backgroundColor: const Color(0xFF6B9BD1),
                            child: Text(p.name.substring(0, 2), style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700))),
                        const SizedBox(width: 10),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(p.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                          Text('${p.lastDate} · Follow-up', style: const TextStyle(fontSize: 11, color: Color(0xFF718096))),
                        ])),
                        TextButton(onPressed: () {}, child: const Text('Start', style: TextStyle(fontSize: 11))),
                      ]),
                    ),
                ]),
              ),
              const SizedBox(height: 24),
            ])),
          ),
        ],
      ),
    );
  }
}
