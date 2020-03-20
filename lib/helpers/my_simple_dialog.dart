import 'package:flutter/material.dart';
import 'package:easy_dialog/easy_dialog.dart';
import 'package:provider/provider.dart';
import 'package:safe_money/providers/goal_provider.dart';

showMyDialog(context, title, ok, cancel, type, scaffoldKey) async {
  TextStyle ts = TextStyle(
    fontSize: 15,
  );
  TextStyle tsTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  TextEditingController textEditingController = TextEditingController();

  await EasyDialog(
      height: 200,
      closeButton: false,
      title: Text(title, style: tsTitle),
      contentList: [
        TextField(
          controller: textEditingController,
          keyboardType: TextInputType.number,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OutlineButton(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              child: Text(
                ok,
                style: ts,
              ),
              onPressed: () async {
                try {
                  DateTime now = DateTime.now();
                  String formatedDate = '${now.day}.${now.month}.${now.year}';
                  String formatedTime = '${now.hour}:${now.minute}';
                  int.parse(textEditingController.text);
                  Map<String, dynamic> transaction = {
                    "datetime": now.toString(),
                    "date": formatedDate,
                    "time": formatedTime,
                    "sum": textEditingController.text,
                    "type": type
                  };
                  await Provider.of<GoalProvider>(context, listen: false)
                      .addTransaction(transaction, scaffoldKey);
                  Navigator.of(context).pop();
                } catch (ex) {
                  final snackBar = SnackBar(content: Text('ВВЕДИТЕ ЧИСЛО...'));
                  scaffoldKey.currentState.showSnackBar(snackBar);
                  Navigator.of(context).pop();
                }
              },
            ),
            Container(
              margin: EdgeInsets.only(left: 5),
              child: OutlineButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                child: Text(
                  cancel,
                  style: ts,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        )
      ]).show(context);

  return true;
}
