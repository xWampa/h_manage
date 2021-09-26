import 'package:flutter/material.dart';
import 'package:h_manage/server_request.dart';

import 'package:h_manage/pages/hero_dialog_route.dart';
import 'package:h_manage/pages/edit_price.dart';

class EditBillProduct extends StatefulWidget {
  final int id;
  final int units;
  final String product;
  final String price;
  final String total;
  EditBillProduct({
    Key? key,
    required this.id,
    required this.units,
    required this.product,
    required this.price,
    required this.total,
  }) : super(key: key);

  @override
  _EditBillProductState createState() => _EditBillProductState();
}

class _EditBillProductState extends State<EditBillProduct> {
  int count = 0;
  num total = 0;
  num itemPrice = 0;
  bool justOnce = true;
  bool productError = false;

  TextEditingController _controllerProduct = TextEditingController();

  String getDate() {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    final List<String> finalDate = date.toString().split(" ");
    return finalDate[0];
  }

  @override
  EditBillProduct get widget => super.widget;

  @override
  void initState() {
    super.initState();
    count = widget.units;
    total = num.parse(widget.total);
    itemPrice = num.parse(widget.price);

    _controllerProduct.text = widget.product;
    _controllerProduct.selection = TextSelection(
        baseOffset: 0, extentOffset: _controllerProduct.text.length);
  }

  void decreaseUnits() {
    if (count > 1) {
      setState(() {
        count--;
      });
      updateTotal();
    }
  }
  void increaseUnits() {
    setState(() {
      count ++;
    });
    updateTotal();
  }

  void updateTotal() {
    setState(() {
      total = count * itemPrice;
    });
  }

  // Goes to the ..itemPrice and edit the product price
  void editPrice(BuildContext context, num price) async {
    final returnedPrice = await Navigator.of(context)
        .pushNamed('/fifth/edit_bill_product/price', arguments: price);
    returnedPrice as num;
  }

  void editPrice2(BuildContext context, num price) async {
    final returnedPrice = await Navigator.of(context).push(HeroDialogRoute(builder: (context) {
      return AddPricePopupCard(price: price);
    }));
    if (returnedPrice != null) returnedPrice as num;
    print(returnedPrice);
    if (returnedPrice is num) {
      setState(() {
        itemPrice = returnedPrice;
      });
      updateTotal();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit'),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 20,
          vertical: MediaQuery.of(context).size.width / 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Units:', style: TextStyle(fontSize: 18),),
                TextButton(
                    onPressed: () => decreaseUnits(),
                    child: Icon(Icons.keyboard_arrow_down)
                ),
                Text(count.toString()),
                TextButton(
                    onPressed: () => increaseUnits(),
                    child: Icon(Icons.keyboard_arrow_up))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Product:  ', style: TextStyle(fontSize: 18),),
                Container(
                  width: 155,
                  child: TextField(
                      textAlign: TextAlign.center,
                      textCapitalization: TextCapitalization.sentences,
                      controller: _controllerProduct,
                      decoration: InputDecoration(
                        hintText: 'Product name',
                        errorText: productError ? "Value Can't Be Empty" : null,
                      ),
                      onTap: () {
                        if (justOnce == true) {
                          justOnce = false;
                          _controllerProduct.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: _controllerProduct.text.length);
                        }
                      }),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Price: ', style: TextStyle(fontSize: 18),),
                TextButton(
                    onPressed: () {
                     editPrice2(context, itemPrice);
                    },
                    child: Text(itemPrice.toStringAsFixed(2) + ' €')),
                Icon(Icons.edit, size: 16,),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Total:  ', style: TextStyle(fontSize: 18),),
                Text(total.toStringAsFixed(2) + ' €'),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _controllerProduct.text.isEmpty
                      ? productError = true
                      : productError = false;
                });
                if (!productError) {
                  ServerRequest.updateTbill(
                      widget.id,
                      null,
                      _controllerProduct.text,
                      count,
                      itemPrice.toString(),
                      total.toString());
                  Navigator.pop(context, true);
                }

              },
              child: const Text('Edit'),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     print(widget.id);
            //     print(widget.units);
            //     print(widget.product);
            //     print(widget.price);
            //     print(widget.total);
            //   },
            //   child: const Text('show'),
            // ),
          ],
        ),
      ),
    );
  }
}