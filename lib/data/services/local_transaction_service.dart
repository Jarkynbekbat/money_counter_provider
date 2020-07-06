import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalTransactionService {
  static Future<bool> addTransaction(transaction) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList('transactions') ?? [];
    list.add(json.encode(transaction));
    return prefs.setStringList('transactions', list);
  }

  static Future<List<String>> getTransactions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList('transactions') ?? [];
    return list;
  }

  static Future<bool> deleteTransaction(datetime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList('transactions');

    var listMap = list.map((el) => json.decode(el)).toList();
    listMap.removeWhere((el) => el['datetime'] == datetime);
    list = listMap.map((el) => json.encode(el)).toList();
    return prefs.setStringList('transactions', list);
  }

  static Future<bool> clearTransactions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove('transactions');
  }
}
