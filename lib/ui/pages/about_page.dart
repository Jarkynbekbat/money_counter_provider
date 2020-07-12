import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../localization/get_value.dart';

class AboutPage extends StatelessWidget {
  static String route = 'about';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getValue(context, 'aboutTitle')),
      ),
      body: Container(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              getValue(context, 'about'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(height: 30.0),
            OutlineButton(
              color: Colors.white,
              disabledBorderColor: Colors.white,
              textColor: Colors.black,
              onPressed: () => openUrl('mailto:jarkynbekbat@gmail.com'),
              child: Text(
                getValue(context, 'textUs'),
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            OutlineButton(
              color: Colors.white,
              disabledBorderColor: Colors.white,
              textColor: Colors.black,
              onPressed: () => openUrl(
                  'https://github.com/Jarkynbekbat/money_counter_provider'),
              child: Text(
                'GitHub',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

openUrl(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
