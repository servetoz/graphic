import 'dart:ui';

import 'package:flutter/painting.dart';
import 'package:graphic/src/chart/view.dart';
import 'package:graphic/src/common/operators/value.dart';
import 'package:graphic/src/interaction/signal.dart';
import 'package:graphic/src/parse/parse.dart';
import 'package:graphic/src/parse/spec.dart';

/// The signal emitted when chart size changes.
class ResizeSignal extends Signal {
  /// Creates a resize signal.
  ResizeSignal(this.size);

  @override
  SignalType get type => SignalType.resize;

  /// New size of chart.
  final Size size;
}

class SizeOp extends Value<Size> {
  SizeOp(Size value) : super(value);
}

void parseSize(
  Spec spec,
  View view,
  Scope scope,
) {
  scope.size = view.add(SizeOp(view.size));

  view.listen<ResizeSignal, Size>(
    view.sizeSouce,
    scope.size,
    (signal) => signal.size,
  );
}
