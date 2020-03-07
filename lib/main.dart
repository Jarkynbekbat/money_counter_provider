import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_money/pages/first_page.dart';
import 'package:safe_money/providers/goal_provider.dart';
import 'pages/home_page/home_page.dart';

void main() async {
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
