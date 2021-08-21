import 'package:flutter/material.dart';
import 'package:h_manage/data.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

// A function that creates a new user in the database
Future<User> createUser(
    String login, String name, String email, String passwd) async {
  final response = await http.post(
    Uri.parse('http://192.168.1.134:8888/users'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'login': login,
      'name': name,
      'email': email,
      'passwd': passwd,
    }),
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response, then parse the JSON
    return User.fromJson(jsonDecode(response.body));
  } else {
    // If not, then throw an exception
    throw Exception('Failed to create user');
  }
}

class FourthPage extends StatefulWidget {
  const FourthPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _FourthPageState createState() {
    return _FourthPageState();
  }
}

class _FourthPageState extends State<FourthPage> {
  final TextEditingController _controllerLogin = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPasswd = TextEditingController();
  Future<User>? _futureUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create User '),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 20,
          vertical: MediaQuery.of(context).size.width / 20,
        ),
        child: (_futureUser == null) ? buildColumn() : buildFutureBuilder(),
      ),
    );
  }

  Column buildColumn() {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        TextField(
          textAlign: TextAlign.center,
          textCapitalization: TextCapitalization.sentences,
          controller: _controllerLogin,
          decoration: const InputDecoration(hintText: 'Enter login'),
        ),
        TextField(
          textAlign: TextAlign.center,
          textCapitalization: TextCapitalization.sentences,
          controller: _controllerName,
          decoration: const InputDecoration(hintText: 'Enter name'),
        ),
        TextField(
          textAlign: TextAlign.center,
          controller: _controllerEmail,
          decoration: const InputDecoration(hintText: 'Enter email'),
        ),
        TextField(
          textAlign: TextAlign.center,
          controller: _controllerPasswd,
          decoration: const InputDecoration(hintText: 'Enter passwd'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _futureUser = createUser(
                _controllerLogin.text,
                _controllerName.text,
                _controllerEmail.text,
                _controllerPasswd.text,
              );
            });
          },
          child: const Text('Create User'),
        ),
      ],
    );
  }

  FutureBuilder<User> buildFutureBuilder() {
    return FutureBuilder<User>(
      future: _futureUser,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(snapshot.data!.login),
              Text(snapshot.data!.name),
              Text(snapshot.data!.email),
            ],
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );
  }
}