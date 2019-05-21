import 'dart:io';
import 'dart:async';

import 'package:disco_app/web_server.dart';
import 'package:flutter/material.dart';
import 'package:disco_app/database_helper.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() {
    // _startWebServer();
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Disco App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // reference to our single class that manages the database
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final dbHelper = DatabaseHelper.instance;
  Future<AngelHttp> http;

  String queryId;
  String insertId;
  String insertName;
  String insertSecret;
  String updateId;
  String updateName;
  String updateSecret;
  String deleteId;
  String displayString = 'nothing';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Disco'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    setState(() {
                      http = startWebServer();
                      print(http);
                    });
                    return http;
                  },
                  child: Text('Start server'),
                ),
                RaisedButton(
                  child: Text('Close server'),
                  onPressed: () {
                    // print(http);
                    closeWebServer(http);
                  },
                ),
              ],
            ),
            Container(
              color: Colors.red,
              child: Column(
                children: <Widget>[
                  RaisedButton(
                    child: Text(
                      'Insert',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      _insert(insertId, insertName, insertSecret);
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('client_id'),
                      Container(
                        child: TextField(
                          onChanged: (t) {
                            setState(() {
                              insertId = t;
                            });
                          },
                        ),
                        width: 40.0,
                      ),
                      Text('client_name'),
                      Container(
                        child: TextField(
                          onChanged: (t) {
                            setState(() {
                              insertName = t;
                            });
                          },
                        ),
                        width: 40.0,
                      ),
                      Text('client_secret'),
                      Container(
                          child: TextField(
                            onChanged: (t) {
                              setState(() {
                                insertSecret = t;
                              });
                            },
                          ),
                          width: 40.0),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.orange,
              child: Row(
                children: <Widget>[
                  RaisedButton(
                    child: Text(
                      'Query',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () async {
                      print('query $queryId');
                      var res = await dbHelper.queryAllRows();
                      res.forEach((row) => print(row));
                      _query(queryId);
                    },
                  ),
                  Text('client_id'),
                  Container(
                    child: TextField(
                      onChanged: (t) {
                        queryId = t;
                      },
                    ),
                    width: 100.0,
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.red,
              child: Column(
                children: <Widget>[
                  RaisedButton(
                    child: Text(
                      'Update by client_id',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      _update(updateId, updateName, updateSecret);
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('client_id'),
                      Container(
                        child: TextField(
                          onChanged: (t) {
                            setState(() {
                              updateId = t;
                            });
                          },
                        ),
                        width: 40.0,
                      ),
                      Text('client_name'),
                      Container(
                        child: TextField(
                          onChanged: (t) {
                            setState(() {
                              updateName = t;
                            });
                          },
                        ),
                        width: 40.0,
                      ),
                      Text('client_secret'),
                      Container(
                          child: TextField(
                            onChanged: (t) {
                              setState(() {
                                updateSecret = t;
                              });
                            },
                          ),
                          width: 40.0),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.greenAccent,
              child: Row(
                children: <Widget>[
                  RaisedButton(
                    child: Text(
                      'Delete',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      _delete(deleteId);
                    },
                  ),
                  Text('client_id'),
                  Container(
                    child: TextField(
                      onChanged: (t) {
                        setState(() {
                          deleteId = t;
                        });
                      },
                    ),
                    width: 100.0,
                  ),
                ],
              ),
            ),
            Text(displayString),
          ],
        ),
      ),
    );
  }

  int clientCount = 0;

  void _insert(String cid, String name, String secret) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.clientId: cid,
      DatabaseHelper.clientName: name,
      DatabaseHelper.clientSecret: secret
    };
    clientCount++;
    final id = await dbHelper.insert(row);
    setState(() {
      displayString = 'inserted row id: $id';
    });
  }

  void _query(String id) async {
    final res = await dbHelper.queryClientId(id);
    res.forEach((row) => print(row));
    setState(() {
      displayString = res.toString();
    });
  }

  void _update(String id, String name, String secret) async {
    // row to update
    Map<String, dynamic> row = {
      DatabaseHelper.clientId: id,
      DatabaseHelper.clientName: name,
      DatabaseHelper.clientSecret: secret
    };
    final rowsAffected = await dbHelper.update(row);
    setState(() {
      displayString = 'updated $rowsAffected row(s)';
    });
  }

  void _delete(String id) async {
    final rowsDeleted = await dbHelper.delete(id);
    setState(() {
      displayString = 'deleted $rowsDeleted row(s): row $id';
    });
  }
}
