import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_money/helpers/my_colors.dart';
import 'package:safe_money/pages/about_page.dart';
import 'package:safe_money/pages/auth_page.dart';
import 'package:safe_money/pages/statistic_page.dart';
import 'package:safe_money/providers/goal_provider.dart';
import 'package:safe_money/services/local_goal_service.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String goal = await LocalGoalService.getGoal();
  Widget startPage = goal == null ? AuthPage() : HomePage();

  return runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => GoalProvider()),
    ],
    child: MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: MyColors.color3,
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      title: 'Учет денег',
      routes: <String, WidgetBuilder>{
        //создаю роуты приложения
        AuthPage.route: (BuildContext context) => AuthPage(),
        HomePage.route: (BuildContext context) => HomePage(),
        AboutPage.route: (BuildContext context) => AboutPage(),
        StatisticPage.route: (BuildContext context) => StatisticPage(),
      },
      home: startPage,
    ),
  ));
}
