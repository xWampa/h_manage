import 'package:flutter/material.dart';

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('H MANAGE'),
      ),
      body: Center(
        child: Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: <Widget>[
            ElevatedButton(
              child: Text('Go to second'),
              onPressed: () {
                Navigator.of(context).pushNamed('/second',
                    arguments: 'Hello there from the first page');
              },
            ),
            ElevatedButton(
              child: Text('Go to third'),
              onPressed: () {
                Navigator.of(context).pushNamed('/third',
                    arguments: 'You are now on third page, hi from page One');
              },
            ),
            ElevatedButton(
              child: Text('Go to fourth'),
              onPressed: () {
                Navigator.of(context).pushNamed('/fourth');
              },
            ),
            ElevatedButton(
              child: Text('Go to fifth'),
              onPressed: () {
                Navigator.of(context).pushNamed('/fifth');
              },
            ),
            ElevatedButton(
              child: Text('Go to sixth'),
              onPressed: () {
                Navigator.of(context).pushNamed('/sixth');
              },
            ),
            ElevatedButton(
              child: Text('Go to seventh'),
              onPressed: () {
                Navigator.of(context).pushNamed('/seventh');
              },
            ),
          ],
        ),
      ),
    );
  }
}
