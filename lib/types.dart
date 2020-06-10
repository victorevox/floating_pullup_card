typedef StateOffsetFunction = double Function(
  double maxHeight,
  double cardHeight,
);

typedef UncollapsedStateOffsetFunction = double Function(
  double maxHeight,
);

enum FloatingPullUpState { collapsed, hidden, uncollapsed }