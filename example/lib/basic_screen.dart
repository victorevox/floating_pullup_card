import 'package:floating_pullup_card/floating_pullup_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_placeholder_textlines/flutter_placeholder_textlines.dart';

class BasicScreen extends StatelessWidget {
  const BasicScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("basic"),
      ),
      body: FloatingPullUpCardLayout(
        onOutsideTap: () {
          return FloatingPullUpState.collapsed;
        },
        child: Container(
          decoration: BoxDecoration(color: Colors.purple[100]),
          child: Center(
            child: MaterialButton(
              color: Colors.orange,
              onPressed: () {
                print("hello");
              },
              child: Text("tap!"),
            ),
          ),
        ),
        body: Column(
          children: <Widget>[
            PlaceholderLines(
              count: 10,
              align: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
