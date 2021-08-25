import 'package:h_manage/route_generator.dart';
// import 'package:h_manage/data.dart';
// import 'package:h_manage/pages/fifth_page.dart';
//
// import 'dart:async';
// import 'dart:convert';
//a
// import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';





void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'PLACEHOLDER 1';

    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}





