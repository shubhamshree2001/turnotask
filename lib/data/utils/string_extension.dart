import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

extension StringExtensions on String {
  SvgPicture toSvg(
      {double? height,
        double? width,
        BoxFit boxFit = BoxFit.contain,
        Color? color}) =>
      SvgPicture.asset(
        this,
        width: width,
        height: height,
        fit: boxFit,
        color: color,
      );
}