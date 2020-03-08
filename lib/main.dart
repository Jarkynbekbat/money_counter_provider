import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_money/models/goal.dart';
import 'package:safe_money/pages/first_page.dart';
import 'package:safe_money/providers/goal_provider.dart';
import 'package:safe_money/services/db.dart';
import 'pages/home_page/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DB.init();

  // Goal goal = Goal(
  //   name: 'Купить машину',
  //   sum: 300,
  //   haveSum: 0,
  //   needSum: 300,
  //   startDate: DateTime.now().toString(),
  // );

  // var result = await DB.insert(Goal.table, goal);
  // List<Map<String, dynamic>> _results = await DB.query(Goal.table);

  // print('hope');

  return runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => GoalProvider()),
    ],
    child: MaterialApp(
      title: 'Учет денег',
      routes: <String, WidgetBuilder>{
        //создаю роуты приложения
        '/first': (BuildContext context) => FirstPage(),
        '/home': (BuildContext context) => HomePage(),
      },
      home: FirstPage(),
    ),
  ));
}
