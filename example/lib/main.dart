import 'package:flutter/material.dart';
import 'basic_screen.dart';
import 'advanced_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text("Basic Example"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return BasicScreen();
                }));
              },
            ),
            RaisedButton(
              child: Text("Advanced Example"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return AdvancedScreen();
                }));
              },
            ),
          ],
        ),
      ),
    );
  }
}
