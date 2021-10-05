import 'package:graphic/src/dataflow/tuple.dart';

import 'continuous.dart';

class TimeScale extends ContinuousScale<DateTime> {
  TimeScale({
    DateTime? min,
    DateTime? max,
    double? marginMin,
    double? marginMax,

    String? title,
    String Function(DateTime)? formatter,
    List<DateTime>? ticks,
    int? tickCount,
    int? maxTickCount,
  }) : super(
    min: min,
    max: max,
    marginMin: marginMin,
    marginMax: marginMax,
    title: title,
    formatter: formatter,
    ticks: ticks,
    tickCount: tickCount,
    maxTickCount: maxTickCount,
  );
}

DateTime _later(DateTime a, DateTime b) =>
  a.isAfter(b) ? a : b;

DateTime _earlier(DateTime a, DateTime b) =>
  a.isBefore(b) ? a : b;

class TimeScaleConv extends ContinuousScaleConv<DateTime> {
  TimeScaleConv(
    TimeScale spec,
    List<Original> tuples,
    String variable,
  ) {
    // min, max
    if (spec.min != null && spec.max != null) {
      min = spec.min;
      max = spec.max;
    } else {
      var minTmp = tuples.first[variable] as DateTime;
      var maxTmp = minTmp;
      for (var tuple in tuples) {
        final value = tuple[variable] as DateTime;
        minTmp = _earlier(minTmp, value);
        maxTmp = _later(maxTmp, value);
      }

      final range = maxTmp.difference(minTmp);
      final marginMin = range * (spec.marginMin ?? 0.1);  // TODO: default
      final marginMax = range * (spec.marginMax ?? 0.1);  // TODO: default
      min = min ?? minTmp.subtract(marginMin);
      max = max ?? maxTmp.add(marginMax);
    }

    // ticks
    if (spec.ticks != null) {
      ticks = spec.ticks!;
    } else {
      final minMicro = min!.microsecondsSinceEpoch;
      final maxMicro = max!.microsecondsSinceEpoch;
      final count = spec.tickCount ?? spec.maxTickCount ?? 5;
      final step = (maxMicro - minMicro) ~/ (count - 1);

      ticks = [];
      ticks.add(min!);
      for (var i = 1; i < count - 1; i++) {
        ticks.add(DateTime.fromMicrosecondsSinceEpoch(minMicro + i * step));
      }
      ticks.add(max!);
    }

    title = spec.title ?? variable;
    formatter = spec.formatter ?? defaultFormatter;
  }

  @override
  double convert(DateTime input) =>
    (input.microsecondsSinceEpoch - min!.microsecondsSinceEpoch) /
    (max!.microsecondsSinceEpoch - min!.microsecondsSinceEpoch);

  @override
  DateTime invert(double output) =>
    DateTime.fromMicrosecondsSinceEpoch((
      min!.microsecondsSinceEpoch +
      output * (max!.microsecondsSinceEpoch - min!.microsecondsSinceEpoch)
    ).round());

  @override
  DateTime get zero => min!;

  @override
  String defaultFormatter(DateTime value) => value.toString();

  @override
  bool operator ==(Object other) =>
    other is TimeScaleConv &&
    super == other;
}