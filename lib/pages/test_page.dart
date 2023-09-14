import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import './other_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CYC"),
        backgroundColor: Colors.redAccent,
      ), //头部的标题AppBar
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              //Material内置控件
              accountName: const Text('CYC'), //用户名
              accountEmail: const Text('example@126.com'),
              currentAccountPicture: GestureDetector(
                //用户头像
                onTap: () => print('current user'),
                child: const CircleAvatar(
                  //圆形图标控件
                  backgroundImage:
                      NetworkImage('http://127.0.0.1:805/html/6_8.jpg'),
                ),
              ),
              otherAccountsPictures: <Widget>[
                //粉丝头像
                GestureDetector(
                    //手势探测器，可以识别各种手势，这里只用到了onTap
                    onTap: () => print('other user'), //暂且先打印一下信息吧，以后再添加跳转页面的逻辑
                    child: CircleAvatar(
                      radius: 85,
                      child: CachedNetworkImage(
                        imageUrl: "http://127.0.0.1:805/html/6_81.jpg",
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    )),
                GestureDetector(
                  onTap: () => print('other user'),
                  child: const CircleAvatar(
                    backgroundImage:
                        NetworkImage('http://127.0.0.1:805/html/6_8.jpg'),
                  ),
                ),
              ],
              decoration: const BoxDecoration(
                //用一个BoxDecoration装饰器提供背景图片
                image: DecorationImage(
                  fit: BoxFit.fill,
                  // image: new NetworkImage('https://raw.githubusercontent.com/flutter/website/master/_includes/code/layout/lakes/images/lake.jpg')
                  //可以试试图片调取自本地。调用本地资源，需要到pubspec.yaml中配置文件路径
                  image: ExactAssetImage('images/lake.jpg'),
                ),
              ), //用户邮箱
            ),
            ListTile(
                //第一个功能项
                title: const Text('First Page'),
                trailing: const Icon(Icons.arrow_upward),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => OtherPage('1')));
                }),
            ListTile(
                //第二个功能项
                title: const Text('Second Page'),
                trailing: const Icon(Icons.arrow_right),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => OtherPage('2')));
                }),
            ListTile(
                //第二个功能项
                title: const Text('Second Page'),
                trailing: const Icon(Icons.arrow_right),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('/secondPage');
                }),
            const Divider(), //分割线控件
            ListTile(
              //退出按钮
              title: const Text('Close'),
              trailing: const Icon(Icons.cancel),
              onTap: () => Navigator.of(context).pop(), //点击后收起侧边栏
            ),
          ],
        ),
      ), //侧边栏按钮Drawer
      body: const Center(
        //中央内容部分body
        child: Text(
          'HomePage',
          style: TextStyle(fontSize: 35.0),
        ),
      ),
    );
  }
}
