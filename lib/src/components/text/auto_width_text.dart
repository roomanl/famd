import 'package:flutter/material.dart';

/// 自定义的文本组件，会尝试填充给定的宽度
class AutoWidthText extends StatelessWidget {
  final String text; // 文本内容
  final double fontSize; // 字体大小
  final Color? color;
  final int maxLines; // 最大行数
  final TextOverflow overflow; // 超出部分的处理方式
  final TextDecoration decoration; // 文本装饰
  final FontWeight fontWeight;
  final TextStyle? style; // 文字样式
  final int targetWordCount;

  const AutoWidthText({
    Key? key,
    required this.text,
    this.fontSize = 12,
    this.color,
    this.maxLines = 1,
    this.targetWordCount = 5,
    this.overflow = TextOverflow.ellipsis,
    this.decoration = TextDecoration.none,
    this.fontWeight = FontWeight.normal,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style ??
          TextStyle(
            fontSize: fontSize,
            color: color ?? const Color.fromRGBO(0, 0, 0, 0.4),
            decoration: decoration,
            fontWeight: fontWeight,
            letterSpacing: 1,
          ),
    );
  }

  double _getTextWidth(String text, double fontSize) {
    final TextPainter tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(fontSize: fontSize)),
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    return tp.width;
  }
}
