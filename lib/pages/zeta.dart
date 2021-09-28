import 'package:flutter/material.dart';
import 'package:h_manage/server_request.dart';

class Zeta extends StatefulWidget {
  Zeta({
    Key? key,
  }) : super(key: key);

  @override
  _ZetaState createState() => _ZetaState();
}

class _ZetaState extends State<Zeta> {
  String getDate() {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    final List<String> finalDate = date.toString().split(" ");
    return finalDate[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zeta'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.today, color: Colors.blue,),
              Text(
                'Day:',
              ),
              Text(
                getDate(),
                style: Theme.of(context).textTheme.headline4,
              ),
              Divider(),
              Icon(Icons.euro_rounded, color: Colors.blue,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Total sale:',
                  ),
                  Text(
                    '288.69',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Cash payments:',
                  ),
                  Text(
                    '100.69',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Card payments:',
                  ),
                  Text(
                    '188.00',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
              Divider(),
                  Icon(Icons.add_chart, color: Colors.blue,),
                  Text(
                    'Statistics:',
                  ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Number of transactions:',
                  ),
                  Text(
                    '50',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Average ticket:',
                  ),
                  Text(
                    '5.77',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ],
              ),
              Divider(),
                  Icon(Icons.call_missed_outgoing_sharp, color: Colors.blue,),
                  Text(
                    'Cash flow:',
                  ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Cash payments:',
                  ),
                  Text(
                    '+100.69',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Total cash inflow:',
                  ),
                  Text(
                    '+90.00',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Money:',
                  ),
                  Text(
                    '-25.00',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Cash balance:',
                  ),
                  Text(
                    '=165.00€',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
