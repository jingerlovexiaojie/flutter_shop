import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop/pages/Index_page.dart';
import 'package:flutter_shop/provide/category_goods_list.dart';
import 'package:flutter_shop/provide/child_category.dart';
import 'package:flutter_shop/provide/details_info.dart';
import 'package:provide/provide.dart';
import './routers/routes.dart';
import './routers/application.dart';


void main(){
  var childCategory = ChildCategory();
  var categoryGoodsListProvider = CategoryGoodsListProvider();
  var providers = Providers();
  var detailsInfoProvide  =DetailsInfoProvide();


  providers
  ..provide(Provider<ChildCategory>.value(childCategory))
  ..provide(Provider<CategoryGoodsListProvider>.value(categoryGoodsListProvider))
  ..provide(Provider<DetailsInfoProvide>.value(detailsInfoProvide));
  runApp(ProviderNode(child: MyApp(),providers: providers));
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final router = Router();
    Routes.configureRoutes(router);
    Application.router = router;


    return Container(
      child:MaterialApp(
        title: '百姓生活+',
        onGenerateRoute: Application.router.generator,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.pink
        ),
        home: IndexPage(),
      ) ,
    );
  }
}
