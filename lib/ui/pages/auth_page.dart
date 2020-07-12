import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/providers/goal_provider.dart';
import '../../data/services/screen.dart';
import '../../localization/get_value.dart';
import '../../ui/pages/home_page.dart';

class AuthPage extends StatelessWidget {
  static String route = 'auth';
  final TextEditingController goalNameController = TextEditingController();
  final TextEditingController goalSumController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: Screen.width(context) * 0.8,
            height: Screen.heigth(context) * 0.50,
            child: Center(
              child: Wrap(
                children: <Widget>[
                  SizedBox(
                    width: Screen.width(context) * 0.7,
                    child: TextField(
                      controller: goalNameController,
                      decoration: InputDecoration(
                        hintText: getValue(context, 'inputGoal'),
                        labelText: getValue(context, 'goal'),
                      ),
                    ),
                  ),
                  SizedBox(height: 70),
                  SizedBox(
                    width: Screen.width(context) * 0.7,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: goalSumController,
                      decoration: InputDecoration(
                        hintText: getValue(context, 'inputHint'),
                        labelText: getValue(context, 'sum'),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await Provider.of<GoalProvider>(context, listen: false).saveGoal(
              name: goalNameController.text,
              goalSum: int.parse(goalSumController.text),
            );
            // Provider.of<GoalProvider>(context, listen: false).initData();
            Navigator.of(context).pushReplacementNamed(HomePage.route);
          } catch (ex) {
            if (ex.message == "Invalid radix-10 number") {
              print('введите число');
            }
          }
        },
        child: Icon(Icons.arrow_forward),
      ),
    );
  }
}
