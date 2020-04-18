import 'package:flutter/widgets.dart';

import 'package:floating_pullup_card/animated_translate.dart';
import 'package:floating_pullup_card/floating_pullup_card.dart';

import 'types.dart';

class FloatingPullUpCardLayout extends StatefulWidget {
  /// The [Widget] to be used as the content of the main layout, not the card content
  final Widget child;

  /// The [Widget] to be used as the content of the floating card
  final Widget body;

  /// Set a custom [height] for the floating card,
  /// defaults to `86%` of total height of parent container or screen height if no finite height can be assumed
  final double height;

  /// Set a custom [width] for the floating card,
  /// defaults to `100%` of total width of parent container or screen width if no finite width can be assumed
  final double width;

  /// Set a [cardElevation] for the material,
  /// defaults to `4`
  final double cardElevation;

  /// If true , the card can be dragged until it's hidden from screen
  /// defaults to [false]
  final bool dismissable;

  /// Sets the [state] of the floating card,
  /// See enum [FloatingPullUpState] for more details
  /// Defaults to [FloatingPullUpState.collapsed]
  final FloatingPullUpState state;

  /// Set a custom card [color] to the card background
  /// defaults to [Colors.white]
  ///
  /// This doesnt take any effect if using [cardBuilder] is defined
  final Color cardColor;

  /// Called each time the [FloatingPullUpState] is changed
  final ValueChanged<FloatingPullUpState> onStateChange;

  /// Defines a custom [dragHandleBuilder]
  final DragHandleBuilder dragHandleBuilder;

  /// Defines a custom [cardBuilder]
  final FloatingCardBuilder cardBuilder;

  /// Set a custom [borderRadius] of the default Card material
  ///
  /// This doesnt take any effect if using [cardBuilder] is defined
  final BorderRadius borderRadius;

  /// if true , this automatically adds padding to the [child] container,
  /// avoiding the card to float on top of [child] content
  /// defaults to [true]
  final autoPadding;

  /// Sets a custom function that return a custom `Y Offset`  for state [FloatingPullUpState.collapsed]
  /// Please take into account that offset start from top to bottom
  StateOffsetFunction collpsedStateOffset;

  /// Sets a custom function that return a custom `Y Offset`  for state [FloatingPullUpState.hidden]
  /// Please take into account that offset start from top to bottom
  StateOffsetFunction hiddenStateOffset;

  /// Sets a custom function that return a custom `Y Offset`  for state [FloatingPullUpState.uncollapsed]
  /// Please take into account that offset start from top to bottom
  StateOffsetFunction uncollpsedStateOffset;

  /// Defines a callback to be called when a user taps outside the card
  /// If function returns [FloatingPullUpState] it will change state to the returned one
  /// Take into account that this is not getting called if a widget inside body is already handling a `Gesture`
  final FloatingPullUpState Function() onOutsideTap;

  /// If true, this will show an overlay behind the card tht obscures content behind
  /// Defaults to[false]
  final bool withOverlay;

  /// Defines the `color` of the overlay , this only takes effect of [withOverlayOption] is true
  final Color overlayColor;

  FloatingPullUpCardLayout({
    Key key,
    @required this.child,
    @required this.body,
    this.height,
    this.width,
    this.cardElevation = 4,
    this.dismissable = false,
    this.state = FloatingPullUpState.collapsed,
    this.onStateChange,
    this.dragHandleBuilder,
    this.cardColor = const Color(0xFFFFFFFF),
    this.cardBuilder,
    this.borderRadius = const BorderRadius.only(
      topLeft: Radius.circular(16),
      topRight: Radius.circular(16),
    ),
    StateOffsetFunction collpsedStateOffset,
    StateOffsetFunction hiddenStateOffset,
    StateOffsetFunction uncollpsedStateOffset,
    this.autoPadding = true,
    this.onOutsideTap,
    this.withOverlay = false,
    this.overlayColor = const Color(0x66000000),
  }) : super(key: key) {
    this.collpsedStateOffset =
        collpsedStateOffset ?? this._defaultCollpsedStateOffset;
    this.hiddenStateOffset =
        hiddenStateOffset ?? this._defaultHiddenStateOffset;
    this.uncollpsedStateOffset =
        uncollpsedStateOffset ?? this._defaultUncollapsedStateOffset;
    final double maxHeightTest = 10000;
    final double cardHeightTest = 8000;
    assert(
      this.uncollpsedStateOffset(maxHeightTest, cardHeightTest) <
          this.collpsedStateOffset(maxHeightTest, cardHeightTest),
    );
    assert(
      this.collpsedStateOffset(maxHeightTest, cardHeightTest) <
          this.hiddenStateOffset(maxHeightTest, cardHeightTest),
    );
  }

  final StateOffsetFunction _defaultCollpsedStateOffset =
      (double maxHeight, _) {
    return maxHeight - (maxHeight * (0.1));
  };

  final StateOffsetFunction _defaultHiddenStateOffset = (double maxHeight, _) {
    return maxHeight;
  };

  final StateOffsetFunction _defaultUncollapsedStateOffset =
      (double maxHeight, double cardHeight) {
    return maxHeight - cardHeight;
  };

  @override
  _FloatingPullUpCardLayoutState createState() =>
      _FloatingPullUpCardLayoutState();
}

class _FloatingPullUpCardLayoutState extends State<FloatingPullUpCardLayout> {
  double _currentOffset;
  Widget _cardWidget;
  bool _beingDragged = false;
  bool _firstStateSet = false;

  BoxConstraints _latestConstraints;

  Map<FloatingPullUpState, double> _stateOffsets;
  FloatingPullUpState _currentState;

  @override
  void initState() {
    super.initState();
    // _currentOffset;
    if (widget.state == null) {
      _currentState = FloatingPullUpState.collapsed;
    } else {
      _currentState = widget.state;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _setStateOffset(_currentState);
        _firstStateSet = true;
        // Future.delayed(Duration(milliseconds: 250)).then((_) {
        //   setState(() {
        //   });
        // });
      });
    });
  }

  @override
  void didUpdateWidget(FloatingPullUpCardLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state && widget.state != null ||
        oldWidget.collpsedStateOffset != null &&
            oldWidget.collpsedStateOffset(2, 1) !=
                widget.collpsedStateOffset(2, 1)) {
      _currentState = widget.state;
      _setStateOffset(widget.state);
    }
  }

  FloatingPullUpCard _buildCard(double width, double height, double maxHeight) {
    return FloatingPullUpCard(
      width: width,
      height: height,
      elevation: widget.cardElevation,
      dragHandlebuilder: widget.dragHandleBuilder,
      cardColor: widget.cardColor,
      cardBuilder: widget.cardBuilder,
      borderRadius: widget.borderRadius,
      onDrag: (dragDetails) {
        setState(() {
          _beingDragged = true;
          final double newOffset = _currentOffset + dragDetails.delta.dy;
          final double maxOffset =
              _getMaxOffset(maxHeight, _stateOffsets, widget.dismissable);
          final double minOffset = _getMinOffset(maxHeight, height);
          _currentOffset = newOffset < (minOffset)
              ? minOffset
              : newOffset > maxOffset ? maxOffset : newOffset;
        });
      },
      onDragEnd: (dragDetails) {
        final double vel = dragDetails.velocity.pixelsPerSecond.dy;
        FloatingPullUpState state;
        setState(() {
          _beingDragged = false;
          bool pullingUp = false;
          bool pullingDown = false;
          if (vel < -700) {
            pullingUp = true;
          } else if (vel > 700) {
            pullingDown = true;
          }

          final double collapsedOffset =
              _stateOffsets[FloatingPullUpState.collapsed];
          if (((_currentOffset < collapsedOffset / 2) && !pullingDown) ||
              pullingUp) {
            state = FloatingPullUpState.uncollapsed;
          } else if ((_currentOffset < collapsedOffset) ||
              (pullingDown && _currentOffset < collapsedOffset)) {
            state = FloatingPullUpState.collapsed;
          } else if (widget.dismissable) {
            state = FloatingPullUpState.hidden;
          } else {
            state = FloatingPullUpState.collapsed;
          }

          _setStateOffset(state);
        });
      },
      child: widget.body,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_currentOffset == null) {
      _currentOffset = MediaQuery.of(context).size.height;
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        if (_latestConstraints != null &&
            (_latestConstraints.maxHeight != constraints.maxHeight ||
                _latestConstraints.maxWidth != constraints.maxWidth)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _setStateOffset(_currentState);
              });
            }
          });
        }
        _latestConstraints = constraints;
        final double maxWidth =
            _getMaxWidthFromConstraintsOrContext(context, constraints);
        final double maxHeight =
            _getMaxHeightFromConstraintsOrContext(context, constraints);
        final double height = widget.height ?? maxHeight * .86;
        final double width = widget.width ?? maxWidth;
        _stateOffsets = {
          FloatingPullUpState.collapsed:
              widget.collpsedStateOffset(maxHeight, height),
          FloatingPullUpState.uncollapsed:
              widget.uncollpsedStateOffset(maxHeight, height),
          FloatingPullUpState.hidden:
              widget.hiddenStateOffset(maxHeight, height),
        };
        _cardWidget = _buildCard(width, height, maxHeight);

        final double dif =
            _stateOffsets[FloatingPullUpState.collapsed] - _currentOffset;
        double beyondCollapseStateOffset = dif < 0 ? dif.abs() : 0;
        final double bottomPadding = widget.autoPadding
            ? _beingDragged
                ? (maxHeight - _stateOffsets[FloatingPullUpState.collapsed]) -
                    beyondCollapseStateOffset
                : _currentState != FloatingPullUpState.uncollapsed
                    ? (maxHeight - _stateOffsets[_currentState])
                    : 0
            : 0;
        // print(
        //     "beyondCollapseStateOffset: $beyondCollapseStateOffset, bottomPadding: $bottomPadding, currentState: $_currentState");
        return Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (widget.onOutsideTap != null) {
                  final FloatingPullUpState res = widget.onOutsideTap();
                  if (res != null) {
                    setState(() {
                      _setStateOffset(res);
                    });
                  }
                }
              },
              child: Container(
                // width: maxWidth,
                // decoration: BoxDecoration(color: Colors.red),
                padding: EdgeInsets.only(
                  bottom: bottomPadding,
                ),
                constraints: constraints,
                child: widget.child,
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              child: AnimatedOverlay(
                show: _currentState == FloatingPullUpState.uncollapsed &&
                    widget.withOverlay,
                constraints: constraints,
                color: widget.overlayColor,
              ),
            ),
            Positioned(
              top: 0,
              child: AnimatedTranslation(
                curve: Curves.decelerate,
                duration: Duration(milliseconds: 350),
                offset: _currentOffset,
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 280),
                  opacity: _firstStateSet ? 1 : 0,
                  child: _cardWidget,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _setStateOffset(FloatingPullUpState currentState) {
    _currentState = currentState;
    _currentOffset = _stateOffsets[currentState];
    if (widget.onStateChange != null) {
      widget.onStateChange(_currentState);
    }
  }
}

class AnimatedOverlay extends StatefulWidget {
  final BoxConstraints constraints;
  final bool show;
  final Color color;

  const AnimatedOverlay({
    Key key,
    @required this.constraints,
    @required this.show,
    this.color = const Color(0x66000000),
  }) : super(key: key);

  @override
  _AnimatedOverlayState createState() => _AnimatedOverlayState();
}

class _AnimatedOverlayState extends State<AnimatedOverlay> {
  bool _init = false;
  bool _animationEnd = true;

  @override
  void initState() {
    // s
    super.initState();
  }

  @override
  void didUpdateWidget(AnimatedOverlay oldWidget) {
    if (oldWidget.show != widget.show) {
      _animationEnd = false;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (!_init && widget.show) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {
          _init = true;
        });
      });
    }
    return _animationEnd && !widget.show
        ? SizedBox()
        : AnimatedContainer(
            curve: Curves.fastOutSlowIn,
            onEnd: () {
              // if(_animationEnd && _init) {
              setState(() {
                _animationEnd = true;
                if (!widget.show) {
                  _init = false;
                }
              });
              // }
            },
            duration: Duration(milliseconds: 600),
            width: widget.constraints.maxWidth,
            height: widget.constraints.maxHeight,
            color:
                !_init || !widget.show ? const Color(0x00000000) : widget.color,
          );
  }
}

double _getMaxOffset(double maxHeight,
    Map<FloatingPullUpState, double> stateOffsets, bool canBeHidden) {
  return canBeHidden ? maxHeight : stateOffsets[FloatingPullUpState.collapsed];
}

double _getMinOffset(double maxHeight, double height) {
  return maxHeight - height;
}

double _getMaxWidthFromConstraintsOrContext(
    BuildContext context, BoxConstraints constraints) {
  return constraints.maxWidth != double.infinity
      ? constraints.maxWidth
      : MediaQuery.of(context).size.width;
}

double _getMaxHeightFromConstraintsOrContext(
    BuildContext context, BoxConstraints constraints) {
  return constraints.maxHeight != double.infinity
      ? constraints.maxHeight
      : MediaQuery.of(context).size.height;
}
