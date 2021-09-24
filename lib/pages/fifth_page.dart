import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'package:h_manage/data.dart';
import 'package:h_manage/route_generator.dart';
import 'package:h_manage/server_request.dart';

// TODO: Do something when Futures completes with error
// TODO: Center the text in the CircleAvatar (number of items badge)
// TODO: Prevent further calls when tapping the same table over and over
// TODO: Add a refresh button on server connection fail
// TODO: Remove the 1st tab (index 0) and move that to a drawer maybe
// TODO: Remove TotalTableBill in the Tables TAB when total is 0
// TODO: Disable edit button (tbills items) when the Table has paid
// TODO: Maybe add a transition to tbill-tab to prevent the abrupt refresh

class FifthPage extends StatefulWidget {
  final String data;

  FifthPage({Key? key, required this.data}) : super(key: key);

  @override
  _FifthPageState createState() => _FifthPageState();
}

class _FifthPageState extends State<FifthPage>
    with SingleTickerProviderStateMixin {
  List<bool> _isDisabled = [false, false, true, true];
  late TabController _tabController;
  int _selectedTable = 0;
  int _itemsInTable = 0;
  num _totalTableBill = 0;
  num _money = 0;
  num _change = 0;
  bool _clearMoneyChange = false;
  late Future<List<Product>> listOfDBProducts;
  late Future<List<Tablee>> listOfDBTables;
  late Future<List<Tbill>> listOfTbills;
  late Future<List<Tbill>> futureTableBill;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  onTap() {
    if (_isDisabled[_tabController.index]) {
      if (_isDisabled[2] == true) {
        final snackBar = SnackBar(
          content: Text('Select a table'),
          duration: const Duration(milliseconds: 1500),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        );
        scaffoldMessengerKey.currentState!.showSnackBar(snackBar);
      }
      if (_isDisabled[2] == false && _isDisabled[3] == true) {
        final snackBar = SnackBar(
          content: Text('Add items to the table'),
          duration: const Duration(milliseconds: 1500),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        );
        scaffoldMessengerKey.currentState!.showSnackBar(snackBar);
      }

      setState(() {
        if (_isDisabled[2] == true) _tabController.index = 1;
        if (_isDisabled[2] == false && _isDisabled[3] == true)
          _tabController.index = 2;
      });
    }
    if (_clearMoneyChange == true) {
      clearMoneyAndChange();
    }

    if (_tabController.index == 3) {
      refreshFuture();
      updateBadge();
    }
  }

  @override
  void initState() {
    super.initState();
    futureTableBill = ServerRequest.newfetchTableTbills(1.toString());
    listOfDBProducts = ServerRequest.fetchProducts(http.Client());
    listOfDBTables = ServerRequest.fetchTables(http.Client());
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(onTap);
    ServerRequest.createCashCount();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Keeps updating the selected table at the top (title)
  Widget _resolveSelectedTable() {
    if (_selectedTable == 0) {
      _isDisabled = [false, false, true, true];
      return Text('Table: Please select a table');
    }
    return Text('Table: ' + _selectedTable.toString());
  }

  // Keeps updating the nº of items on the selected table (Tab(Row(Text)))
  Widget _resolveNumberOfItemsInTable() {
    if (_itemsInTable == 0) {
      return Text('0', textAlign: TextAlign.center);
    }
    return Text(_itemsInTable.toString(), textAlign: TextAlign.center);
  }

  void _changeSelectedTable(int number) {
    setState(() {
      _selectedTable = number;
    });

    refreshFuture();
    updateBadge();

    _isDisabled = [false, false, false, true];
    if (_itemsInTable != 0) _isDisabled[3] = false;
    _tabController.index = 2;
  }

  // New function that updates the future and updates the nº of items badge
  void _newUpdateFuture(int number) {
    refreshFuture();
    updateBadge();
  }

  // Updates money and change
  void updateMoneyAndChange(List<num> money) {
    setState(() {
      _money = money[0];
      _change = money[1];
    });
  }

  void clearMoneyAndChange() {
    _clearMoneyChange = false;

    _isDisabled = [false, false, true, true];
    setState(() {
      _money = 0;
      _change = 0;
      _selectedTable = 0;
      if (_isDisabled[2] == true) _tabController.index = 1;
      if (_isDisabled[2] == false && _isDisabled[3] == true)
        _tabController.index = 2;
    });
    _resolveSelectedTable();
  }

  void cardPaymentRoutine() {
    _isDisabled = [false, false, true, true];
    ServerRequest.deleteTbill(_selectedTable.toString());
    ServerRequest.updateCashCount(_totalTableBill.toString(),
        _totalTableBill.toString(), null, 1, null, null, null, getDate());
    ServerRequest.updateTable(_selectedTable, 0.toString());

    setState(() {
      _selectedTable = 0;
      _itemsInTable = 0;
      if (_isDisabled[2] == true) _tabController.index = 1;
      if (_isDisabled[2] == false && _isDisabled[3] == true)
        _tabController.index = 2;
      listOfDBTables = ServerRequest.fetchTables(http.Client());
    });
    _resolveSelectedTable();
  }

  void refreshFuture() {
    setState(() {
      futureTableBill =
          ServerRequest.newfetchTableTbills(_selectedTable.toString());
    });
  }

  void updateBadge() {
    int count = 0;
    num total = 0;
    futureTableBill.then((value) {
      for (var item in value) {
        count = count + item.units;
        total = total + num.parse(item.total);
      }
      ServerRequest.updateTable(_selectedTable, total.toString());

      setState(() {
        _itemsInTable = count;
        _totalTableBill = total;
        listOfDBTables = ServerRequest.fetchTables(http.Client());
      });

      _isDisabled = [false, false, false, true];
      if (_itemsInTable != 0) _isDisabled[3] = false;
    });
  }

  // Goes to the sixth page and expects a return of money and change
  void askForMoney(BuildContext context) async {
    final moneyChange = await Navigator.of(context)
        .pushNamed('/sixth', arguments: <num>[_totalTableBill, _selectedTable]);
    moneyChange as List<num>;
    print(moneyChange);
    if (moneyChange != [0, 0]) {
      setState(() {
        listOfDBTables = ServerRequest.fetchTables(http.Client());
        _money = moneyChange[0];
        _change = moneyChange[1];
        _itemsInTable = 0;
      });
      _clearMoneyChange = true;
    }
  }

  // Goes to the edit_bill_product and edit the tbill entry
  void editBillProduct(BuildContext context, List<dynamic> tbillEntry) async {
    print(tbillEntry.toString());
    final tbillBody = await Navigator.of(context)
        .pushNamed('/fifth/edit_bill_product', arguments: tbillEntry);
    if (tbillBody != null) tbillBody as bool;
    if (tbillBody == true) {
      refreshFuture();
      updateBadge();
    }
  }

  // Retrieves the current date in format yyyy-mm-dd
  String getDate() {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    final List<String> finalDate = date.toString().split(" ");
    return finalDate[0];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: RouteGenerator.generateRoute,
      home: DefaultTabController(
        length: 4,
        child: ScaffoldMessenger(
          key: scaffoldMessengerKey,
          child: Scaffold(
            drawer: Drawer(
              child: ListView(
                children: [
                  ListTile(
                    title: Text(
                        'HManage',
                      style: TextStyle(
                        fontSize: 23,
                        color: Colors.blue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ListTile(
                    title: Text('This is the title'),
                    leading: Icon(Icons.add),
                    subtitle: Text('This is the subtitle'),
                    onTap: () => print("handsome"),
                    onLongPress: () => print("ugly"),
                  ),
                  ListTile(
                    title: Text('This is the title'),
                    leading: Icon(Icons.print),
                    subtitle: Text('This is the subtitle'),
                  ),
                  ListTile(
                    title: Text('This is the title'),
                    leading: Icon(Icons.keyboard),
                    subtitle: Text('This is the subtitle'),
                  ),
                  ListTile(
                    title: Text('This is the title'),
                    leading: Icon(Icons.account_balance),
                    subtitle: Text('This is the subtitle'),
                  ),
                ],
              ),
            ),
            appBar: AppBar(
              bottom: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(icon: Icon(Icons.directions_car)),
                  Tab(child: Text('Tables'), icon: Icon(Icons.chair_alt)),
                  Tab(
                      child: Text('Products'),
                      icon: Icon(Icons.grid_on_rounded)),
                  Tab(
                    child: Text('Bill'),
                    icon: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.format_list_bulleted_rounded),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 10,
                          child: _resolveNumberOfItemsInTable(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              title: _resolveSelectedTable(),
            ),
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Tab(icon: Icon(Icons.directions_car)),
                      ElevatedButton(
                        child: Text('Go to main'),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/');
                        },
                      ),
                      Text('Hi there!'),
                      Container(
                        margin: EdgeInsets.all(10),
                        child: SizedBox(
                          width: 130,
                          height: 130,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('/second',
                                  arguments: 'I just pressed the new button');
                            },
                            child: Text('Wine'),
                            style: TextButton.styleFrom(
                              textStyle: GoogleFonts.rubik(
                                fontSize: 25,
                              ),
                              primary: Colors.amber,
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/second',
                                arguments: 'I just pressed the new button');
                          },
                          child: Text('I am pretty famous last words')),
                      ElevatedButton(
                          onPressed: () {
                            ServerRequest.updateTable(1, 10.toString());
                          },
                          child: Text('TEST PLACEHOLDER')),
                    ],
                  ),
                ),
                FutureBuilder<List<Tablee>>(
                  future: listOfDBTables,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('An error has occurred!'),
                      );
                    } else if (snapshot.hasData) {
                      return TablesView(
                        tables: snapshot.data!,
                        changeTable: (int val) => _changeSelectedTable(val),
                        //updateFuture: (int val) => _newUpdateFuture(val),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
                FutureBuilder<List<Product>>(
                  future: listOfDBProducts,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('An error has occurred!'),
                      );
                    } else if (snapshot.hasData) {
                      return ProductsView(
                        tnumber: _selectedTable,
                        products: snapshot.data!,
                        updateFuture: (int val) => _newUpdateFuture(val),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
                FutureBuilder<List<Tbill>>(
                  future: futureTableBill,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        if (snapshot.requireData.length != 0) {
                          return Scaffold(
                            body: Align(
                              alignment: Alignment.topCenter,
                              child: ListView(
                                children: [
                                  Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing: 8.0,
                                    runSpacing: 8.0,
                                    children: [
                                      PopulateDataTable(
                                        tbills: snapshot.data!,
                                        updateTbill: (List<dynamic> val) =>
                                            editBillProduct(context, val),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(28.0),
                                        child: Container(
                                          height: 250,
                                          width: 350,
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade50,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  height: 50,
                                                  width: 350,
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          'Total',
                                                          style: TextStyle(
                                                            fontSize: 26,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          _totalTableBill
                                                              .toStringAsFixed(
                                                                  2),
                                                          style: TextStyle(
                                                            fontSize: 28,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  height: 50,
                                                  width: 350,
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          'Money',
                                                          style: TextStyle(
                                                            fontSize: 26,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          _money
                                                              .toStringAsFixed(
                                                                  2),
                                                          style: TextStyle(
                                                            fontSize: 28,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  height: 50,
                                                  width: 350,
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          'Change',
                                                          style: TextStyle(
                                                            fontSize: 26,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          _change
                                                              .toStringAsFixed(
                                                                  2),
                                                          style: TextStyle(
                                                            fontSize: 28,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            floatingActionButton: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                FloatingActionButton(
                                  heroTag: "cash",
                                  child: Icon(Icons.euro_rounded),
                                  onPressed: () {
                                    askForMoney(context);
                                  },
                                ),
                                FloatingActionButton(
                                  heroTag: "card",
                                  child: Icon(Icons.credit_card),
                                  onPressed: () {
                                    cardPaymentRoutine();
                                  },
                                ),
                                // FloatingActionButton(
                                //   heroTag: "more",
                                //   //child: Icon(Icons.add),
                                //   child: Text(
                                //     _totalTableBill.toStringAsFixed(2),
                                //   ),
                                //   onPressed: () {},
                                // ),
                              ],
                            ),
                          );
                        } else {
                          return Center(child: Text('No items yet'));
                        }
                      } else {
                        return const Center(
                          child: Text('An error has occurred!'),
                        );
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PopulateDataTable extends StatelessWidget {
  final List<Tbill> tbills;
  final List<DataRow> itemRow = [];
  final Function(List<dynamic>) updateTbill;

  PopulateDataTable({
    Key? key,
    required this.tbills,
    required this.updateTbill,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    for (var item in tbills) {
      itemRow.add(
        DataRow(
          cells: [
            DataCell(Text(item.units.toString())),
            DataCell(Text(item.item)),
            DataCell(Text(item.iprice)),
            DataCell(Text(item.total)),
            DataCell(Icon(Icons.edit), onTap: () {
              updateTbill([
                item.id,
                item.units,
                item.item,
                item.iprice,
                item.total,
              ]);
            }),
          ],
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            const DataColumn(
              label: Text(
                'Units',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            const DataColumn(
              label: Text(
                'Product',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            const DataColumn(
              label: Text(
                'Price',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            const DataColumn(
              label: Text(
                'Total',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            const DataColumn(
              label: Text(
                '',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 1,
                ),
              ),
            ),
          ],
          rows: itemRow,
        ),
      ),
    );
  }
}

class ProductsView extends StatelessWidget {
  final List<Product> products;
  final int tnumber;
  final Function(int) updateFuture;

  ProductsView({
    Key? key,
    required this.tnumber,
    required this.updateFuture,
    required this.products,
    // required this.addItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      scrollDirection: Axis.vertical,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 100,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ElevatedButton(
            onPressed: () {
              ServerRequest.createTbill(
                tnumber,
                products[index].name,
                1,
                products[index].price,
                products[index].price,
              );
              updateFuture(tnumber);
            },
            child: Text(products[index].name));
      },
    );
  }
}

class TablesView extends StatelessWidget {
  final List<Tablee> tables;
  final Function(int) changeTable;
  TablesView({
    Key? key,
    required this.tables,
    required this.changeTable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      scrollDirection: Axis.vertical,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 100,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      padding: const EdgeInsets.all(10),
      itemCount: tables.length,
      itemBuilder: (context, index) {
        return ElevatedButton(
            onPressed: () {
              changeTable(tables[index].number);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(tables[index].number.toString()),
                Text(tables[index].total),
              ],
            ));
      },
    );
  }
}
