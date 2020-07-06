import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'data/services/local_goal_service.dart';
import 'providers/goal_provider.dart';
import 'ui/pages/about_page.dart';
import 'ui/pages/auth_page.dart';
import 'ui/pages/home_page.dart';
import 'ui/pages/statistic_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String goal = await LocalGoalService.getGoal();
  Widget startPage = goal == null ? AuthPage() : HomePage();

  return runApp(MyApp(goal: goal, startPage: startPage));
}

class MyApp extends StatelessWidget {
  final Widget startPage;
  final String goal;
  const MyApp({this.startPage, this.goal});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GoalProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            color: const Color(0xff424874),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: const Color(0xff424874),
          ),
          textTheme: const TextTheme(
            bodyText1: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
        ),
        title: 'Учет денег',
        routes: <String, WidgetBuilder>{
          AuthPage.route: (BuildContext context) => AuthPage(),
          HomePage.route: (BuildContext context) => HomePage(),
          AboutPage.route: (BuildContext context) => AboutPage(),
          StatisticPage.route: (BuildContext context) => StatisticPage(),
        },
        home: startPage,
      ),
    );
  }
}
