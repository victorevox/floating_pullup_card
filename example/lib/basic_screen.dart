import 'package:floating_pullup_card/floating_pullup_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_placeholder_textlines/placeholder_lines.dart';

class BasicScreen extends StatelessWidget {
  const BasicScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("basic"),
      ),
      body: FloatingPullUpCardLayout(
        child: Container(
          decoration: BoxDecoration(color: Colors.purple[100]),
          child: Placeholder(),
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
