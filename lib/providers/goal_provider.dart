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
  List<dynamic> transations = [];
  Map<String, dynamic> object = {};

  GoalProvider() {
    initData();
  }

  Future<bool> saveGoal({String name, int goalSum}) async {
    if (name.isNotEmpty && !goalSum.isNaN) {
      object = {
        "name": name,
        "goalSum": goalSum,
        "haveSum": haveSum ?? 0,
        "needSum": needSum ?? goalSum,
      };
      return await LocalGoalService.setGoal(json.encode(object));
    } else
      return false;
  }

  initData() async {
    String objStr = await LocalGoalService.getGoal();
    object = json.decode(objStr);
    this.name = object['name'];
    this.haveSum = object['haveSum'];
    this.needSum = object['needSum'];

    List<String> transations =
        await LocalTransactionService.getTransactions() ?? [];
    this.transations = transations.map((el) => json.decode(el)).toList();
    notifyListeners();
  }

  addTransaction(Map<String, dynamic> transaction) async {
    try {
      if (transaction['type'] == '+') {
        this.haveSum += int.parse(transaction['sum']);
        this.needSum -= int.parse(transaction['sum']);
      } else {
        this.haveSum -= int.parse(transaction['sum']);
        this.needSum += int.parse(transaction['sum']);
      }

      object['haveSum'] = this.haveSum;
      object['needSum'] = this.needSum;
      this.transations.insert(0, transaction);
      LocalGoalService.setGoal(json.encode(object));
    } catch (ex) {
      // TODO поставить снейк сообщение
      print(ex.message);
    }
    notifyListeners();
  }

  deleteTransaction(Map<String, dynamic> transaction) async {
    // this.transations.add(transaction);
    // this.haveSum += int.parse(transaction['sum']);
    // this.needSum -= int.parse(transaction['sum']);

    // object['haveSum'] = this.haveSum;
    // object['needSum'] = this.needSum;
    // await LocalGoalService.setGoal(json.encode(object));
    notifyListeners();
  }
}
