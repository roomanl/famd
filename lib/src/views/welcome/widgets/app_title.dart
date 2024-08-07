import 'package:flutter/material.dart';

class AppTileWidget extends StatelessWidget {
  const AppTileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Famd M3u8下载器',
          style: TextStyle(
              color: Color.fromRGBO(255, 255, 255, 0.8),
              fontWeight: FontWeight.bold,
              fontSize: 36),
        ),
        Text(
          '免费版',
          style: TextStyle(
              color: Color.fromRGBO(255, 255, 255, 0.8),
              fontWeight: FontWeight.bold,
              fontSize: 36),
        ),
      ],
    );
  }
}
