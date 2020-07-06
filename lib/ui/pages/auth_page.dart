import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/my_colors.dart';
import '../../helpers/screen.dart';
import '../../providers/goal_provider.dart';
import '../../ui/pages/home_page.dart';

class AuthPage extends StatelessWidget {
  static String route = 'auth';
  final TextEditingController goalNameController = TextEditingController();
  final TextEditingController goalSumController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.color1,
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: Screen.width(context) * 0.8,
            height: Screen.heigth(context) * 0.50,
            color: MyColors.color3,
            child: Center(
              child: Wrap(
                children: <Widget>[
                  SizedBox(
                    width: Screen.width(context) * 0.7,
                    child: TextField(
                      controller: goalNameController,
                      decoration: InputDecoration(
                        hintText: 'введите цель',
                        labelText: 'цель',
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
                        hintText: 'введите сумму',
                        labelText: 'cумма',
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
        backgroundColor: MyColors.color4,
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
