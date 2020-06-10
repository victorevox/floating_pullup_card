import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'animated_scale.dart';

typedef DragHandleBuilder = Widget Function(
  BuildContext context,
  BoxConstraints constraints,
  bool beingDragged,
);

typedef FloatingCardBuilder = Widget Function(
  BuildContext context,
  BoxConstraints constraints,
  Widget dragHandler,
  Widget body,
  bool beingDragged,
);

class FloatingPullUpCard extends StatefulWidget {
  final double height;
  final double width;
  final Color cardColor;
  final Widget child;
  final GestureDragUpdateCallback onDrag;
  final GestureDragEndCallback onDragEnd;
  final double elevation;
  final BorderRadius borderRadius;
  final FloatingCardBuilder cardBuilder;
  final DragHandleBuilder dragHandlebuilder;
  // final ValueChanged<bool> onDragChange;

  const FloatingPullUpCard({
    Key key,
    this.cardBuilder,
    this.cardColor = Colors.white,
    this.height,
    this.width,
    this.borderRadius,
    @required this.child,
    @required this.onDrag,
    @required this.onDragEnd,
    this.elevation = 4,
    this.dragHandlebuilder,
    // this.onDragChange,
  }) : super(key: key);

  @override
  _FloatingPullUpCardState createState() => _FloatingPullUpCardState();
}

class _FloatingPullUpCardState extends State<FloatingPullUpCard> {
  bool _beingDragged;

  @override
  void initState() {
    _beingDragged = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return widget.cardBuilder != null
            ? Container(
                width: widget.width,
                height: widget.height,
                child: widget.cardBuilder(
                  context,
                  constraints,
                  _buildDragHandle(constraints),
                  widget.child,
                  _beingDragged,
                ),
              )
            : _defaultCardBuilder(
                context,
                constraints,
                _buildDragHandle(constraints),
                widget.child,
                widget.cardColor,
                widget.elevation,
                widget.width,
                widget.height,
                widget.borderRadius,
                _beingDragged,
              );
      },
    );
  }

  Widget _buildDragHandle(BoxConstraints constraints) {
    return Container(
      child: GestureDetector(
        dragStartBehavior: DragStartBehavior.start,
        onVerticalDragUpdate: widget.onDrag,
        onVerticalDragEnd: (details) {
          widget?.onDragEnd(details);
          _setDragState(false);
        },
        onVerticalDragStart: (_) {
          _setDragState(true);
        },
        onVerticalDragCancel: () {
          _setDragState(false);
        },
        onTapUp: (_) {
          _setDragState(false);
        },
        onTapDown: (_) {
          _setDragState(true);
        },
        child: widget.dragHandlebuilder != null
            ? widget.dragHandlebuilder(context, constraints, _beingDragged)
            : _defaultDragHandleBuilder(
                context,
                constraints,
                widget.borderRadius,
                _beingDragged,
              ),
      ),
    );
  }

  _setDragState(bool state) {
    setState(() {
      _beingDragged = state;
    });
  }
}

Widget _defaultCardBuilder(
  BuildContext context,
  BoxConstraints constraints,
  Widget handler,
  Widget child,
  Color cardColor,
  double cardElevation,
  double defaultWidth,
  double defaultHeight,
  BorderRadius borderRadius,
  bool beingDragged,
) {
  // print("Building card ${Random().nextDouble()} $beingDragged");
  return Material(
    borderRadius: borderRadius,
    elevation: beingDragged ? cardElevation + 8 : cardElevation,
    color: cardColor,
    borderOnForeground: true,
    child: Container(
      width: defaultWidth,
      height: defaultHeight,
      child: Column(
        children: <Widget>[
          handler,
          Expanded(
            child: child,
          ),
        ],
      ),
    ),
  );
}

_defaultDragHandleBuilder(
  BuildContext context,
  BoxConstraints constraints,
  BorderRadius borderRadius,
  bool beingDragged,
) {
  return Container(
    width: constraints.maxWidth,
    padding: EdgeInsets.symmetric(vertical: 10),
    decoration: BoxDecoration(
      borderRadius: borderRadius,
    ),
    child: Center(
      child: AnimatedScale(
        curve: Curves.linear,
        duration: Duration(milliseconds: 350),
        scale: beingDragged ? 1.2 : 1,
        child: Container(
          height: 5,
          width: 49,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),
        ),
      ),
    ),
  );
}
