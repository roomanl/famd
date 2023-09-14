import 'package:flutter/material.dart';

class OtherPage extends StatelessWidget {
  final String pageText; //定义一个常量，用于保存跳转进来获取到的参数

  OtherPage(this.pageText); //构造函数，获取参数

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(pageText),
      ), //将参数当作页面标题
      body: new Center(
        child: new Text(pageText),
      ),
    );
  }
}
