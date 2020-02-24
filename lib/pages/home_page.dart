import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String showText = '还没有请求数据';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('请求远程数据'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              RaisedButton(
                onPressed: (){
                  _jike();
                },
                child: Text('请求数据'),
              ),
              Text(showText)
            ],
          ),
        ),
      ),
    );
  }

  void _jike(){
    print('开始请求');
    getHttp().then((val){
      setState(() {
        showText = val['data'].toString();
      });
    });
  }

  Future getHttp() async{
    try{
      Response response;
      Dio dio = Dio();
      response = await dio.get('');
      return response.data;
    }catch(e){
      return print(e);

    }
  }
}
