import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: "assets/.env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo v1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var items = [];

  @override
  void initState() { 
    refreshUsers();
    super.initState();
  }

  Future refreshUsers() async {
    Uri uri = Uri.parse('${dotenv.env['API_URL']}/users');
    final response = await http.get(uri);
    var data = json.decode(response.body);
    this.items = [];
    setState(() {
      for (var i = 0; i < data.length; i ++) {
        this.items.add(data[i]['name']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refreshUsers,
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('${items[index]}'),
            );
          }
        ),
      )
    );
    
  }
}
