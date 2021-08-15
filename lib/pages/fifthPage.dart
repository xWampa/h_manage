import 'package:flutter/material.dart';

class FifthPage extends StatelessWidget {
  final String data;

  FifthPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.directions_car)),
                Tab(icon: Icon(Icons.directions_transit)),
                Tab(icon: Icon(Icons.directions_bike)),
              ],
            ),
            title: const Text('Tabs'),
          ),
          body: TabBarView(
            children: [
              Column(
                children: [
                  Tab(icon: Icon(Icons.directions_car)),
                  ElevatedButton(
                    child: Text('Go to main'),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/');
                    },
                  ),
                ],
              ),
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
            ],
          ),
        ),
      ),
    );
  }
}