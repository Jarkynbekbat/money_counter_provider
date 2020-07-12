import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:provider/provider.dart';

import 'data/providers/goal_provider.dart';
import 'data/services/local_goal_service.dart';
import 'localization/app_localization.dart';
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

class MyApp extends StatefulWidget {
  final Widget startPage;
  final String goal;
  const MyApp({this.startPage, this.goal});

  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(locale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;

  @override
  void initState() {
    InAppUpdate.checkForUpdate().then((info) {
      if (info.updateAvailable) {
        InAppUpdate.performImmediateUpdate()
            .catchError((e) => print(e.toString()));
      }
    }).catchError((e) => print(e.toString()));
    super.initState();
  }

  void setLocale(Locale locale) => setState(() => _locale = locale);

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
        locale: _locale,
        supportedLocales: [
          Locale('en', 'US'),
          Locale('ru', 'RU'),
        ],
        localizationsDelegates: [
          AppLocalization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        localeResolutionCallback: (deviceLocale, supportedLocales) {
          for (var locale in supportedLocales) {
            if (locale.languageCode == deviceLocale.languageCode &&
                locale.countryCode == deviceLocale.countryCode) {
              return deviceLocale;
            }
          }
          return supportedLocales.first;
        },
        routes: <String, WidgetBuilder>{
          AuthPage.route: (BuildContext context) => AuthPage(),
          HomePage.route: (BuildContext context) => HomePage(),
          AboutPage.route: (BuildContext context) => AboutPage(),
          StatisticPage.route: (BuildContext context) => StatisticPage(),
        },
        home: widget.startPage,
      ),
    );
  }
}
