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

  double getAverageSumPerDay() {
    double averageSumPerDay = 0;

    try {
      if (this.transations.length == 0) {
        return 0;
      } else {
        List<dynamic> onlyPlus =
            this.transations.where((el) => el['type'] == '+').toList();
        Set<String> uniqDates =
            Set.from(onlyPlus.map((el) => el['date']).toList());
        List<String> dates = List.from(uniqDates);
        Map<String, double> averageSum = {};
        for (String date in dates) {
          this
              .transations
              .where((el) => el['date'] == date)
              .toList()
              .forEach((transation) {
            double sum = double.parse(transation['sum']);
            if (averageSum[date] == null) {
              averageSum[date] = 0;
            }
            if (transation['type'] == '+') {
              averageSum[date] += sum;
            } else if (transation['type'] == '-') {
              averageSum[date] -= sum;
            }
          });
        }
        for (String date in averageSum.keys) {
          averageSumPerDay += averageSum[date];
        }
        return averageSumPerDay / averageSum.keys.length;
      }
    } catch (ex) {
      return 0.0;
    }
  }

  int getDaysCountBeforeGoal() {
    double averageSum = this.getAverageSumPerDay();

    if (averageSum > 0) {
      int count = 0;
      double tempSum = 0;
      do {
        tempSum += averageSum;
        count++;
      } while (tempSum < this.goalSum);

      return count;
    } else
      return 0;
  }

  logout() async {
    await LocalGoalService.deleteGoal();
    await LocalTransactionService.clearTransactions();
  }
}
