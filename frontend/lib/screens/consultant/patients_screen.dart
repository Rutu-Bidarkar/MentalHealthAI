import 'package:flutter/material.dart';
import 'data/dummy_data.dart';
import 'patient_detail_screen.dart';

class ConsultantPatientsScreen extends StatefulWidget {
  const ConsultantPatientsScreen({super.key});

  @override
  State<ConsultantPatientsScreen> createState() => _ConsultantPatientsScreenState();
}

class _ConsultantPatientsScreenState extends State<ConsultantPatientsScreen> {
  String _query = '';
  String _riskFilter = '';  // '', 'high', 'medium', 'low'

  List<Patient> get _filtered => ConsultantDummyData.patients.where((p) {
    final matchQ = _query.isEmpty || p.name.toLowerCase().contains(_query.toLowerCase());
    final matchR = _riskFilter.isEmpty || p.risk == _riskFilter;
    return matchQ && matchR;
  }).toList();

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final stats = ConsultantDummyData.dashboardStats;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FC),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0.5,
            title: const Text('My Patients', style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF2D3748))),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Row(children: [
                  Expanded(
                    child: TextField(
                      onChanged: (v) => setState(() => _query = v),
                      decoration: InputDecoration(
                        hintText: '🔍  Search patients…',
                        hintStyle: const TextStyle(color: Color(0xFF718096), fontSize: 13),
                        filled: true, fillColor: const Color(0xFFF5F9FC),
                        suffixIcon: _query.isNotEmpty ? IconButton(icon: const Icon(Icons.clear, size: 18), onPressed: () => setState(() => _query = '')) : null,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF6B9BD1), width: 2)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(delegate: SliverChildListDelegate([
              // Summary: Total / High / Med / Low
              Row(children: [
                _SummaryChip(label: 'All', count: ConsultantDummyData.patients.length, color: const Color(0xFF6B9BD1), active: _riskFilter.isEmpty, onTap: () => setState(() => _riskFilter = '')),
                const SizedBox(width: 8),
                _SummaryChip(label: 'High Risk', count: stats['highRisk'] as int, color: const Color(0xFFE89E98), active: _riskFilter == 'high', onTap: () => setState(() => _riskFilter = _riskFilter == 'high' ? '' : 'high')),
                const SizedBox(width: 8),
                _SummaryChip(label: 'At Risk', count: stats['medRisk'] as int, color: const Color(0xFFF4C96F), active: _riskFilter == 'medium', onTap: () => setState(() => _riskFilter = _riskFilter == 'medium' ? '' : 'medium')),
                const SizedBox(width: 8),
                _SummaryChip(label: 'Stable', count: stats['lowRisk'] as int, color: const Color(0xFF7FC29B), active: _riskFilter == 'low', onTap: () => setState(() => _riskFilter = _riskFilter == 'low' ? '' : 'low')),
              ]),
              const SizedBox(height: 16),
              if (filtered.isEmpty)
                const Center(child: Padding(padding: EdgeInsets.all(40), child: Text('No patients match the filter.', style: TextStyle(color: Color(0xFF718096)))))
              else
                ...filtered.map((p) => _PatientCard(patient: p)).toList(),
            ])),
          ),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final bool active;
  final VoidCallback onTap;
  const _SummaryChip({required this.label, required this.count, required this.color, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? color.withOpacity(.15) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: active ? color : const Color(0xFFE2E8F0), width: active ? 1.5 : 1),
          ),
          child: Column(children: [
            Text('$count', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color)),
            Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF718096)), textAlign: TextAlign.center),
          ]),
        ),
      ),
    );
  }
}

class _PatientCard extends StatelessWidget {
  final Patient patient;
  const _PatientCard({required this.patient});

  Color get _riskColor => patient.risk == 'high' ? const Color(0xFFE89E98) : patient.risk == 'medium' ? const Color(0xFFF4C96F) : const Color(0xFF7FC29B);
  Color get _riskBg => patient.risk == 'high' ? const Color(0xFFfdeaea) : patient.risk == 'medium' ? const Color(0xFFFDF5E0) : const Color(0xFFE8F5EE);
  String get _riskLabel => patient.risk == 'high' ? '🔴 HIGH RISK' : patient.risk == 'medium' ? '🟡 AT RISK' : '🟢 STABLE';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ConsultantPatientDetailScreen(patient: patient))),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border(left: BorderSide(color: _riskColor, width: 4)),
          boxShadow: [BoxShadow(color: const Color(0xFF6B9BD1).withOpacity(.08), blurRadius: 12)],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header row
          Row(children: [
            CircleAvatar(radius: 22, backgroundColor: const Color(0xFF6B9BD1),
                child: Text(patient.name.substring(0, 2).toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(patient.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
              Text('${patient.age}, ${patient.gender} · ${patient.profession}', style: const TextStyle(fontSize: 11, color: Color(0xFF718096))),
              Text('${patient.location} · Patient ${patient.id}', style: const TextStyle(fontSize: 11, color: Color(0xFF718096))),
            ])),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: _riskBg, borderRadius: BorderRadius.circular(20)),
              child: Text(_riskLabel, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: _riskColor)),
            ),
          ]),
          const SizedBox(height: 14),

          // Score row
          Row(children: [
            _ScoreBox(label: 'PHQ-9', value: patient.avgDepression, maxVal: 27),
            const SizedBox(width: 8),
            _ScoreBox(label: 'GAD-7', value: patient.avgAnxiety, maxVal: 21),
            const SizedBox(width: 8),
            _ScoreBox(label: 'Mood', value: patient.avgMood, maxVal: 10, inverse: true),
            const SizedBox(width: 8),
            _ScoreBox(label: 'Sessions', value: patient.sessions.toDouble(), maxVal: 30, isRaw: true),
          ]),
          const SizedBox(height: 12),

          // Actions row
          Row(children: [
            Expanded(child: Text('Last session: ${patient.lastDate}', style: const TextStyle(fontSize: 11, color: Color(0xFF718096)))),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ConsultantPatientDetailScreen(patient: patient))),
              style: TextButton.styleFrom(foregroundColor: const Color(0xFF6B9BD1), padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
              child: const Text('📊 View Dashboard', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          ]),
        ]),
      ),
    );
  }
}

class _ScoreBox extends StatelessWidget {
  final String label;
  final double value;
  final double maxVal;
  final bool inverse;
  final bool isRaw;
  const _ScoreBox({required this.label, required this.value, required this.maxVal, this.inverse = false, this.isRaw = false});

  Color get _color {
    if (isRaw) return const Color(0xFF6B9BD1);
    final pct = value / maxVal;
    if (inverse) return pct >= 0.6 ? const Color(0xFF7FC29B) : pct >= 0.4 ? const Color(0xFFF4C96F) : const Color(0xFFE89E98);
    return pct >= 0.6 ? const Color(0xFFE89E98) : pct >= 0.4 ? const Color(0xFFF4C96F) : const Color(0xFF7FC29B);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(color: const Color(0xFFF5F9FC), borderRadius: BorderRadius.circular(8)),
      child: Column(children: [
        Text(isRaw ? '${value.toInt()}' : value.toStringAsFixed(1),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _color)),
        Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF718096))),
      ]),
    ));
  }
}
