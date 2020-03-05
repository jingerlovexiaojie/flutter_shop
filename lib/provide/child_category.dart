import 'dart:html';

import 'package:flutter/material.dart';
import '../model/category.dart';

class ChildCategory with ChangeNotifier {
  List<BxMallSubDto> childCategoryList = [];
  int childIndex = 0; //子类高亮索引
  String categoryId = '4'; //大类ID
  String subId = ""; //小类
  int page = 1;
  String noMoreText = ''; //显示没有数据的文案

  //大类切换逻辑
  getChildCategory(List<BxMallSubDto> list, String id) {
    page = 1;
    noMoreText = '';
    childIndex = 0;
    categoryId = id;

    BxMallSubDto all = BxMallSubDto();
    all.mallSubId = '';
    all.mallCategoryId = '00';
    all.comments = 'null';
    all.mallCategoryName = '全部';

    childCategoryList = [all];
    childCategoryList.addAll(list);
    notifyListeners();
  }

  //改变子类索引
  changeChildIndex(index, String id) {
    page = 1;
    noMoreText = '';

    subId = id;
    childIndex = index;
    notifyListeners();
  }

  addPage() {
    page++;
  }

  changeNOMore(String text) {
    noMoreText = text;
    notifyListeners();
  }
}
