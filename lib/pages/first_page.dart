import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_money/helpers/my_colors.dart';
import 'package:safe_money/helpers/screen.dart';
import 'package:safe_money/providers/goal_provider.dart';
import 'package:safe_money/services/local_goal_service.dart';

class FirstPage extends StatelessWidget {
  final TextEditingController goalNameController = TextEditingController();
  final TextEditingController goalSumController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    LocalGoalService.getGoal().then((obj) {
      if (obj != null) Navigator.of(context).pushReplacementNamed('/home');
    });

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
                  Center(
                    child: SizedBox(
                      width: Screen.width(context) * 0.7,
                      child: TextField(
                        controller: goalNameController,
                        decoration: InputDecoration(
                          hintText: 'введите цель',
                          labelText: 'цель',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 70),
                  Center(
                    child: SizedBox(
                      width: Screen.width(context) * 0.7,
                      child: TextField(
                        controller: goalSumController,
                        decoration: InputDecoration(
                          hintText: 'введите сумму',
                          labelText: 'cумма',
                        ),
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
            Navigator.of(context).pushReplacementNamed('/home');
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
