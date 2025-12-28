import 'package:shared_preferences/shared_preferences.dart';

/// 사용자 데이터를 관리하는 싱글톤 클래스
class UserDataManager {
  static final UserDataManager _instance = UserDataManager._internal();
  factory UserDataManager() => _instance;
  UserDataManager._internal();

  static const String _keyPoints = 'user_points';
  static const String _keyName = 'user_name';
  static const String _keyLevel = 'user_level';

  // 포인트 저장
  Future<void> savePoints(int points) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyPoints, points);
  }

  // 포인트 불러오기
  Future<int> getPoints() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyPoints) ?? 5200; // 기본값 5200
  }

  // 이름 저장
  Future<void> saveName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyName, name);
  }

  // 이름 불러오기
  Future<String> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyName) ?? '류수연';
  }

  // 레벨 저장
  Future<void> saveLevel(int level) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyLevel, level);
  }

  // 레벨 불러오기
  Future<int> getLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyLevel) ?? 14;
  }

  // 포인트 증가/감소
  Future<int> updatePoints(int delta) async {
    final currentPoints = await getPoints();
    final newPoints = currentPoints + delta;
    await savePoints(newPoints);
    return newPoints;
  }
}