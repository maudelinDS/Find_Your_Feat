import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

class Mysql {
  static String host = 'www.delescaut.ch',
      user = 'mds_admin_db',
      password = 'm4u23L1n2022',
      db = 'mds_db';

  static int port = 3306;

  Mysql();

  Future<MySqlConnection> getConnection() async {
    var settings = ConnectionSettings(
        host: host, port: port, user: user, password: password, db: db);
    return await MySqlConnection.connect(settings);
  }
}

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  int _counter = 0;
  var db = Mysql();
  var email = '';

  void _getCustomer() {
    db.getConnection().then((conn) async {
      String sql = 'SELECT email FROM users ;';
      conn.query(sql).then((results) {
        for (var row in results) {
          setState(() {
            email = row[0];
          });
        }
      });
      await conn.close();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        backgroundColor: Colors.red,
        appBar: AppBar(
          title: Text('Flutter Demo Home Page'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'mail: $email',
              ),
              Text(
                '$email',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _getCustomer,
          tooltip: 'Incrémenter',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
