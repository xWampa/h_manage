import 'package:flutter/material.dart';

class VariosInput extends StatelessWidget {
  TextEditingController variosProduct = TextEditingController();
  TextEditingController variosPrice = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: ListBody(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 200,
                padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                child: TextFormField(
                  controller: variosProduct,
                  decoration: const InputDecoration(
                    labelText: 'Product name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                width: 100,
                padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                child: TextFormField(
                  controller: variosPrice,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}