import 'package:flutter/material.dart';
import '../model/categoryGoodsList.dart';

class CategoryGoodsListProvider with ChangeNotifier{
  List<CategoryListData> goodsList = [];

  //点击大类时更换商品列表
  getGoodsList(List<CategoryListData> list){
    goodsList=list;
    notifyListeners();
  }

  //点击大类时更换商品列表
  getMoreList(List<CategoryListData> list){
    goodsList.addAll(list);
    notifyListeners();
  }
}