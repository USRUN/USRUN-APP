import 'package:flutter/material.dart';

const Size kDefaultSize = Size.square(9.0);
const EdgeInsets kDefaultSpacing = EdgeInsets.all(6.0);
const ShapeBorder kDefaultShape = CircleBorder();
const BoxShadow kDefaultBoxShadow = BoxShadow(
  offset: Offset(0.0, 0.0),
  blurRadius: 0.0,
  color: Colors.transparent,
);

class DotsDecorator {
  // Inactive dot color
  //
  // @Default `Colors.grey`
  final Color color;

  // Active dot color
  //
  // @Default `Colors.lightBlue`
  final Color activeColor;

  // Inactive dot size
  //
  // @Default `Size.square(9.0)`
  final Size size;

  // Active dot size
  //
  // @Default `Size.square(9.0)`
  final Size activeSize;

  // Inactive dot shape
  //
  // @Default `CircleBorder()`
  final ShapeBorder shape;

  // Active dot shape
  //
  // @Default `CircleBorder()`
  final ShapeBorder activeShape;

  // Spacing between dots
  //
  // @Default `EdgeInsets.all(6.0)`
  final EdgeInsets spacing;

  // Shadow of each dots
  //
  // @Default `transparent`
  final BoxShadow boxShadow;

  // Shadow of active dots
  //
  // @Default `transparent`
  final BoxShadow activeBoxShadow;

  const DotsDecorator({
    this.color = Colors.grey,
    this.activeColor = Colors.lightBlue,
    this.size = kDefaultSize,
    this.activeSize = kDefaultSize,
    this.shape = kDefaultShape,
    this.activeShape = kDefaultShape,
    this.spacing = kDefaultSpacing,
    this.boxShadow = kDefaultBoxShadow,
    this.activeBoxShadow = kDefaultBoxShadow,
  })  : assert(color != null),
        assert(activeColor != null),
        assert(size != null),
        assert(activeSize != null),
        assert(shape != null),
        assert(activeShape != null),
        assert(spacing != null),
        assert(boxShadow != null),
        assert(activeBoxShadow != null);
}
