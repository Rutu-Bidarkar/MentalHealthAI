import 'package:flutter/material.dart';
import 'data/dummy_data.dart';

class ConsultantPatientDetailScreen extends StatelessWidget {
  final Patient patient;
  const ConsultantPatientDetailScreen({super.key, required this.patient});

  Color get _riskColor => patient.risk == 'high' ? const Color(0xFFE89E98) : patient.risk == 'medium' ? const Color(0xFFF4C96F) : const Color(0xFF7FC29B);
  Color get _riskBg => patient.risk == 'high' ? const Color(0xFFfdeaea) : patient.risk == 'medium' ? const Color(0xFFFDF5E0) : const Color(0xFFE8F5EE);
  String get _riskLabel => patient.risk == 'high' ? '🔴 High Risk' : patient.risk == 'medium' ? '🟡 At Risk' : '🟢 Stable';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FC),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0.5,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3748)),
              onPressed: () => Navigator.pop(context),
            ),
            title: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              Text(patient.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: Color(0xFF2D3748))),
              Text('${patient.age}, ${patient.gender} · ${patient.profession} · ${patient.location}',
                  style: const TextStyle(fontSize: 11, color: Color(0xFF718096))),
            ]),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: _riskBg, borderRadius: BorderRadius.circular(20)),
                child: Text(_riskLabel, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _riskColor)),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(delegate: SliverChildListDelegate([

              // ── Stat strip ───────────────────────────────────────────
              Row(children: [
                _StatChip(icon: '📅', label: 'Sessions', value: '${patient.sessions}'),
                const SizedBox(width: 8),
                _StatChip(icon: '📓', label: 'Journals', value: '${patient.journalEntries}'),
                const SizedBox(width: 8),
                _StatChip(icon: '😊', label: 'Avg Mood', value: '${patient.avgMood}'),
              ]),
              const SizedBox(height: 16),

              // ── Assessment scores ─────────────────────────────────────
              _Card(title: '🧠 Assessment Scores', child: Column(children: [
                _ScoreBar(label: 'PHQ-9 (Depression)', score: patient.avgDepression, maxScore: 27),
                const SizedBox(height: 12),
                _ScoreBar(label: 'GAD-7 (Anxiety)', score: patient.avgAnxiety, maxScore: 21),
                const SizedBox(height: 12),
                _ScoreBar(label: 'Mood Score', score: patient.avgMood, maxScore: 10, inverse: true),
              ])),
              const SizedBox(height: 14),

              // ── Trend chart ───────────────────────────────────────────
              _Card(title: '📈 Emotional Trend (Last ${patient.trend.length} Check-ins)', child:
                SizedBox(height: 180, child: _TrendChart(points: patient.trend))),
              const SizedBox(height: 14),

              // ── Risk alert ────────────────────────────────────────────
              if (patient.risk == 'high') ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: const Color(0xFFfdeaea), borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE89E98))),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('🔴 HIGH RISK ALERT', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Color(0xFFc0392b))),
                    const SizedBox(height: 8),
                    Text('PHQ-9: ${patient.avgDepression} | GAD-7: ${patient.avgAnxiety} | Mood: ${patient.avgMood}/10',
                        style: const TextStyle(fontSize: 13, color: Color(0xFF2D3748))),
                    const SizedBox(height: 10),
                    const Text('Recommended Actions:', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                    const SizedBox(height: 6),
                    for (final a in const ['Schedule urgent check-in call', 'Send supportive message', 'Review crisis protocol', 'Consider medication adjustment'])
                      Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Row(children: [
                        const Icon(Icons.check_box_outline_blank, size: 16, color: Color(0xFF718096)),
                        const SizedBox(width: 6),
                        Text(a, style: const TextStyle(fontSize: 12)),
                      ])),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE89E98), foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), textStyle: const TextStyle(fontSize: 12)),
                      child: const Text('Take Action'),
                    ),
                  ]),
                ),
                const SizedBox(height: 14),
              ],

              // ── Session notes ─────────────────────────────────────────
              _Card(title: '🔏 Session Notes (Private)', child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  const Expanded(child: Text('Latest Session', style: TextStyle(fontWeight: FontWeight.w700))),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFFE8F2FD), borderRadius: BorderRadius.circular(6)),
                    child: const Text('Follow-up · ${ConsultantPatientDetailScreen._lastNote}', style: TextStyle(fontSize: 10, color: Color(0xFF4a7ab5))),
                  ),
                ]),
                const SizedBox(height: 12),
                for (final section in const {
                  'Chief Complaints': ['Work-related stress intensifying', 'Sleep issues (3–4 hrs/night)', 'Avoiding social situations'],
                  'Observations':     ['Appeared tired, less engaged', 'Sleep improving gradually', 'Medication compliance: Good'],
                  'Interventions':    ['CBT techniques applied', 'Sleep hygiene psychoeducation', 'Gratitude journal assigned'],
                }.entries) ...[
                  Text(section.key, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Color(0xFF718096))),
                  const SizedBox(height: 4),
                  for (final c in section.value)
                    Padding(padding: const EdgeInsets.symmetric(vertical: 1),
                        child: Text('• $c', style: const TextStyle(fontSize: 12, color: Color(0xFF2D3748)))),
                  const SizedBox(height: 10),
                ],
                const Text('🔒 Notes are HIPAA-compliant and only visible to you.', style: TextStyle(fontSize: 10, color: Color(0xFF718096))),
              ])),
              const SizedBox(height: 14),

              // ── Recent journal ────────────────────────────────────────
              _Card(title: '📝 Recent Journal Entries', child: Column(children: [
                _JournalTile(date: patient.lastDate, time: '9:30 PM', mood: '😔', score: 4,
                    text: '"Feeling overwhelmed with work. Had a rough day managing stress..."',
                    sentiment: 'Negative'),
                const SizedBox(height: 8),
                _JournalTile(date: patient.lastDate, time: '7:15 AM', mood: '🙂', score: 7,
                    text: '"Went for a morning walk. Feeling slightly better than yesterday..."',
                    sentiment: 'Positive'),
              ])),
              const SizedBox(height: 24),
            ])),
          ),
        ],
      ),
    );
  }

  static const _lastNote = 'Feb 20, 2025';
}

// ── Subwidgets ──────────────────────────────────────────────────────────────
class _StatChip extends StatelessWidget {
  final String icon, label, value;
  const _StatChip({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: const Color(0xFF6B9BD1).withOpacity(.08), blurRadius: 8)]),
      child: Column(children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF2D3748))),
        Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF718096))),
      ]),
    ),
  );
}

class _Card extends StatelessWidget {
  final String title;
  final Widget child;
  const _Card({required this.title, required this.child});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: const Color(0xFF6B9BD1).withOpacity(.08), blurRadius: 12)]),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
      const SizedBox(height: 14),
      child,
    ]),
  );
}

class _ScoreBar extends StatelessWidget {
  final String label;
  final double score, maxScore;
  final bool inverse;
  const _ScoreBar({required this.label, required this.score, required this.maxScore, this.inverse = false});

  Color get _color {
    final pct = score / maxScore;
    if (inverse) return pct >= 0.6 ? const Color(0xFF7FC29B) : pct >= 0.4 ? const Color(0xFFF4C96F) : const Color(0xFFE89E98);
    return pct >= 0.6 ? const Color(0xFFE89E98) : pct >= 0.4 ? const Color(0xFFF4C96F) : const Color(0xFF7FC29B);
  }

  @override
  Widget build(BuildContext context) {
    final pct = (score / maxScore).clamp(0.0, 1.0);
    return Column(children: [
      Row(children: [
        Expanded(child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
        Text('${score.toStringAsFixed(1)} / ${maxScore.toStringAsFixed(0)}',
            style: TextStyle(fontWeight: FontWeight.w700, color: _color, fontSize: 13)),
      ]),
      const SizedBox(height: 6),
      ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: LinearProgressIndicator(
          value: pct, minHeight: 8,
          backgroundColor: const Color(0xFFE2E8F0),
          valueColor: AlwaysStoppedAnimation(_color),
        ),
      ),
    ]);
  }
}

class _TrendChart extends StatelessWidget {
  final List<TrendPoint> points;
  const _TrendChart({required this.points});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _TrendPainter(points: points), child: const SizedBox.expand());
  }
}

class _TrendPainter extends CustomPainter {
  final List<TrendPoint> points;
  _TrendPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final paint = Paint()..color = const Color(0xFF6B9BD1)..strokeWidth = 2.5..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final fillPaint = Paint()..shader = LinearGradient(
      begin: Alignment.topCenter, end: Alignment.bottomCenter,
      colors: [const Color(0xFF6B9BD1).withOpacity(.18), Colors.transparent],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    final thresh = Paint()..color = const Color(0xFFE89E98).withOpacity(.5)..strokeWidth = 1.5..style = PaintingStyle.stroke;

    final path = Path(), fill = Path();
    final n = points.length;
    for (int i = 0; i < n; i++) {
      final x = i / (n - 1) * size.width;
      final y = size.height - (points[i].score / 10) * size.height;
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
      i == 0 ? fill.moveTo(x, y) : fill.lineTo(x, y);
    }
    fill..lineTo(size.width, size.height)..lineTo(0, size.height)..close();

    canvas.drawPath(fill, fillPaint);
    canvas.drawPath(path, paint);

    // Threshold at 6
    final ty = size.height - 0.6 * size.height;
    canvas.drawLine(Offset(0, ty), Offset(size.width, ty), thresh);

    final dotP = Paint()..color = const Color(0xFF6B9BD1)..style = PaintingStyle.fill;
    for (int i = 0; i < n; i++) {
      final x = i / (n - 1) * size.width;
      final y = size.height - (points[i].score / 10) * size.height;
      canvas.drawCircle(Offset(x, y), 3.5, dotP);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _JournalTile extends StatelessWidget {
  final String date, time, mood, text, sentiment;
  final int score;
  const _JournalTile({required this.date, required this.time, required this.mood, required this.score, required this.text, required this.sentiment});

  Color get _border => score >= 7 ? const Color(0xFF7FC29B) : score >= 5 ? const Color(0xFFF4C96F) : const Color(0xFFE89E98);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F9FC), borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: _border, width: 3.5)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text('$date · $time', style: const TextStyle(fontSize: 11, color: Color(0xFF718096)))),
          Text('$mood $score/10', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: 6),
        Text(text, style: const TextStyle(fontSize: 12, color: Color(0xFF2D3748))),
        const SizedBox(height: 4),
        Text('Sentiment: $sentiment', style: const TextStyle(fontSize: 10, color: Color(0xFF718096))),
      ]),
    );
  }
}
