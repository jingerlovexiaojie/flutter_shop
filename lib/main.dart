import 'package:flutter/material.dart';
import 'package:flutter_shop/pages/Index_page.dart';
import 'package:flutter_shop/provide/category_goods_list.dart';
import 'package:flutter_shop/provide/child_category.dart';
import 'package:provide/provide.dart';

void main(){
  var childCategory = ChildCategory();
  var categoryGoodsListProvider = CategoryGoodsListProvider();
  var providers = Providers();

  providers
  ..provide(Provider<ChildCategory>.value(childCategory))
  ..provide(Provider<CategoryGoodsListProvider>.value(categoryGoodsListProvider));
  runApp(ProviderNode(child: MyApp(),providers: providers));
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child:MaterialApp(
        title: '百姓生活+',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.pink
        ),
        home: IndexPage(),
      ) ,
    );
  }
}
