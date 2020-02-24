import 'package:flutter/material.dart';
import '../service/service_method.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String homePageConten = '正在获取数据';

  @override
  void initState() {
    getHomePageContent().then((val) {
      setState(() {
        homePageConten = val.toString();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('百姓')),
      body: SingleChildScrollView(
        child: Text(homePageConten),
      ),
    );
  }
}
