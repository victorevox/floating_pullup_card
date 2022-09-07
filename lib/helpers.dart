import 'package:flutter/material.dart';

class AnchoredOverlay extends StatefulWidget {
  final bool? showOverlay;
  final Offset offset;
  final Widget Function(BuildContext)? overlayBuilder;
  final Widget? child;

  AnchoredOverlay({
    required this.offset,
    this.showOverlay,
    this.overlayBuilder,
    this.child,
  });

  @override
  _AnchoredOverlayState createState() => _AnchoredOverlayState();
}

class _AnchoredOverlayState extends State<AnchoredOverlay> {
  late OverlayController _controller;

  @override
  void initState() {
    super.initState();
    _controller = OverlayController(widget.offset);
  }

  @override
  void didUpdateWidget(covariant AnchoredOverlay oldWidget) {
    if (oldWidget.offset != widget.offset) {
      _controller.value = widget.offset;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Building AnchoredOverlay");
    return Container(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return _OverlayBuilder(
            overlayController: _controller,
            showOverlay: widget.showOverlay,
            overlayBuilder: (BuildContext overlayContext) {
              return widget.overlayBuilder!(overlayContext);
            },
            child: widget.child,
          );
        },
      ),
    );
  }
}

class _OverlayBuilder extends StatefulWidget {
  final bool? showOverlay;
  final Widget Function(BuildContext)? overlayBuilder;
  final Widget? child;
  final OverlayController overlayController;

  _OverlayBuilder({
    this.showOverlay = false,
    this.overlayBuilder,
    this.child,
    required this.overlayController,
  });

  @override
  _OverlayBuilderState createState() => new _OverlayBuilderState();
}

class _OverlayBuilderState extends State<_OverlayBuilder> {
  OverlayEntry? overlayEntry;

  @override
  void initState() {
    super.initState();

    if (widget.showOverlay!) {
      WidgetsBinding.instance.addPostFrameCallback((_) => showOverlay());
    }
  }

  @override
  void didUpdateWidget(_OverlayBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) => syncWidgetAndOverlay());
  }

  @override
  void reassemble() {
    super.reassemble();
    WidgetsBinding.instance.addPostFrameCallback((_) => syncWidgetAndOverlay());
  }

  @override
  void dispose() {
    if (isShowingOverlay()) {
      hideOverlay();
    }

    super.dispose();
  }

  bool isShowingOverlay() => overlayEntry != null;

  void showOverlay() {
    overlayEntry = new OverlayEntry(
      builder: (ctx) {
        return _Overlay(
          overlayController: widget.overlayController,
          builder: widget.overlayBuilder as Widget Function(BuildContext),
        );
      },
    );

    addToOverlay(overlayEntry!);
  }

  void addToOverlay(OverlayEntry entry) async {
    print('addToOverlay');
    Overlay.of(context)!.insert(entry);
  }

  void hideOverlay() {
    print('hideOverlay');
    overlayEntry!.remove();
    overlayEntry = null;
  }

  void syncWidgetAndOverlay() {
    if (isShowingOverlay() && !widget.showOverlay!) {
      hideOverlay();
    } else if (!isShowingOverlay() && widget.showOverlay!) {
      showOverlay();
    } else if (isShowingOverlay() && widget.showOverlay!) {
      overlayEntry?.markNeedsBuild();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child!;
  }
}

class _Overlay extends StatefulWidget {
  final Widget Function(BuildContext context) builder;
  final OverlayController overlayController;

  const _Overlay({
    Key? key,
    required this.builder,
    required this.overlayController,
  }) : super(key: key);

  @override
  __OverlayState createState() => __OverlayState();
}

class __OverlayState extends State<_Overlay> {

  late Offset _offset;

  @override
  void initState() { 
    _offset = widget.overlayController.value;
    widget.overlayController.addListener(() {
      WidgetsBinding.instance.scheduleFrame();
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if(!mounted) return;
        setState(() {
          _offset = widget.overlayController.value;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RenderBox? box = context.findRenderObject() as RenderBox;
      if(box == null) return SizedBox();
      final center = box.size.center(box.localToGlobal(const Offset(0.0, 0.0)));
      // print("center: $_currentOffset, anchor.dy: ${anchor.dy}, offset: ${offset.dy}");
      // final child = builder(context);
      // _CenterAbout(
      //         child: _buildCard(width, height, maxHeight),
      //         position: anchor.translate(
      //           0,
      //           anchor.dy,
      //         ),
      //       );
    return _CenterAbout(
      position: widget.overlayController.value,
      child: widget.builder(context),
    );
  }
}

class _CenterAbout extends StatelessWidget {
  final Offset? position;
  final Widget? child;

  _CenterAbout({
    this.position,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    print("Building positioned");
    return new Positioned(
      top: position!.dy,
      left: position!.dx,
      child: new FractionalTranslation(
        translation: const Offset(0, 0),
        child: child,
      ),
    );
  }
}

class OverlayController extends ValueNotifier<Offset> {
  OverlayController(Offset value) : super(value);
}
