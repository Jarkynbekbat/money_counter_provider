import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/page_models/statistic_screen_model.dart';
import '../services/local_goal_service.dart';
import '../services/local_transaction_service.dart';

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

      this.precent = this.haveSum / this.goalSum * 100;
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
      await initData();
      return result;
    } else
      return false;
  }

  addTransaction(Map<String, dynamic> transaction, scaffoldKey) async {
    try {
      bool isOkay = true;
      if (transaction['type'] == '+') {
        if (this.haveSum >= this.goalSum) {
          this.needSum = 0;
          final snackBar = SnackBar(content: Text('ЦЕЛЬ ДОСТИГНУТА!'));
          scaffoldKey.currentState.showSnackBar(snackBar);
          isOkay = false;
        } else {
          this.haveSum += int.parse(transaction['sum']);
          this.needSum -= int.parse(transaction['sum']);
        }
      } else {
        if (this.haveSum < int.parse(transaction['sum'])) {
          final snackBar = SnackBar(content: Text('НЕДОСТАТОЧНО ДЕНЕГ...'));
          scaffoldKey.currentState.showSnackBar(snackBar);
          isOkay = false;
        } else {
          this.haveSum -= int.parse(transaction['sum']);
          this.needSum += int.parse(transaction['sum']);
        }
      }
      if (isOkay) {
        this.precent = this.haveSum / this.goalSum * 100;
        object['haveSum'] = this.haveSum;
        object['needSum'] = this.needSum;
        this.transations.add(transaction);
        await LocalTransactionService.addTransaction(transaction);
        LocalGoalService.setGoal(json.encode(object));
      }
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

  Future<StatisticScreenModel> getStatisticData() async {
    var statisticData = StatisticScreenModel();
    statisticData.averageSumPerDay = await _getAverageSum();
    int days = await _getDays();

    int years = days ~/ 365;
    days = days % 365;
    int months = days ~/ 30;
    days = days % 30;

    statisticData.days = days;
    statisticData.months = months;
    statisticData.years = years;

    return statisticData;
  }

  Future<double> _getAverageSum() async {
    double averageSumPerDay = 0;
    try {
      if (this.transations.length == 0) {
        return 0;
      } else {
        DateTime startDate = DateTime.parse(
            json.decode((await LocalGoalService.getGoal()))['goalDatetime']);
        int diffInDays = DateTime.now().difference(startDate).inDays + 1;
        averageSumPerDay = this.haveSum / diffInDays;
        return averageSumPerDay;
      }
    } catch (ex) {
      return 0.0;
    }
  }

  Future<int> _getDays() async {
    double averageSum = await this._getAverageSum();
    if (averageSum > 0) {
      int count = 0;
      double tempSum = 0;
      do {
        tempSum += averageSum;
        count++;
      } while (tempSum < this.needSum);
      return count;
    } else
      return 0;
  }

  logout() async {
    await LocalGoalService.deleteGoal();
    await LocalTransactionService.clearTransactions();
  }
}
