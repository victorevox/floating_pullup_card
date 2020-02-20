part of floating_layout;


typedef StateOffsetFunction = double Function(
  double maxHeight,
  double cardHeight,
);

enum FloatingPullUpState { collapsed, hidden, uncollapsed }