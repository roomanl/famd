import 'package:flutter/material.dart';

class LeftBarStyle {
  Color? textColor;
  Color? activeColor;
  TextStyle? labelStyle;

  LeftBarStyle({
    this.textColor = const Color(0xffcfd1d7),
    this.activeColor = const Color.fromRGBO(27, 167, 132, 1),
    this.labelStyle = const TextStyle(color: Color(0xffcfd1d7), fontSize: 11),
  });
}

class NavDestination {
  const NavDestination(this.label, this.icon);

  final String label;
  final Widget icon;
}
