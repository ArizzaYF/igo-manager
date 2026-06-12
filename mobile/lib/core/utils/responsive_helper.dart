import 'package:flutter/material.dart';

class S {
  static double w(BuildContext context, double percent) =>
      MediaQuery.of(context).size.width * percent;

  static double h(BuildContext context, double percent) =>
      MediaQuery.of(context).size.height * percent;

  static double sp(BuildContext context, double size) =>
      MediaQuery.textScalerOf(context).scale(size);
}
