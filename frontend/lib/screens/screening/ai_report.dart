// ai_report.dart
// Model for the AI-generated clinical report returned by /api/screening/report

class AiReport {
  final String scoreSummary;
  final List<String> keyFindings;
  final List<String> elevatedAreas;
  final List<String> patternFlags;
  final String nextSteps;
  final String disclaimer;

  const AiReport({
    required this.scoreSummary,
    required this.keyFindings,
    required this.elevatedAreas,
    required this.patternFlags,
    required this.nextSteps,
    required this.disclaimer,
  });

  factory AiReport.fromJson(Map<String, dynamic> json) {
    List<String> strList(dynamic v) =>
        v is List ? v.map((e) => e.toString()).toList() : [];

    return AiReport(
      scoreSummary: json['score_summary'] ?? '',
      keyFindings: strList(json['key_findings']),
      elevatedAreas: strList(json['elevated_areas']),
      patternFlags: strList(json['pattern_flags']),
      nextSteps: json['next_steps'] ?? '',
      disclaimer: json['disclaimer'] ?? '',
    );
  }
}
