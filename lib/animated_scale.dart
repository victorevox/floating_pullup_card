import 'package:flutter/widgets.dart';

class AnimatedScale extends ImplicitlyAnimatedWidget {
  /// Creates a widget that insets its child by a value that animates
  /// implicitly.
  ///
  /// The [scale], [curve], and [duration] arguments must not be null.
  AnimatedScale({
    Key? key,
    required this.scale,
    this.child,
    Curve curve = Curves.linear,
    required Duration duration,
    VoidCallback? onEnd,
  }) : super(
          key: key,
          curve: curve,
          duration: duration,
          onEnd: onEnd,
        );

  /// The amount of space by which to inset the child.
  final double scale;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget? child;

  @override
  _AnimatedScaleState createState() => _AnimatedScaleState();
}

class _AnimatedScaleState extends AnimatedWidgetBaseState<AnimatedScale> {
  Tween? _scale;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: _scale!.evaluate(animation) as double,
      child: widget.child,
    );
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _scale = visitor(_scale, widget.scale, (dynamic value) {
      return Tween(begin: value, end: widget.scale);
    });
  }
}
