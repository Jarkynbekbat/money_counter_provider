import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:safe_money/services/local_goal_service.dart';
import 'package:safe_money/services/local_transaction_service.dart';

class GoalProvider extends ChangeNotifier {
  DateTime date;
  String name;
  int goalSum;
  int haveSum;
  int needSum;
  List<Map<String, dynamic>> transations = [];

  GoalProvider() {
    initData();
  }

  Future<bool> saveGoal({String name, int goalSum}) async {
    if (name.isNotEmpty && !goalSum.isNaN) {
      Map<String, dynamic> goal = {
        "name": name,
        "goalSum": goalSum,
        "haveSum": haveSum ?? 0,
        "needSum": needSum ?? goalSum,
      };
      return await LocalGoalService.setGoal(json.encode(goal));
    } else
      return false;
  }

  Future<bool> initData() async {
    var temp = await LocalTransactionService.getTransactions();

    // this.transations = temp.map((el) => json.decode(el));
    notifyListeners();
  }
}
