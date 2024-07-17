import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'search_vod_result_page.dart';
import '../states/app_states.dart';
import '../common/const.dart';
import '../utils/http/http.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _themeCtrl.mainColor.value,
        leadingWidth: 40,
        // elevation: 6,
        // shadowColor: const Color.fromRGBO(0, 0, 0, 0.5),
        leading: IconButton(
          color: const Color.fromRGBO(255, 255, 255, 1),
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: SizedBox(
          height: 45,
          child: SearchBar(
            controller: _serachController,
            hintText: '请输入关键字',
            elevation: MaterialStateProperty.all(0),
            onSubmitted: (value) {
              searchVodList();
            },
            leading: IconButton(
              icon: const Icon(Icons.search_rounded),
              onPressed: () {
                searchVodList();
              },
            ),
            trailing: [
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _serachController.text = '';
                },
              ),
            ],
          ),
        ),
        actions: <Widget>[
          SizedBox(
            width: 50,
            child: TextButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () {
                searchVodList();
              },
              child: const Text(
                '搜索',
                style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: _buildVodList(),
    );
  }

  final _themeCtrl = Get.put(CustomThemeController());
  final _serachController = SearchController();
  var voidDataList = [];
  String msgText = '请输入关键字进行搜索';

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {}

  searchVodList() async {
    if (_serachController.text.isEmpty) return;
    EasyLoading.show(status: '搜索中...');
    var res = await sslClient()
        .get(Uri.parse(M3U8_WD_SEARCH_API + _serachController.text));
    EasyLoading.dismiss();
    // print(res.body);
    if (res.statusCode != 200) {
      EasyLoading.showError('服务器错误！');
      return;
    }
    var dataJson = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
    setState(() {
      voidDataList = dataJson['list'];
      if (voidDataList.isEmpty) {
        msgText = '没有搜索到相关结果';
      }
    });
  }

  Widget _buildVodList() {
    if (voidDataList.isEmpty) {
      return Center(
        child: Text(msgText),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: voidDataList.length,
      itemBuilder: (BuildContext context, int index) {
        var vod = voidDataList[index];
        return InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => SearchVodResultPage(
                    vodName: vod['vod_name'], vodId: vod['vod_id'])));
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  vod['vod_name'],
                  style: const TextStyle(fontSize: 16),
                ),
                Row(
                  children: <Widget>[
                    _buildTag(vod['type_name']),
                    _buildTag(vod['vod_year'] + '年'),
                    _buildTag(vod['vod_remarks']),
                    // _buildTag(vod['vod_time']),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) =>
          const Divider(thickness: 1, height: 1),
    );
  }

  Widget _buildTag(text) {
    return Container(
      padding: const EdgeInsetsDirectional.only(start: 3, end: 10),
      // decoration: BoxDecoration(
      //   borderRadius: const BorderRadius.all(Radius.circular(5)),
      //   border: Border.all(
      //     color: Colors.black,
      //     width: 1,
      //   ),
      // ),
      child: Text(
        text,
        style:
            const TextStyle(fontSize: 12, color: Color.fromARGB(100, 0, 0, 0)),
      ),
    );
  }

  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }
}
