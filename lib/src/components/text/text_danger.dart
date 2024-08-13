import 'package:flutter/material.dart';

// 自定义Text组件
class TextDanger extends StatelessWidget {
  final String text; // 文本内容
  final double fontSize; // 字体大小
  final Color color; // 文本颜色
  final TextAlign textAlign; // 对齐方式
  final TextOverflow overflow; // 超出部分的处理方式
  final TextDecoration decoration; // 文本装饰
  final FontWeight fontWeight; // 字体粗细

  const TextDanger({
    super.key,
    required this.text,
    this.fontSize = 12.0,
    this.color = const Color.fromRGBO(237, 85, 106, 1),
    this.textAlign = TextAlign.left,
    this.overflow = TextOverflow.clip,
    this.decoration = TextDecoration.none,
    this.fontWeight = FontWeight.normal,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        decoration: decoration,
        fontWeight: fontWeight,
      ),
      textAlign: textAlign,
      overflow: overflow,
    );
  }
}
