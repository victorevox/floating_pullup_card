import 'package:floating_pullup_card/floating_pullup_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_placeholder_textlines/flutter_placeholder_textlines.dart';

class AdvancedScreen extends StatefulWidget {
  AdvancedScreen({Key? key}) : super(key: key);

  @override
  _AdvancedScreenState createState() => _AdvancedScreenState();
}

class _AdvancedScreenState extends State<AdvancedScreen> {
  FloatingPullUpState _floatingCardState = FloatingPullUpState.collapsed;
  bool _dismissable = false;
  bool _customDragHandle = false;
  bool _customCard = false;
  bool _customCollapsedOffset = false;
  bool _autoPadd = true;
  bool _withOverlay = true;
  bool _customUncollapsedOffset = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Advanced"),
      ),
      body: FloatingPullUpCardLayout(
        dismissable: _dismissable,
        state: _floatingCardState,
        dragHandleBuilder: _customDragHandle ? _customDragHandleBuilder : null,
        cardBuilder: _customCard ? _customCardBuilder : null,
        collpsedStateOffset:
            _customCollapsedOffset ? (maxHeight, _) => maxHeight * .75 : null,
        uncollpsedStateOffset:
            _customUncollapsedOffset ? (maxHeight) => maxHeight * .05 : null,
        autoPadding: _autoPadd,
        withOverlay: _withOverlay,
        body: Container(
          // padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                PlaceholderLines(
                  count: 4,
                  align: TextAlign.center,
                ),
                SizedBox(
                  height: 44,
                ),
                PlaceholderLines(
                  color: Colors.blue,
                  count: 3,
                  align: TextAlign.left,
                ),
                SizedBox(
                  height: 44,
                ),
                PlaceholderLines(
                  color: Colors.purple,
                  count: 4,
                  align: TextAlign.right,
                ),
                SizedBox(
                  height: 44,
                ),
                PlaceholderLines(
                  color: Colors.orange,
                  count: 8,
                  align: TextAlign.center,
                ),
                CupertinoTextField(),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(color: Colors.grey[300]),
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(25),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(10),
                    width: 300,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    width: 300,
                    height: 75,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    width: 300,
                    height: 75,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    width: 300,
                    height: 35,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    width: 300,
                    height: 75,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    width: 300,
                    height: 95,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    width: 300,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    width: 300,
                    height: 75,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    width: 300,
                    height: 75,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Colors.blue,
                          child: Text(
                            "dismissable: $_dismissable",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            setState(() {
                              _dismissable = !_dismissable;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: RaisedButton(
                          color: Colors.blue,
                          child: Text(
                            "Change State: $_floatingCardState",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            setState(() {
                              _floatingCardState = _floatingCardState ==
                                      FloatingPullUpState.hidden
                                  ? FloatingPullUpState.collapsed
                                  : _floatingCardState ==
                                          FloatingPullUpState.collapsed
                                      ? FloatingPullUpState.uncollapsed
                                      : FloatingPullUpState.hidden;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Colors.blue,
                          child: Text(
                            "Custom DragHandle: $_customDragHandle",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            setState(() {
                              _customDragHandle = !_customDragHandle;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: RaisedButton(
                          color: Colors.blue,
                          child: Text(
                            "Custom Card: $_customCard",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            setState(() {
                              _customCard = !_customCard;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Colors.blue,
                          child: Text(
                            "Custom collapsed offset: $_customCollapsedOffset",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            setState(() {
                              _customCollapsedOffset = !_customCollapsedOffset;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: RaisedButton(
                          color: Colors.blue,
                          child: Text(
                            "Autopadding: $_autoPadd",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _autoPadd = !_autoPadd;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: RaisedButton(
                          color: Colors.blue,
                          child: Text(
                            "WithOverlay: $_withOverlay",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _withOverlay = !_withOverlay;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Colors.blue,
                          child: Text(
                            "Custom uncollapsed Offset: $_customUncollapsedOffset",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _customUncollapsedOffset =
                                  !_customUncollapsedOffset;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  DragHandleBuilder _customDragHandleBuilder =
      (context, constraints, beingDragged) {
    return CustomDrag(
      beingDragged: beingDragged,
    );
  };

  FloatingCardBuilder _customCardBuilder =
      (context, constraints, dragHandler, body, beingDragged) {
    return CustomCard(
      dragHandle: dragHandler,
      constraints: constraints,
      body: body,
      beingDragged: beingDragged,
    );
  };
}

class CustomCard extends StatelessWidget {
  final Widget dragHandle;
  final BoxConstraints constraints;
  final Widget body;
  final bool beingDragged;

  const CustomCard({
    Key? key,
    required this.dragHandle,
    required this.constraints,
    required this.beingDragged,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Material(
          elevation: beingDragged ? 6 : 20,
          borderOnForeground: true,
          clipBehavior: Clip.hardEdge,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            width: 300,
            child: dragHandle,
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(bottom: 100),
            child: Material(
              elevation: beingDragged ? 18 : 4,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              child: Container(
                padding: EdgeInsets.all(15),
                width: 300,
                child: body,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomDrag extends StatelessWidget {
  final bool beingDragged;
  const CustomDrag({
    Key? key,
    required this.beingDragged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.easeInCirc,
      duration: Duration(milliseconds: 300),
      padding: EdgeInsets.all(14),
      width: double.infinity,
      decoration: BoxDecoration(
          color: beingDragged ? Colors.purple[400] : Colors.purple[200],
          borderRadius: BorderRadius.circular(15)),
      child: Center(
        child: Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15 / 2),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
