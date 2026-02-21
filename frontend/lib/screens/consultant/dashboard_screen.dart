import 'package:flutter/material.dart';
import 'data/dummy_data.dart';
import 'patient_detail_screen.dart';

class ConsultantDashboardScreen extends StatelessWidget {
  const ConsultantDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = ConsultantDummyData.dashboardStats;
    final recent = ConsultantDummyData.patients.take(6).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FC),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0.5,
            expandedHeight: 0,
            title: Row(children: [
              const Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Good Evening, Dr. Priya! 🌙',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF2D3748))),
                  Text('Next session: 5:00 PM with Rahul Mehta',
                      style: TextStyle(fontSize: 12, color: Color(0xFF718096))),
                ],
              )),
              const CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xFF6B9BD1),
                child: Text('PS', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
              ),
            ]),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(delegate: SliverChildListDelegate([

              // ── Stat cards ────────────────────────────────────────────
              _StatGrid(stats: stats),
              const SizedBox(height: 20),

              // ── Trend chart ───────────────────────────────────────────
              _SectionCard(
                title: '📈 Emotional Well-being Trend',
                trailing: 'Last 30 days',
                child: SizedBox(height: 180, child: _TrendChart(
                  points: ConsultantDummyData.patients.first.trend,
                )),
              ),
              const SizedBox(height: 16),

              // ── Risk overview ─────────────────────────────────────────
              Row(children: [
                Expanded(child: _RiskCard(
                  label: 'High Risk', count: stats['highRisk'] as int, color: const Color(0xFFE89E98), bg: const Color(0xFFfdeaea))),
                const SizedBox(width: 12),
                Expanded(child: _RiskCard(
                  label: 'At Risk', count: stats['medRisk'] as int, color: const Color(0xFFF4C96F), bg: const Color(0xFFFDF5E0))),
                const SizedBox(width: 12),
                Expanded(child: _RiskCard(
                  label: 'Stable', count: stats['lowRisk'] as int, color: const Color(0xFF7FC29B), bg: const Color(0xFFE8F5EE))),
              ]),
              const SizedBox(height: 20),

              // ── Today's schedule ──────────────────────────────────────
              _SectionCard(
                title: '📅 Today\'s Schedule',
                trailing: 'Full Calendar',
                child: Column(children: const [
                  _AppointmentTile(time: '3:00–4:00 PM', name: 'Ananya Deshmukh', type: 'Initial Consultation', status: 'done'),
                  _AppointmentTile(time: '5:00–6:00 PM', name: 'Rahul Mehta', type: 'Follow-up Session', status: 'upcoming'),
                  _AppointmentTile(time: '6:30–7:30 PM', name: 'Open Slot', type: 'Available for booking', status: 'available'),
                ]),
              ),
              const SizedBox(height: 20),

              // ── Recent patients ────────────────────────────────────────
              _SectionCard(
                title: '👥 Recent Patients',
                trailing: 'View All',
                child: Column(
                  children: recent.map((p) => _PatientRow(patient: p)).toList(),
                ),
              ),
              const SizedBox(height: 20),
            ])),
          ),
        ],
      ),
    );
  }
}

class _StatGrid extends StatelessWidget {
  final Map<String, dynamic> stats;
  const _StatGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    final cards = [
      _StatCard(icon: '👥', label: 'Patients',  value: '${stats['totalPatients']}', trend: '+3 this month', bubbleColor: const Color(0xFFE8F2FD)),
      _StatCard(icon: '📓', label: 'Journals',  value: '${stats['totalJournals']}',  trend: 'Active users',   bubbleColor: const Color(0xFFE8F5EE)),
      _StatCard(icon: '😊', label: 'Avg Mood',  value: '${stats['avgMood']}',        trend: stats['avgMood'] < 6.0 ? '⚠️ Low' : '✓ OK', bubbleColor: const Color(0xFFFDF5E0)),
      _StatCard(icon: '📋', label: 'Sessions',  value: '${stats['totalSessions']}',  trend: 'PHQ, GAD',       bubbleColor: const Color(0xFFfdeaea)),
    ];
    return Row(
      children: cards
          .expand((c) => [Expanded(child: c), const SizedBox(width: 10)])
          .toList()
          ..removeLast(),
    );
  }
}


class _StatCard extends StatelessWidget {
  final String icon, label, value, trend;
  final Color bubbleColor;
  const _StatCard({required this.icon, required this.label, required this.value, required this.trend, required this.bubbleColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: const Color(0xFF6B9BD1).withOpacity(.08), blurRadius: 12)]),
      child: Row(children: [
        Container(width: 40, height: 40, decoration: BoxDecoration(color: bubbleColor, borderRadius: BorderRadius.circular(10)),
            child: Center(child: Text(icon, style: const TextStyle(fontSize: 19)))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF2D3748))),
          Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF718096))),
          Text(trend, style: const TextStyle(fontSize: 10, color: Color(0xFF7FC29B), fontWeight: FontWeight.w600)),
        ])),
      ]),
    );
  }
}

// ── Trend Chart (CustomPainter) ─────────────────────────────────────────────
class _TrendChart extends StatelessWidget {
  final List<TrendPoint> points;
  const _TrendChart({required this.points});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _TrendPainter(points: points),
      child: const SizedBox.expand(),
    );
  }
}

class _TrendPainter extends CustomPainter {
  final List<TrendPoint> points;
  _TrendPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final minY = 0.0, maxY = 10.0;
    final paint = Paint()..color = const Color(0xFF6B9BD1)..strokeWidth = 2.5..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final fillPaint  = Paint()..shader = LinearGradient(
      begin: Alignment.topCenter, end: Alignment.bottomCenter,
      colors: [const Color(0xFF6B9BD1).withOpacity(.18), Colors.transparent],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    final thresh = Paint()..color = const Color(0xFFE89E98).withOpacity(.5)..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    final fill = Path();
    final n = points.length;

    for (int i = 0; i < n; i++) {
      final x = i / (n - 1) * size.width;
      final y = size.height - (points[i].score - minY) / (maxY - minY) * size.height;
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
      i == 0 ? fill.moveTo(x, y) : fill.lineTo(x, y);
    }
    fill.lineTo(size.width, size.height);
    fill.lineTo(0, size.height);
    fill.close();

    canvas.drawPath(fill, fillPaint);
    canvas.drawPath(path, paint);

    // Threshold line at 6
    final ty = size.height - (6.0 - minY) / (maxY - minY) * size.height;
    canvas.drawLine(Offset(0, ty), Offset(size.width, ty), thresh);

    // Dots
    final dotP = Paint()..color = const Color(0xFF6B9BD1)..style = PaintingStyle.fill;
    for (int i = 0; i < n; i++) {
      final x = i / (n - 1) * size.width;
      final y = size.height - (points[i].score - minY) / (maxY - minY) * size.height;
      canvas.drawCircle(Offset(x, y), 3.5, dotP);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ── Risk card ───────────────────────────────────────────────────────────────
class _RiskCard extends StatelessWidget {
  final String label;
  final int count;
  final Color color, bg;
  const _RiskCard({required this.label, required this.count, required this.color, required this.bg});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(.3))),
    child: Column(children: [
      Text('$count', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: color)),
      Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF718096))),
    ]),
  );
}

// ── Section card ────────────────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final String title, trailing;
  final Widget child;
  const _SectionCard({required this.title, required this.trailing, required this.child});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: const Color(0xFF6B9BD1).withOpacity(.08), blurRadius: 12)]),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Expanded(child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700))),
        Text(trailing, style: const TextStyle(fontSize: 12, color: Color(0xFF6B9BD1))),
      ]),
      const SizedBox(height: 14),
      child,
    ]),
  );
}

// ── Appointment tile ────────────────────────────────────────────────────────
class _AppointmentTile extends StatelessWidget {
  final String time, name, type, status;
  const _AppointmentTile({required this.time, required this.name, required this.type, required this.status});

  @override
  Widget build(BuildContext context) {
    final c = status == 'done' ? Colors.grey : status == 'upcoming' ? const Color(0xFF7FC29B) : const Color(0xFF6B9BD1);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F9FC),
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: c, width: 3.5)),
      ),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(time, style: const TextStyle(fontSize: 11, color: Color(0xFF718096))),
          Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          Text(type, style: const TextStyle(fontSize: 11, color: Color(0xFF718096))),
        ])),
        if (status == 'upcoming')
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6B9BD1), foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), textStyle: const TextStyle(fontSize: 11)),
            child: const Text('▶ Start'),
          ),
      ]),
    );
  }
}

// ── Patient row ─────────────────────────────────────────────────────────────
class _PatientRow extends StatelessWidget {
  final Patient patient;
  const _PatientRow({required this.patient});

  Color get _riskColor => patient.risk == 'high' ? const Color(0xFFE89E98) : patient.risk == 'medium' ? const Color(0xFFF4C96F) : const Color(0xFF7FC29B);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ConsultantPatientDetailScreen(patient: patient))),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(children: [
          CircleAvatar(radius: 20, backgroundColor: const Color(0xFF6B9BD1),
              child: Text(patient.name.substring(0, 2).toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(patient.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            Text('${patient.age}, ${patient.gender} · ${patient.location}', style: const TextStyle(fontSize: 11, color: Color(0xFF718096))),
          ])),
          Container(width: 10, height: 10, decoration: BoxDecoration(color: _riskColor, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text(patient.risk.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: _riskColor)),
        ]),
      ),
    );
  }
}
