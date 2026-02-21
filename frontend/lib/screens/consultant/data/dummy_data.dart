// Consultant Portal — Dummy Data
// Mirrors mental_health_dummy_data.csv

class Patient {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String profession;
  final String location;
  final double avgDepression;
  final double avgAnxiety;
  final double avgMood;
  final String risk; // 'high', 'medium', 'low'
  final int sessions;
  final int journalEntries;
  final String lastDate;
  final List<TrendPoint> trend;

  const Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.profession,
    required this.location,
    required this.avgDepression,
    required this.avgAnxiety,
    required this.avgMood,
    required this.risk,
    required this.sessions,
    required this.journalEntries,
    required this.lastDate,
    required this.trend,
  });
}

class TrendPoint {
  final String date;
  final double score;
  const TrendPoint(this.date, this.score);
}

class ConsultantDummyData {
  static List<TrendPoint> _trend(List<double> scores) {
    final base = DateTime(2025, 1, 15);
    return List.generate(
      scores.length,
      (i) => TrendPoint(
        '${base.add(Duration(days: i * 3)).month}/${base.add(Duration(days: i * 3)).day}',
        scores[i],
      ),
    );
  }

  static final List<Patient> patients = [
    Patient(
      id: 'USER001', name: 'Kavya Iyer', age: 25, gender: 'F',
      profession: 'Software Engineer', location: 'Bangalore',
      avgDepression: 16.2, avgAnxiety: 12.4, avgMood: 4.8,
      risk: 'high', sessions: 14, journalEntries: 42, lastDate: '2025-02-20',
      trend: _trend([4.2,4.8,4.5,5.1,4.9,5.3,4.7,5.6,5.2,5.8]),
    ),
    Patient(
      id: 'USER002', name: 'Rahul Mehta', age: 32, gender: 'M',
      profession: 'Marketing Manager', location: 'Mumbai',
      avgDepression: 13.1, avgAnxiety: 10.7, avgMood: 5.5,
      risk: 'medium', sessions: 10, journalEntries: 28, lastDate: '2025-02-18',
      trend: _trend([5.0,5.5,5.2,5.8,6.0,5.7,6.2,6.0,6.4,6.5]),
    ),
    Patient(
      id: 'USER003', name: 'Ananya Deshmukh', age: 28, gender: 'F',
      profession: 'Teacher', location: 'Pune',
      avgDepression: 8.4, avgAnxiety: 7.2, avgMood: 6.8,
      risk: 'low', sessions: 8, journalEntries: 19, lastDate: '2025-02-17',
      trend: _trend([6.5,6.8,7.0,6.7,7.2,7.0,7.5,7.3,7.6,7.8]),
    ),
    Patient(
      id: 'USER004', name: 'Arjun Singh', age: 35, gender: 'M',
      profession: 'Business Owner', location: 'Delhi',
      avgDepression: 17.8, avgAnxiety: 14.9, avgMood: 3.9,
      risk: 'high', sessions: 18, journalEntries: 55, lastDate: '2025-02-15',
      trend: _trend([3.5,3.8,4.0,3.7,4.2,3.9,4.5,4.2,4.8,4.6]),
    ),
    Patient(
      id: 'USER005', name: 'Meera Patel', age: 29, gender: 'F',
      profession: 'Doctor', location: 'Ahmedabad',
      avgDepression: 9.2, avgAnxiety: 8.0, avgMood: 6.5,
      risk: 'low', sessions: 6, journalEntries: 15, lastDate: '2025-02-12',
      trend: _trend([6.0,6.3,6.5,6.8,7.0,6.9,7.2,7.1,7.4,7.5]),
    ),
    Patient(
      id: 'USER006', name: 'Rohan Sharma', age: 31, gender: 'M',
      profession: 'Engineer', location: 'Hyderabad',
      avgDepression: 12.6, avgAnxiety: 9.8, avgMood: 5.8,
      risk: 'medium', sessions: 9, journalEntries: 22, lastDate: '2025-02-10',
      trend: _trend([5.2,5.5,5.9,5.7,6.0,5.8,6.3,6.1,6.5,6.6]),
    ),
    Patient(
      id: 'USER007', name: 'Priya Nair', age: 26, gender: 'F',
      profession: 'Designer', location: 'Chennai',
      avgDepression: 7.4, avgAnxiety: 6.1, avgMood: 7.2,
      risk: 'low', sessions: 5, journalEntries: 12, lastDate: '2025-02-08',
      trend: _trend([7.0,7.2,7.5,7.3,7.6,7.8,7.5,7.9,8.0,8.1]),
    ),
    Patient(
      id: 'USER008', name: 'Vikram Joshi', age: 40, gender: 'M',
      profession: 'Manager', location: 'Kolkata',
      avgDepression: 15.3, avgAnxiety: 13.2, avgMood: 4.5,
      risk: 'high', sessions: 20, journalEntries: 61, lastDate: '2025-02-05',
      trend: _trend([4.0,4.3,4.5,4.2,4.8,4.6,5.0,4.8,5.2,5.4]),
    ),
    Patient(
      id: 'USER009', name: 'Sneha Iyer', age: 33, gender: 'F',
      profession: 'Analyst', location: 'Jaipur',
      avgDepression: 11.0, avgAnxiety: 9.5, avgMood: 5.9,
      risk: 'medium', sessions: 11, journalEntries: 31, lastDate: '2025-02-02',
      trend: _trend([5.5,5.8,6.0,5.9,6.2,6.0,6.4,6.3,6.6,6.8]),
    ),
    Patient(
      id: 'USER010', name: 'Aditya Kumar', age: 27, gender: 'M',
      profession: 'Developer', location: 'Bangalore',
      avgDepression: 6.8, avgAnxiety: 5.4, avgMood: 7.5,
      risk: 'low', sessions: 4, journalEntries: 10, lastDate: '2025-01-30',
      trend: _trend([7.2,7.5,7.8,7.6,8.0,7.8,8.2,8.0,8.3,8.5]),
    ),
  ];

  static Map<String, dynamic> get dashboardStats {
    int total = patients.length;
    double avgDepression = patients.map((p) => p.avgDepression).reduce((a, b) => a + b) / total;
    double avgMood = patients.map((p) => p.avgMood).reduce((a, b) => a + b) / total;
    int totalSessions = patients.map((p) => p.sessions).reduce((a, b) => a + b);
    int totalJournals = patients.map((p) => p.journalEntries).reduce((a, b) => a + b);
    int highRisk = patients.where((p) => p.risk == 'high').length;
    int medRisk  = patients.where((p) => p.risk == 'medium').length;
    int lowRisk  = patients.where((p) => p.risk == 'low').length;

    return {
      'totalPatients': total,
      'avgDepression': double.parse(avgDepression.toStringAsFixed(1)),
      'avgMood': double.parse(avgMood.toStringAsFixed(1)),
      'totalSessions': totalSessions,
      'totalJournals': totalJournals,
      'highRisk': highRisk,
      'medRisk': medRisk,
      'lowRisk': lowRisk,
    };
  }
}
