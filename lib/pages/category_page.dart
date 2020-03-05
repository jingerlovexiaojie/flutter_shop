import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shop/model/categoryGoodsList.dart';
import 'package:flutter_shop/provide/category_goods_list.dart';
import 'package:flutter_shop/provide/child_category.dart';
import 'package:provide/provide.dart';
import '../model/category.dart';
import '../service/service_method.dart';
import 'dart:convert';
import '../model/category.dart';
import '../provide/child_category.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('商品分类'),
      ),
      body: Container(
        child: Row(
          children: <Widget>[
            LeftCategoryNav(),
            Column(
              children: <Widget>[RightCategoryNav(), CategoryGoodsList()],
            )
          ],
        ),
      ),
    );
  }
}

//左侧大类导航
class LeftCategoryNav extends StatefulWidget {
  @override
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {
  List list = [];
  var listIndex = 0;

  @override
  void initState() {
    _getCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180),
      decoration: BoxDecoration(
          border: Border(right: BorderSide(width: 1, color: Colors.black12))),
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return _leftInkWell(index);
        },
      ),
    );
  }

  Widget _leftInkWell(int index) {
    bool isClick = false;
    isClick = (index == listIndex) ? true : false;
    return InkWell(
        onTap: () {
          setState(() {
            listIndex = index;
          });
          var childList = list[index].bxMallSubDto;
          var categoryId = list[index].mallCategoryId;
          Provide.value<ChildCategory>(context)
              .getChildCategory(childList, categoryId);
          _getGoodsList(categoryId: categoryId);
        },
        child: Container(
          height: ScreenUtil().setHeight(100),
          padding: EdgeInsets.only(left: 10, top: 20),
          decoration: BoxDecoration(
              color: isClick ? Colors.black12 : Colors.white,
              border: Border(bottom: BorderSide(width: 1.0))),
          child: Text(list[index].mallCategoryName),
        ));
  }

  void _getCategory() async {
    await request('getCategory').then((val) {
      var data = json.decode(val.toString());
      CategoryBigListModel category =
      CategoryBigListModel.fromJson(data['data']);
      setState(() {
        list = category.data;
      });
      Provide.value<ChildCategory>(context)
          .getChildCategory(list[0].bxMallSunDto, list[0].mallCategoryId);
      //list.data.forEach((item) => print(item.mallCategoryName));
    });
  }

  void _getGoodsList({String categoryId}) {
    var param = {
      ' categoryId': categoryId == null ? '4' : categoryId,
      'categorySubId': '',
      'page': 1
    };
    request('getMallGoods', formDate: param).then((val) {
      var data = json.decode(val.toString());
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      Provide.value<CategoryGoodsListProvider>(context)
          .getGoodsList(goodsList.data);
    });
  }
}

class RightCategoryNav extends StatefulWidget {
  @override
  _RightCategoryNavState createState() => _RightCategoryNavState();
}

class _RightCategoryNavState extends State<RightCategoryNav> {
  @override
  Widget build(BuildContext context) {
    return Provide<ChildCategory>(builder: (context, child, childCategory) {
      return Container(
        height: ScreenUtil().setHeight(80),
        width: ScreenUtil().setWidth(570),
        decoration: BoxDecoration(
            color: Colors.white,
            border:
            Border(bottom: BorderSide(width: 1, color: Colors.black12))),
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: childCategory.childCategoryList.length,
            itemBuilder: (context, index) {
              return _rightInkWell(
                  index, childCategory.childCategoryList[index]);
            }),
      );
    });
  }

  Widget _rightInkWell(int index, BxMallSubDto item) {
    bool isClick = false;
    isClick = (index == Provide
        .value<ChildCategory>(context)
        .childIndex)
        ? true
        : false;
    return InkWell(
      onTap: () {
        //点击改变,显示高亮颜色
        Provide.value<ChildCategory>(context)
            .changeChildIndex(index, item.mallSubId);
        _getGoodsList(item.mallSubId);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        child: Text(item.mallCategoryName,
            style: TextStyle(
                fontSize: ScreenUtil().setSp(28),
                color: isClick ? Colors.pink : Colors.black)),
      ),
    );
  }

  void _getGoodsList(String categorySubId) {
    var param = {
      ' categoryId': Provide
          .value<ChildCategory>(context)
          .categoryId,
      'categorySubId': categorySubId,
      'page': 1
    };
    request('getMallGoods', formDate: param).then((val) {
      var data = json.decode(val.toString());
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      if (goodsList.data == null) {
        Provide.value<CategoryGoodsListProvider>(context).getGoodsList([]);
      } else {
        Provide.value<CategoryGoodsListProvider>(context)
            .getGoodsList(goodsList.data);
      }
    });
  }
}

//商品列表,可以实现上拉加载
class CategoryGoodsList extends StatefulWidget {
  @override
  _CategoryGoodsListState createState() => _CategoryGoodsListState();
}

class _CategoryGoodsListState extends State<CategoryGoodsList> {
  GlobalKey<RefreshFooterState> _footerkey =
  new GlobalKey<RefreshFooterState>();

  var scrollerController = new ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provide<CategoryGoodsListProvider>(
      builder: (context, child, data) {
        try {
          if (Provide
              .value<ChildCategory>(context)
              .page == 1) {
            //列表位置,放到最上面
            scrollerController.jumpTo(0.0);
          }
        } catch (e) {
          print('进入页面第一次初始化');
        }

        if (data.goodsList.length > 0) {
          return Expanded(
            child: Container(
              width: ScreenUtil().setWidth(570),
              child: EasyRefresh(
                refreshFooter: ClassicsFooter(
                  key: _footerkey,
                  bgColor: Colors.white,
                  textColor: Colors.pink,
                  moreInfoColor: Colors.pink,
                  showMore: true,
                  noMoreText: Provide
                      .value<ChildCategory>(context)
                      .noMoreText,
                  moreInfo: '加载中',
                  loadReadyText: '上啦加载中...',
                ),
                child: ListView.builder(
                    controller: scrollerController,
                    itemCount: data.goodsList.length,
                    itemBuilder: (context, index) {
                      return _ListWidget(data.goodsList, index);
                    }),
                loadMore: () async {
                  _getMoreList();
                },
              ),
            ),
          );
        } else {
          return Text('暂时没有数据');
        }
      },
    );
  }

  void _getMoreList() {
    Provide.value<ChildCategory>(context).addPage();

    var param = {
      ' categoryId': Provide
          .value<ChildCategory>(context)
          .categoryId,
      'categorySubId': Provide
          .value<ChildCategory>(context)
          .subId,
      'page': Provide
          .value<ChildCategory>(context)
          .page,
    };
    request('getMallGoods', formDate: param).then((val) {
      var data = json.decode(val.toString());
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      if (goodsList.data == null) {
        Provide.value<ChildCategory>(context).changeNOMore('没有更多了');
      } else {
        Provide.value<CategoryGoodsListProvider>(context)
            .getMoreList(goodsList.data);
      }
    });
  }

  Widget _goodsImage(List newList, index) {
    return Container(
      width: ScreenUtil().setWidth(200),
      child: Image.network(newList[index].image),
    );
  }

  Widget _goodsName(List newList, index) {
    return Container(
      padding: EdgeInsets.all(5.0),
      width: 370,
      child: Text(newList[index].goodsName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: ScreenUtil().setSp(28))),
    );
  }

  Widget _goodsPrice(List newList, index) {
    return Container(
      width: 370,
      margin: EdgeInsets.only(top: 20.0),
      child: Row(
        children: <Widget>[
          Text(
            '价格:${newList[index].presentPrice}',
            style:
            TextStyle(color: Colors.pink, fontSize: ScreenUtil().setSp(30)),
          ),
          Text(
            '价格:${newList[index].oriPrice}',
            style: TextStyle(
                color: Colors.black26, decoration: TextDecoration.lineThrough),
          )
        ],
      ),
    );
  }

  Widget _ListWidget(List newList, int index) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border:
            Border(bottom: BorderSide(width: 1.0, color: Colors.black12))),
        child: Row(
          children: <Widget>[
            _goodsImage(newList, index),
            Column(
              children: <Widget>[
                _goodsName(newList, index),
                _goodsPrice(newList, index)
              ],
            )
          ],
        ),
      ),
    );
  }
}
