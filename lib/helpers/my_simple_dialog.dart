import 'package:flutter/material.dart';
import 'package:easy_dialog/easy_dialog.dart';
import 'package:safe_money/services/local_transaction_service.dart';

showMyDialog(context, title, ok, cancel, type) async {
  TextStyle ts = TextStyle(
    fontSize: 15,
    // color: Theme.of(context).textTheme.body1.color,
  );
  TextStyle tsTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    // color: Theme.of(context).textTheme.body1.color,
  );
  TextEditingController textEditingController = TextEditingController();

  bool _result = false;
  await EasyDialog(
      height: 200,
      // cardColor: Theme.of(context).appBarTheme.color,
      closeButton: false,
      title: Text(title, style: tsTitle),
      // description: Text(descreption),
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
                var transaction = {
                  "datetime": DateTime.now().toString(),
                  "sum": textEditingController.text,
                  "type": type
                };
                await LocalTransactionService.addTransaction(transaction);
                _result = true;
                Navigator.of(context).pop();
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
                  _result = false;
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        )
      ]).show(context);

  return _result;
}
