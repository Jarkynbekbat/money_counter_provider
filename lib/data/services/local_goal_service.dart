import 'package:shared_preferences/shared_preferences.dart';

class LocalGoalService {
  static Future<bool> setGoal(goal) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('goal', goal);
  }

  static Future<String> getGoal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var goal = prefs.getString('goal');
    return goal;
  }

  static Future<bool> deleteGoal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove('goal');
  }
}
