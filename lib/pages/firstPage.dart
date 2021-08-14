import 'package:flutter/material.dart';

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TITLE MAIN'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'First Page',
              style: TextStyle(fontSize: 50),
            ),
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
          ],
        ),
      ),
    );
  }
}