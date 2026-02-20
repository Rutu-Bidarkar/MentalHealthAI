import 'package:usage_stats/usage_stats.dart';

class ScreenTimeService {
  static Future<bool> requestPermission() async {
    bool? granted = await UsageStats.checkUsagePermission();

    if (granted != true) {
      await UsageStats.grantUsagePermission();
      granted = await UsageStats.checkUsagePermission();
    }

    return granted ?? false;
  }

  static Future<List<UsageInfo>> getTodayUsage() async {
    DateTime end = DateTime.now();
    DateTime start = DateTime(end.year, end.month, end.day);
    return await UsageStats.queryUsageStats(start, end);
  }
}
