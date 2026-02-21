import 'package:flutter/material.dart';

/// 5-step consultant registration form.
/// [onSubmitted] — called after the final submit. If provided (from auth flow)
/// it navigates to the portal. If null, shows a snackbar (standalone mode).
class ConsultantRegisterScreen extends StatefulWidget {
  final VoidCallback? onSubmitted;
  const ConsultantRegisterScreen({super.key, this.onSubmitted});

  @override
  State<ConsultantRegisterScreen> createState() => _ConsultantRegisterScreenState();
}

class _ConsultantRegisterScreenState extends State<ConsultantRegisterScreen> {
  int _step = 0;
  final PageController _pageCtrl = PageController();

  // Form state
  final _nameCtrl   = TextEditingController();
  final _emailCtrl  = TextEditingController();
  final _phoneCtrl  = TextEditingController();
  final _pwCtrl     = TextEditingController();
  String _city      = '';
  String _degree    = '';
  String _council   = '';
  String _regNum    = TextEditingController().text;
  int _yearsExp     = 0;
  final Set<String> _specializations = {};
  final Set<String> _languages = {};
  final _bioCtrl    = TextEditingController();
  String _licenseType = '';
  final _licNumCtrl = TextEditingController();
  bool _doc1 = false, _doc2 = false, _doc3 = false;
  final List<bool> _tnc = [false, false, false, false];

  void _next() {
    if (_step < 4) {
      setState(() => _step++);
      _pageCtrl.nextPage(duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
    }
  }

  void _back() {
    if (_step > 0) {
      setState(() => _step--);
      _pageCtrl.previousPage(duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF4FB),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
              child: Column(
                children: [
                  // Header
                  const SizedBox(height: 8),
                  Image.asset('assets/images/Consultant.png', width: 56, height: 56),
                  const SizedBox(height: 8),
                  const Text(
                    'Join MindfulCare as a Consultant',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF2D3748)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  const Text('Help people on their mental wellness journey',
                      style: TextStyle(color: Color(0xFF718096), fontSize: 13)),
                  const SizedBox(height: 24),
                  // Step indicator
                  _StepIndicator(current: _step, total: 5),
                  const SizedBox(height: 24),
                  // Pages
                  SizedBox(
                    height: 520,
                    child: PageView(
                      controller: _pageCtrl,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _Step1(nameCtrl: _nameCtrl, emailCtrl: _emailCtrl, phoneCtrl: _phoneCtrl,
                            pwCtrl: _pwCtrl, city: _city, onCityChanged: (v) => setState(() => _city = v),
                            onNext: _next),
                        _Step2(degree: _degree, council: _council, yearsExp: _yearsExp,
                            specializations: _specializations, languages: _languages, bioCtrl: _bioCtrl,
                            onDegreeChanged: (v) => setState(() => _degree = v),
                            onCouncilChanged: (v) => setState(() => _council = v),
                            onYearsChanged: (v) => setState(() => _yearsExp = v),
                            onSpecToggle: (v) => setState(() => _specializations.contains(v) ? _specializations.remove(v) : _specializations.add(v)),
                            onLangToggle: (v) => setState(() => _languages.contains(v) ? _languages.remove(v) : _languages.add(v)),
                            onBack: _back, onNext: _next),
                        _Step3(licenseType: _licenseType, licNumCtrl: _licNumCtrl,
                            onTypeChanged: (v) => setState(() => _licenseType = v),
                            onBack: _back, onNext: _next),
                        _Step4(doc1: _doc1, doc2: _doc2, doc3: _doc3,
                            onDoc1: () => setState(() => _doc1 = !_doc1),
                            onDoc2: () => setState(() => _doc2 = !_doc2),
                            onDoc3: () => setState(() => _doc3 = !_doc3),
                            onBack: _back, onNext: _next),
                        _Step5(tnc: _tnc,
                            onTncChanged: (i, v) => setState(() => _tnc[i] = v),
                            onBack: _back,
                            onSubmit: () {
                    if (widget.onSubmitted != null) {
                      widget.onSubmitted!();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Application submitted! We\'ll review within 2–3 business days.')),
                      );
                    }
                  }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Step Indicator ──────────────────────────────────────────────────────────
class _StepIndicator extends StatelessWidget {
  final int current;
  final int total;
  const _StepIndicator({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < total; i++) ...[
          _Dot(index: i, current: current),
          if (i < total - 1) Expanded(
            child: Container(height: 2,
              color: i < current ? const Color(0xFF7FC29B) : const Color(0xFFE2E8F0)),
          ),
        ],
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  final int index, current;
  const _Dot({required this.index, required this.current});

  @override
  Widget build(BuildContext context) {
    final done   = index < current;
    final active = index == current;
    final bg = done ? const Color(0xFF7FC29B) : active ? const Color(0xFF6B9BD1) : Colors.white;
    final border = done ? const Color(0xFF7FC29B) : active ? const Color(0xFF6B9BD1) : const Color(0xFFE2E8F0);
    return Container(
      width: 30, height: 30,
      decoration: BoxDecoration(shape: BoxShape.circle, color: bg, border: Border.all(color: border, width: 2)),
      child: Center(
        child: done
            ? const Icon(Icons.check, size: 16, color: Colors.white)
            : Text('${index + 1}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                color: active ? Colors.white : const Color(0xFF718096))),
      ),
    );
  }
}

// ── Shared card wrapper ─────────────────────────────────────────────────────
class _RegCard extends StatelessWidget {
  final Widget child;
  const _RegCard({required this.child});

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: const Color(0xFF6B9BD1).withOpacity(.12), blurRadius: 24, offset: const Offset(0, 4))]),
    padding: const EdgeInsets.all(24),
    child: child,
  );
}

// ── Input helpers ───────────────────────────────────────────────────────────
class _LabeledField extends StatelessWidget {
  final String label;
  final Widget child;
  const _LabeledField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF2D3748))),
      const SizedBox(height: 6),
      child,
      const SizedBox(height: 14),
    ],
  );
}

InputDecoration _inputDec(String hint, {Widget? prefix}) => InputDecoration(
  hintText: hint,
  prefixIcon: prefix,
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF6B9BD1), width: 2)),
  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
);

Widget _dropField(String hint, List<String> items, String value, ValueChanged<String> onChanged) =>
  DropdownButtonFormField<String>(
    value: value.isEmpty ? null : value,
    hint: Text(hint, style: const TextStyle(color: Color(0xFF718096), fontSize: 14)),
    decoration: _inputDec(''),
    items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13)))).toList(),
    onChanged: (v) { if (v != null) onChanged(v); },
  );

Widget _chipGroup(List<String> options, Set<String> selected, ValueChanged<String> onToggle) =>
  Wrap(spacing: 8, runSpacing: 8, children: options.map((o) {
    final on = selected.contains(o);
    return GestureDetector(
      onTap: () => onToggle(o),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: on ? const Color(0xFFE8F2FD) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: on ? const Color(0xFF6B9BD1) : const Color(0xFFE2E8F0)),
        ),
        child: Text(o, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500,
            color: on ? const Color(0xFF4a7ab5) : const Color(0xFF2D3748))),
      ),
    );
  }).toList());

Widget _navRow({required VoidCallback onBack, required VoidCallback onNext, String nextLabel = 'Continue →'}) =>
  Row(children: [
    OutlinedButton(onPressed: onBack,
        style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFFE2E8F0))),
        child: const Text('← Back', style: TextStyle(color: Color(0xFF718096)))),
    const SizedBox(width: 12),
    Expanded(child: ElevatedButton(
      onPressed: onNext,
      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6B9BD1), foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(vertical: 14)),
      child: Text(nextLabel),
    )),
  ]);

// ── STEP 1 ─────────────────────────────────────────────────────────────────
class _Step1 extends StatelessWidget {
  final TextEditingController nameCtrl, emailCtrl, phoneCtrl, pwCtrl;
  final String city;
  final ValueChanged<String> onCityChanged;
  final VoidCallback onNext;

  const _Step1({required this.nameCtrl, required this.emailCtrl, required this.phoneCtrl,
      required this.pwCtrl, required this.city, required this.onCityChanged, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: _RegCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Basic Information', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
      const Text('Step 1 of 5 — Tell us who you are', style: TextStyle(fontSize: 12, color: Color(0xFF718096))),
      const SizedBox(height: 18),
      _LabeledField(label: 'Full Name *', child: TextField(controller: nameCtrl, decoration: _inputDec('Dr. Priya Sharma', prefix: const Icon(Icons.person_outline, size: 18)))),
      _LabeledField(label: 'Email *', child: TextField(controller: emailCtrl, keyboardType: TextInputType.emailAddress, decoration: _inputDec('email@example.com', prefix: const Icon(Icons.email_outlined, size: 18)))),
      _LabeledField(label: 'Phone *', child: TextField(controller: phoneCtrl, keyboardType: TextInputType.phone, decoration: _inputDec('+91 98765 43210', prefix: const Icon(Icons.phone_outlined, size: 18)))),
      _LabeledField(label: 'Password *', child: TextField(controller: pwCtrl, obscureText: true, decoration: _inputDec('Min 8 characters', prefix: const Icon(Icons.lock_outline, size: 18)))),
      _LabeledField(label: 'City *', child: _dropField('Select city…',
          ['Mumbai','Delhi','Bangalore','Pune','Hyderabad','Chennai','Kolkata','Ahmedabad','Jaipur','Other'],
          city, onCityChanged)),
      const SizedBox(height: 4),
      SizedBox(width: double.infinity, child: ElevatedButton(
        onPressed: onNext,
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6B9BD1), foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(vertical: 14)),
        child: const Text('Continue →'),
      )),
    ])));
  }
}

// ── STEP 2 ─────────────────────────────────────────────────────────────────
class _Step2 extends StatelessWidget {
  final String degree, council;
  final int yearsExp;
  final Set<String> specializations, languages;
  final TextEditingController bioCtrl;
  final ValueChanged<String> onDegreeChanged, onCouncilChanged;
  final ValueChanged<int> onYearsChanged;
  final ValueChanged<String> onSpecToggle, onLangToggle;
  final VoidCallback onBack, onNext;

  const _Step2({
    required this.degree, required this.council, required this.yearsExp,
    required this.specializations, required this.languages, required this.bioCtrl,
    required this.onDegreeChanged, required this.onCouncilChanged,
    required this.onYearsChanged, required this.onSpecToggle, required this.onLangToggle,
    required this.onBack, required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: _RegCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Professional Credentials', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
      const Text('Step 2 of 5 — Your qualifications', style: TextStyle(fontSize: 12, color: Color(0xFF718096))),
      const SizedBox(height: 18),
      _LabeledField(label: 'Degree *', child: _dropField('Select degree…',
          ['MBBS, MD (Psychiatry)','PhD (Clinical Psychology)','M.Phil (Clinical Psychology)','MA Psychology','MSW','RCI Licensed'],
          degree, onDegreeChanged)),
      _LabeledField(label: 'Council *', child: _dropField('Select council…',
          ['Medical Council of India (MCI/NMC)','Rehabilitation Council of India (RCI)','IACP','Not Registered'],
          council, onCouncilChanged)),
      _LabeledField(label: 'Years of Experience *', child: _dropField('Select range…',
          ['0–2 years','2–5 years','5–10 years','10–15 years','15–20 years','20+ years'],
          yearsExp == 0 ? '' : '${yearsExp} yrs', (v) { /* just use string */ })),
      _LabeledField(label: 'Specialization * (select all that apply)',
          child: _chipGroup(['Anxiety','Depression','Trauma','Relationship Issues','Family Therapy','Child Psychology','Addiction','PTSD','Workplace Stress','OCD'],
              specializations, onSpecToggle)),
      _LabeledField(label: 'Languages Spoken *',
          child: _chipGroup(['Hindi','English','Marathi','Tamil','Telugu','Bengali','Gujarati','Kannada','Malayalam','Punjabi'],
              languages, onLangToggle)),
      _LabeledField(label: 'Bio (optional)', child: TextField(controller: bioCtrl, maxLines: 3, maxLength: 500,
          decoration: _inputDec('Tell patients about your approach…'))),
      _navRow(onBack: onBack, onNext: onNext),
    ])));
  }
}

// ── STEP 3 ─────────────────────────────────────────────────────────────────
class _Step3 extends StatelessWidget {
  final String licenseType;
  final TextEditingController licNumCtrl;
  final ValueChanged<String> onTypeChanged;
  final VoidCallback onBack, onNext;

  const _Step3({required this.licenseType, required this.licNumCtrl, required this.onTypeChanged, required this.onBack, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: _RegCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Verify Your License', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
      const Text('Step 3 of 5 — Patient safety requires verification', style: TextStyle(fontSize: 12, color: Color(0xFF718096))),
      const SizedBox(height: 14),
      Container(
        padding: const EdgeInsets.all(12), margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(color: const Color(0xFFFDF5E0), borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFF4C96F))),
        child: const Row(children: [
          Icon(Icons.warning_amber_rounded, color: Color(0xFFD68910), size: 18),
          SizedBox(width: 8),
          Expanded(child: Text('Documents are encrypted and verified with respective councils within 2–3 business days.',
              style: TextStyle(fontSize: 12, color: Color(0xFF2D3748)))),
        ]),
      ),
      _LabeledField(label: 'Registration Type *', child: _dropField('Select type…',
          ['MCI/NMC Registration (Psychiatrists)','RCI Registration (Psychologists)','State Council Registration','International License'],
          licenseType, onTypeChanged)),
      _LabeledField(label: 'License Number *', child: TextField(controller: licNumCtrl, decoration: _inputDec('REG/2020/PSYCH/12345', prefix: const Icon(Icons.badge_outlined, size: 18)))),
      _LabeledField(label: 'Issuing State *', child: _dropField('Select state…',
          ['Maharashtra','Delhi','Karnataka','Tamil Nadu','Telangana','West Bengal','Gujarat','Rajasthan','Other'],
          '', (_) {})),
      const SizedBox(height: 8),
      Center(child: Column(children: [
        const Icon(Icons.shield_outlined, size: 36, color: Color(0xFF6B9BD1)),
        const SizedBox(height: 4),
        const Text('All verification data is AES-256 encrypted',
            style: TextStyle(fontSize: 11, color: Color(0xFF718096))),
      ])),
      const SizedBox(height: 16),
      _navRow(onBack: onBack, onNext: onNext),
    ])));
  }
}

// ── STEP 4 ─────────────────────────────────────────────────────────────────
class _Step4 extends StatelessWidget {
  final bool doc1, doc2, doc3;
  final VoidCallback onDoc1, onDoc2, onDoc3, onBack, onNext;

  const _Step4({required this.doc1, required this.doc2, required this.doc3,
      required this.onDoc1, required this.onDoc2, required this.onDoc3,
      required this.onBack, required this.onNext});

  Widget _uploadTile(IconData icon, String title, String sub, bool uploaded, VoidCallback onTap) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: uploaded ? const Color(0xFFE8F5EE) : const Color(0xFFF5F9FC),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: uploaded ? const Color(0xFF7FC29B) : const Color(0xFFE2E8F0),
                width: uploaded ? 1.5 : 1),
          ),
          child: Row(children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: uploaded ? const Color(0xFF7FC29B) : const Color(0xFFE8F2FD),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 20, color: uploaded ? Colors.white : const Color(0xFF6B9BD1)),
            ),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              Text(sub, style: const TextStyle(fontSize: 11, color: Color(0xFF718096))),
            ])),
            if (uploaded)
              const Icon(Icons.check_circle, color: Color(0xFF7FC29B))
            else
              OutlinedButton.icon(
                onPressed: onTap,
                icon: const Icon(Icons.upload, size: 14),
                label: const Text('Upload', style: TextStyle(fontSize: 12)),
                style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF6B9BD1),
                    side: const BorderSide(color: Color(0xFF6B9BD1)),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
              ),
          ]),
        ),
      );


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: _RegCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Upload Documents', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
      const Text('Step 4 of 5 — Required verification documents', style: TextStyle(fontSize: 12, color: Color(0xFF718096))),
      const SizedBox(height: 18),
      _uploadTile(Icons.description_outlined, 'Professional License / Certificate', 'MCI/RCI/Council registration', doc1, onDoc1),
      _uploadTile(Icons.school_outlined,      'Degree Certificate',                  'Highest medical/psychology degree', doc2, onDoc2),
      _uploadTile(Icons.badge_outlined,        'Government ID',                       'Aadhaar / PAN / Passport', doc3, onDoc3),
      Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFFE8F2FD), borderRadius: BorderRadius.circular(8)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
          Row(children: [
            Icon(Icons.lock_outline, size: 14, color: Color(0xFF6B9BD1)),
            SizedBox(width: 6),
            Text('Your documents are:', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
          ]),
          SizedBox(height: 6),
          Text('✓ AES-256 encrypted', style: TextStyle(fontSize: 12)),
          Text('✓ Viewed only by verification team', style: TextStyle(fontSize: 12)),
          Text('✓ Deleted after verification', style: TextStyle(fontSize: 12)),
          Text('✓ Never shared with third parties', style: TextStyle(fontSize: 12)),
        ]),
      ),
      _navRow(onBack: onBack, onNext: onNext),
    ])));
  }
}

// ── STEP 5 ─────────────────────────────────────────────────────────────────
class _Step5 extends StatelessWidget {
  final List<bool> tnc;
  final Function(int, bool) onTncChanged;
  final VoidCallback onBack, onSubmit;

  const _Step5({required this.tnc, required this.onTncChanged, required this.onBack, required this.onSubmit});

  static const _tncLabels = [
    "I agree to MindfulCare's Terms of Service",
    "I agree to maintain patient confidentiality (HIPAA-equivalent)",
    "I confirm all information provided is accurate",
    "I agree to video consultation guidelines",
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: _RegCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Review & Submit', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
      const Text('Step 5 of 5 — Final step', style: TextStyle(fontSize: 12, color: Color(0xFF718096))),
      const SizedBox(height: 16),
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: const Color(0xFFF5F9FC), borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE2E8F0))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: const [
            Icon(Icons.info_outline, size: 16, color: Color(0xFF6B9BD1)),
            SizedBox(width: 6),
            Text('What happens next?', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          ]),
          const SizedBox(height: 8),
          for (final s in const [
            '1. Our team reviews your application (2–3 business days)',
            '2. We verify credentials with respective councils',
            '3. You\'ll receive email notification of approval/rejection',
            '4. Once approved, you can set up your profile & schedule',
          ])
            Padding(padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(s, style: const TextStyle(fontSize: 12, color: Color(0xFF2D3748)))),
        ]),
      ),
      const SizedBox(height: 16),
      for (int i = 0; i < _tncLabels.length; i++)
        CheckboxListTile(
          value: tnc[i],
          onChanged: (v) => onTncChanged(i, v ?? false),
          title: Text(_tncLabels[i], style: const TextStyle(fontSize: 12)),
          controlAffinity: ListTileControlAffinity.leading,
          dense: true,
          activeColor: const Color(0xFF6B9BD1),
        ),
      const SizedBox(height: 12),
      _navRow(onBack: onBack, onNext: onSubmit, nextLabel: 'Submit Application'),
    ])));
  }
}
