import 'package:flutter/material.dart';

class AddPricePopupCard extends StatefulWidget {
  final num price;

  AddPricePopupCard({Key? key, required this.price}) : super(key: key);

  @override
  _AddPricePopupCardState createState() => _AddPricePopupCardState();
}

class _AddPricePopupCardState extends State<AddPricePopupCard> {
  @override AddPricePopupCard get widget => super.widget;
  
  TextEditingController _controllerPrice = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Material(
          color: Colors.blue.shade50,
          elevation: 2,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Enter new item price.'
                    ),
                  const Divider(
                    color: Colors.white,
                    thickness: 0.2,
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: _controllerPrice,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: '0.00',
                      border: InputBorder.none,
                    ),
                    cursorColor: Colors.white,
                    maxLines: 6,
                  ),
                  const Divider(
                    color: Colors.white,
                    thickness: 0.2,
                  ),
                  TextButton(
                    onPressed: () {
                      if (_controllerPrice.text.isEmpty) {
                        Navigator.pop(
                            context, widget.price);
                      } else {
                        Navigator.pop(
                            context, num.parse(_controllerPrice.text));
                      }
                    },
                    child: const Text('Edit'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}