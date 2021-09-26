import 'package:h_manage/data.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

// TODO: Update server model request regarding format (DECIMAL(10,2))

class ServerRequest {
  static String _host = 'http://192.168.1.134:8888/';
  // Request to obtain all tables
  static Future<List<Tablee>> fetchTables(http.Client client) async {
    print('Doing the table fetchFunction');
    final response = await client.get(Uri.parse(_host + 'tables'));

    // Using the compute function to run parseTables in a separate isolate
    return compute(parseTables, response.body);
  }

  static List<Tablee> parseTables(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Tablee>((json) => Tablee.fromJson(json)).toList();
  }

  // Function that retrieves all the products from the server
  static Future<List<Product>> fetchProducts(http.Client client) async {
    print('Doing a products fetchFunction');
    final response = await client.get(Uri.parse(_host + 'products'));

    // Using the compute function to run parseProducts in a separate isolate
    return compute(parseProducts, response.body);
  }

  // Function that converts a response body into a List<Product>
  static List<Product> parseProducts(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Product>((json) => Product.fromJson(json)).toList();
  }

  static updateProduct(
      int id,
      String product,
      String price,
      String category) async {
    final response = await http.put(
        Uri.parse(_host + 'products/' + id.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'productId': id,
        'name': product,
        'price': price,
        'category': category,
      }),
    );

    if (response.statusCode != 200)
      throw Exception('Failed to update product $product');
  }

  static Future<Tbill> createTbill(
      int tnumber, String item, int units, String iprice, String total) async {
    final response = await http.post(
      Uri.parse(_host + 'tbills'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'tnumber': tnumber,
        'item': item,
        'units': units,
        'iprice': iprice,
        'total': total,
      }),
    );

    if (response.statusCode == 200) {
      return Tbill.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create tbill');
    }
  }

  static Future<List<Tbill>> fetchTbills(http.Client client) async {
    final response = await client.get(Uri.parse(_host + 'tbills/'));
    return compute(parseTbills, response.body);
  }

  static List<Tbill> parseTbills(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    print(responseBody.toString());
    return parsed.map<Tbill>((json) => Tbill.fromJson(json)).toList();
  }

  static updateTbill(
      int tbillId,
      int? tnumber,
      String item,
      int units,
      String iprice,
      String total) async {
    final response = await http.put(
        Uri.parse(_host + "tbills/" + tbillId.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      body: jsonEncode(<String, dynamic>{
        'tbillId': tbillId,
        'tnumber': tnumber,
        'item': item,
        'units': units,
        'iprice': iprice,
        'total': total,
      }),
    );

    if (response.statusCode != 200)
      throw Exception('Failed to update tbill');
  }

  static Future<List<Tbill>> fetchTableTbills(
      http.Client client, String table) async {
    final response = await client.get(Uri.parse(_host + 'tbills/' + table));
    if (response.statusCode == 404) {
      return [];
    }
    return compute(parseTbills, response.body);
  }

  static Future<List<Tbill>> newfetchTableTbills(String table) async {
    final response = await http.get(Uri.parse(_host + 'tbills/' + table));
    if (response.statusCode == 404) {
      return [];
    }
    return compute(parseTbills, response.body);
  }

  static Future createCashCount() async {
    final response = await http.post(Uri.parse(_host + 'cash_counts'));

    if (response.statusCode != 200)
      throw Exception('Failed to create cash count');
  }

  static Future<CashCount> updateCashCount(
      String? netSale,
      String? cardPayments,
      String? cashPayments,
      int? numberSales,
      String? averageTicket,
      String? income,
      String? outflow,
      String day) async {
    final response = await http.put(
      Uri.parse(_host + 'cash_counts/' + day),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'netSale': netSale,
        'cardPayments': cardPayments,
        'cashPayments': cashPayments,
        'numberSales': numberSales,
        'averageTicket': averageTicket,
        'income': income,
        'outflow': outflow,
        'day': day,
      }),
    );

    if (response.statusCode == 200) {
      return CashCount.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update CashCount');
    }
  }

  static Future deleteTbill(String tnumber) async{
    final response = await http.delete(Uri.parse(_host + 'tbills/' + tnumber));
    if (response.statusCode != 200)
      throw Exception('Failed to Delete tbillls');
  }

  static Future updateTable(int number, String total,) async {
    final response = await http.put(
      Uri.parse(_host + 'tables/' + number.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'number': number,
        'total': total,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update Table');
    }
  }
}

