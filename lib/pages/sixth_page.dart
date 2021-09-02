import 'package:flutter/material.dart';

//TODO: Create bills and coins icons

class SixthPage extends StatefulWidget {
  final num total;
  SixthPage({Key? key, required this.total}) : super(key: key);


  @override
  _SixthPageState createState() => _SixthPageState();

}

class _SixthPageState extends State<SixthPage> {
  @override SixthPage get widget => super.widget;
  num _counter = 0;
  List<int> listaInt = [200,100,50,20,10,5];
  List<double> listaDouble = [2,1,0.5,0.2,0.1,0.05,0.02,0.01];

  void _incrementCounter() {
    setState(() {
      _counter = _counter + widget.total;
    });
  }

  void _addMoney(num number) {
    setState(() {
      _counter = _counter + number;
    });
  }

  void _clearMoney() {
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hola' + _counter.toString()),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Cash:',
                ),
                Text(
                  _counter.toStringAsFixed(2),
                  style: Theme.of(context).textTheme.headline4,
                ),
                ...tablesView2(listaInt),
                ButtonWidget(
                  foreignCount: _counter,
                  onCountChange: (int val) => setState(() => _counter = val),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: () => Navigator.pop(context), child: Text('Atras')),
                    ElevatedButton(onPressed: () => _clearMoney(), child: Text('Clear')),
                  ],
                ),
              ],
            ),
    //Coins
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ...tablesView2(listaDouble),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "sum",
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  void stateSetter() {
    setState(() {
      _counter = 13;
    });
  }

  List<Widget> tablesView2 (List<num> listaDeInts){
    List<Widget> botones = [];
    for(var individual in listaDeInts) {
      // botones.add(Text(individual.number.toString()));
      botones.add(
          ElevatedButton(
            child: Text(individual.toString() + '€'),
            onPressed: () => _addMoney(individual),
          )
      );
    }
    return botones;
  }

}

class ButtonWidget extends StatelessWidget {
  final num foreignCount;
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


