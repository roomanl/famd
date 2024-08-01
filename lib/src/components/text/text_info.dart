import 'package:flutter/material.dart';

// 自定义Text组件
class TextInfo extends StatelessWidget {
  final String text; // 文本内容
  final double fontSize; // 字体大小
  final Color? color; // 文本颜色
  final TextAlign textAlign; // 对齐方式
  final TextOverflow overflow; // 超出部分的处理方式
  final TextDecoration decoration; // 文本装饰
  final FontWeight fontWeight; // 字体粗细
  final double opacity;

  const TextInfo({
    Key? key,
    required this.text,
    this.fontSize = 12.0,
    this.color,
    this.textAlign = TextAlign.left,
    this.overflow = TextOverflow.clip,
    this.decoration = TextDecoration.none,
    this.fontWeight = FontWeight.normal,
    this.opacity = 0.7,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: color ?? Color.fromRGBO(0, 0, 0, opacity),
        decoration: decoration,
        fontWeight: fontWeight,
      ),
      textAlign: textAlign,
      overflow: overflow,
    );
  }
}
