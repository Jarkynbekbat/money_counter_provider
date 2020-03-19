import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safe_money/services/local_goal_service.dart';
import 'package:safe_money/services/local_transaction_service.dart';

class GoalProvider extends ChangeNotifier {
  String name;

  int goalSum;
  int haveSum;
  int needSum;
  double precent = 0;
  List<dynamic> transations = [];
  Map<String, dynamic> object = {};

  GoalProvider() {
    initData();
  }

  initData() async {
    String objStr = await LocalGoalService.getGoal();
    if (objStr != null) {
      object = json.decode(objStr);
      this.name = object['name'];
      this.goalSum = object['goalSum'];
      this.haveSum = object['haveSum'];
      this.needSum = object['needSum'];
      this.precent = (this.haveSum / this.goalSum * 100) * 100;
      List<String> transations =
          await LocalTransactionService.getTransactions() ?? [];
      this.transations = transations.map((el) => json.decode(el)).toList();
    }
    notifyListeners();
  }

  Future<bool> saveGoal({String name, int goalSum}) async {
    if (name.isNotEmpty && !goalSum.isNaN) {
      object = {
        "goalDatetime": DateTime.now().toString(),
        "name": name,
        "goalSum": goalSum,
        "haveSum": 0,
        "needSum": goalSum,
      };
      bool result = await LocalGoalService.setGoal(json.encode(object));
      return result;
    } else
      return false;
  }

  addTransaction(Map<String, dynamic> transaction, scaffoldKey) async {
    try {
      if (transaction['type'] == '+') {
        this.haveSum += int.parse(transaction['sum']);
        this.needSum -= int.parse(transaction['sum']);

        if (this.haveSum >= this.goalSum) {
          this.needSum = 0;
          final snackBar = SnackBar(content: Text('ЦЕЛЬ ДОСТИГНУТА!'));
          scaffoldKey.currentState.showSnackBar(snackBar);
        }
      } else {
        if (this.haveSum < int.parse(transaction['sum'])) {
          final snackBar = SnackBar(content: Text('НЕДОСТАТОЧНО ДЕНЕГ...'));
          scaffoldKey.currentState.showSnackBar(snackBar);
        } else {
          this.haveSum -= int.parse(transaction['sum']);
          this.needSum += int.parse(transaction['sum']);
        }
      }
      this.precent = this.haveSum / this.goalSum * 100;
      object['haveSum'] = this.haveSum;
      object['needSum'] = this.needSum;
      this.transations.add(transaction);
      LocalGoalService.setGoal(json.encode(object));
    } catch (ex) {
      final snackBar = SnackBar(content: Text('${ex.message}'));
      scaffoldKey.currentState.showSnackBar(snackBar);
    }
    notifyListeners();
  }

  cancelTransaction(Map<String, dynamic> transaction) async {
    if (transaction['type'] == '+') {
      this.haveSum -= int.parse(transaction['sum']);
      this.needSum += int.parse(transaction['sum']);
    } else {
      this.haveSum += int.parse(transaction['sum']);
      this.needSum -= int.parse(transaction['sum']);
    }
    object['haveSum'] = this.haveSum;
    object['needSum'] = this.needSum;
    this.precent = this.haveSum / this.goalSum * 100;

    await LocalGoalService.setGoal(json.encode(object));
    await LocalTransactionService.deleteTransaction(transaction['datetime']);
    this
        .transations
        .removeWhere((el) => el['datetime'] == transaction['datetime']);
    notifyListeners();
  }

  logout() async {
    await LocalGoalService.deleteGoal();
    await LocalTransactionService.clearTransactions();
  }
}
