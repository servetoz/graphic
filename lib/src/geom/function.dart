import 'package:graphic/src/aes/color.dart';
import 'package:graphic/src/aes/elevation.dart';
import 'package:graphic/src/aes/gradient.dart';
import 'package:graphic/src/aes/label.dart';
import 'package:graphic/src/algebra/varset.dart';
import 'package:graphic/src/aes/shape.dart';
import 'package:graphic/src/aes/size.dart';
import 'package:graphic/src/shape/function.dart';

import 'element.dart';
import 'modifier/modifier.dart';

abstract class FunctionElement<S extends FunctionShape> extends GeomElement<S> {
  FunctionElement({
    ColorAttr? color,
    ElevationAttr? elevation,
    GradientAttr? gradient,
    LabelAttr? label,
    Varset? position,
    ShapeAttr<S>? shape,
    SizeAttr? size,
    List<Modifier>? modifiers,
    int? zIndex,
    String? groupBy,
    Map<String, Set<int>>? selected,
  }) : super(
    color: color,
    elevation: elevation,
    gradient: gradient,
    label: label,
    position: position,
    shape: shape,
    size: size,
    modifiers: modifiers,
    zIndex: zIndex,
    groupBy: groupBy,
    selected: selected,
  );
}