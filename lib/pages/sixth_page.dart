import 'package:flutter/material.dart';

class SixthPage extends StatefulWidget {
  final String title;
  SixthPage({Key? key, required this.title}) : super(key: key);


  @override
  _SixthPageState createState() => _SixthPageState();

}

class _SixthPageState extends State<SixthPage> {
  int _counter = 0;
  List<int> listaInt = [1,2,3,4,5];

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _changeCounter(int number) {
    setState(() {
      _counter = number;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hola' + _counter.toString()),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(onPressed: () => _changeCounter(7), child: Text('7')),
            ElevatedButton(onPressed: () => _changeCounter(5), child: Text('5')),
            ...tablesView2(listaInt),
            ButtonWidget(
              foreignCount: _counter,
              onCountChange: (int val) => setState(() => _counter = val),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  void yomama(){
  }

  void stateSetter() {
    setState(() {
      _counter = 13;
    });
  }

  List<Widget> tablesView2 (List<int> listaDeInts){
    List<Widget> botones = [];
    for(var individual in listaDeInts) {
      // botones.add(Text(individual.number.toString()));
      botones.add(
          ElevatedButton(
            child: Text(individual.toString()),
            onPressed: () => _changeCounter(individual),
          )
      );
    }
    return botones;
  }

}

class ButtonWidget extends StatelessWidget {
  final int foreignCount;
  final Function(int) onCountChange;
  ButtonWidget({required this.foreignCount, required this.onCountChange });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => onCountChange(13),
        child: Text('13')
    );
  }
}


