import 'package:h_manage/data.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ServerRequest{
  // Request to obtain all tables
  static Future<List<Tablee>> fetchTables(http.Client client) async {
    print('Doing the table fetchFunction');
    final response =
        await client.get(Uri.parse('http://192.168.1.134:8888/tables'));

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
    final response =
    await client.get(Uri.parse('http://192.168.1.134:8888/products'));

    // Using the compute function to run parseProducts in a separate isolate
    return compute(parseProducts, response.body);
  }

  // Function that converts a response body into a List<Product>
  static List<Product> parseProducts(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Product>((json) => Product.fromJson(json)).toList();
  }
}