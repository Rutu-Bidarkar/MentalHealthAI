import 'package:flutter/material.dart';


class ConsultantBillingScreen extends StatelessWidget {
  const ConsultantBillingScreen({super.key});

  static final _transactions = [
    _Tx('Feb 20', 'Rahul Mehta', 'Follow-up Session', 1200, 'paid'),
    _Tx('Feb 20', 'Kavya Iyer', 'Initial Consultation', 1500, 'paid'),
    _Tx('Feb 19', 'Ananya Deshmukh', 'Follow-up Session', 1200, 'paid'),
    _Tx('Feb 18', 'Arjun Singh', 'Urgent Session', 2000, 'pending'),
    _Tx('Feb 17', 'Meera Patel', 'Follow-up Session', 1200, 'paid'),
    _Tx('Feb 16', 'Rohan Sharma', 'Group Session', 800, 'paid'),
    _Tx('Feb 15', 'Vikram Joshi', 'Initial Consultation', 1500, 'pending'),
    _Tx('Feb 14', 'Sneha Iyer', 'Follow-up Session', 1200, 'paid'),
  ];

  double get _totalRevenue => _transactions.where((t) => t.status == 'paid').fold(0, (a, t) => a + t.amount);
  double get _pending => _transactions.where((t) => t.status == 'pending').fold(0, (a, t) => a + t.amount);
  double get _withdrawn => 14800;
  double get _available => _totalRevenue - _withdrawn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FC),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0.5,
            title: const Text('Billing & Revenue', style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF2D3748))),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(delegate: SliverChildListDelegate([

              // ── Summary cards (4×1 horizontal strip) ──────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _BillCard('💰', 'Revenue',   '₹${_totalRevenue.toStringAsFixed(0)}', '+8.3%',  const Color(0xFFE8F5EE), const Color(0xFF7FC29B))),
                  const SizedBox(width: 8),
                  Expanded(child: _BillCard('⏳', 'Pending',   '₹${_pending.toStringAsFixed(0)}',      '${_transactions.where((t) => t.status == 'pending').length} sess.', const Color(0xFFFDF5E0), const Color(0xFFF4C96F))),
                  const SizedBox(width: 8),
                  Expanded(child: _BillCard('🏦', 'Available', '₹${_available.toStringAsFixed(0)}',    'Payout', const Color(0xFFE8F2FD), const Color(0xFF6B9BD1))),
                  const SizedBox(width: 8),
                  Expanded(child: _BillCard('📤', 'Withdrawn', '₹${_withdrawn.toStringAsFixed(0)}',    'Month',  const Color(0xFFF5F9FC), const Color(0xFF718096))),
                ],
              ),


              const SizedBox(height: 18),

              // ── Revenue breakdown ─────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: const Color(0xFF6B9BD1).withOpacity(.08), blurRadius: 12)]),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('📊 Revenue Breakdown', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 14),
                  for (final item in const [
                    ('Initial Consultations', 0.40, Color(0xFF6B9BD1)),
                    ('Follow-up Sessions', 0.45, Color(0xFF7FC29B)),
                    ('Group Sessions', 0.08, Color(0xFFF4C96F)),
                    ('Urgent Sessions', 0.07, Color(0xFFE89E98)),
                  ]) ...[
                    Row(children: [
                      Container(width: 10, height: 10, decoration: BoxDecoration(color: item.$3, shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      Expanded(child: Text(item.$1, style: const TextStyle(fontSize: 12))),
                      Text('${(item.$2 * 100).toInt()}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                    ]),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(value: item.$2, minHeight: 6,
                          backgroundColor: const Color(0xFFE2E8F0), valueColor: AlwaysStoppedAnimation(item.$3)),
                    ),
                    const SizedBox(height: 10),
                  ],
                ]),
              ),
              const SizedBox(height: 16),

              // ── Payout settings ───────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: const Color(0xFF6B9BD1).withOpacity(.08), blurRadius: 12)]),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    const Expanded(child: Text('🏦 Payout Settings', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFE8F5EE), borderRadius: BorderRadius.circular(6)),
                      child: const Text('✓ Verified', style: TextStyle(fontSize: 11, color: Color(0xFF7FC29B), fontWeight: FontWeight.w700)),
                    ),
                  ]),
                  const SizedBox(height: 14),
                  _InfoRow('Bank', 'HDFC Bank · ****4521'),
                  _InfoRow('IFSC', 'HDFC0001234'),
                  _InfoRow('UPI', 'priya.sharma@upi'),
                  _InfoRow('Payout', 'Bi-weekly (1st & 15th)'),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFF6B9BD1),
                          side: const BorderSide(color: Color(0xFF6B9BD1))),
                      child: const Text('Edit Bank Details', style: TextStyle(fontSize: 12)),
                    )),
                    const SizedBox(width: 12),
                    Expanded(child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7FC29B), foregroundColor: Colors.white),
                      child: const Text('Request Payout', style: TextStyle(fontSize: 12)),
                    )),
                  ]),
                ]),
              ),
              const SizedBox(height: 16),

              // ── Transaction history ────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: const Color(0xFF6B9BD1).withOpacity(.08), blurRadius: 12)]),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    const Expanded(child: Text('💳 Transaction History', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800))),
                    TextButton(onPressed: () {}, child: const Text('Download CSV', style: TextStyle(fontSize: 11))),
                  ]),
                  const SizedBox(height: 10),
                  for (final t in _transactions) _TxRow(tx: t),
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

class _Tx {
  final String date, patient, type, status;
  final double amount;
  const _Tx(this.date, this.patient, this.type, this.amount, this.status);
}

class _BillCard extends StatelessWidget {
  final String icon, label, value, sub;
  final Color bg, accent;
  const _BillCard(this.icon, this.label, this.value, this.sub, this.bg, this.accent);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withAlpha(60))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
      Text(icon, style: const TextStyle(fontSize: 16)),
      const SizedBox(height: 4),
      Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: accent),
          overflow: TextOverflow.ellipsis),
      Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF718096))),
      Text(sub,   style: const TextStyle(fontSize: 9,  color: Color(0xFF718096))),
    ]),
  );
}


class _InfoRow extends StatelessWidget {
  final String label, value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(children: [
      SizedBox(width: 64, child: Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF718096)))),
      Expanded(child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
    ]),
  );
}

class _TxRow extends StatelessWidget {
  final _Tx tx;
  const _TxRow({required this.tx});

  @override
  Widget build(BuildContext context) {
    final paid = tx.status == 'paid';
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFFF5F9FC), borderRadius: BorderRadius.circular(8)),
      child: Row(children: [
        Container(width: 38, height: 38,
            decoration: BoxDecoration(color: paid ? const Color(0xFFE8F5EE) : const Color(0xFFFDF5E0), borderRadius: BorderRadius.circular(8)),
            child: Center(child: Text(paid ? '✅' : '⏳', style: const TextStyle(fontSize: 16)))),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(tx.patient, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          Text('${tx.date} · ${tx.type}', style: const TextStyle(fontSize: 11, color: Color(0xFF718096))),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('₹${tx.amount.toStringAsFixed(0)}', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14,
              color: paid ? const Color(0xFF7FC29B) : const Color(0xFFF4C96F))),
          Text(tx.status.toUpperCase(), style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700,
              color: paid ? const Color(0xFF7FC29B) : const Color(0xFFF4C96F))),
        ]),
      ]),
    );
  }
}
