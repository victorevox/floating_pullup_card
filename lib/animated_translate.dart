
import 'package:flutter/widgets.dart';

class AnimatedTranslation extends ImplicitlyAnimatedWidget {
  /// Creates a widget that insets its child by a value that animates
  /// implicitly.
  ///
  /// The [offset], [curve], and [duration] arguments must not be null.
  AnimatedTranslation({
    Key key,
    @required this.offset,
    this.child,
    Curve curve = Curves.linear,
    @required Duration duration,
    VoidCallback onEnd,
  })  : assert(offset != null),
        super(key: key, curve: curve, duration: duration, onEnd: onEnd);

  /// The amount of space by which to inset the child.
  final double offset;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  @override
  _AnimatedTranslateState createState() => _AnimatedTranslateState();

}

class _AnimatedTranslateState
    extends AnimatedWidgetBaseState<AnimatedTranslation> {
  Tween _offset;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _offset = visitor(
      _offset,
      widget.offset,
      (dynamic value) {
        return Tween(begin: value, end: widget.offset);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, _offset.evaluate(animation)),
      child: widget.child,
    );
  }

}
