import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../utils/tools.dart';
import '../config/Config.dart';
import '../services/ScreenAdaper.dart';
import '../model/productModel.dart';
import '../widget/LoadingWidget.dart';

class ProductListPage extends StatefulWidget {
  Map arguments;
  ProductListPage({Key key, this.arguments}) : super(key: key);

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // listview滚动控制器
  ScrollController _scrollControler = new ScrollController();
  List _productList = [];
  bool isLoaded = false;
  int _page = 1;
  int _pageSize = 10;
  bool _canLoad = true;
  String _sort = '';
  bool _hasMore = true;
  List _headTabs = [
    {'id': 1, 'name': '综合', 'fileds': 'all', 'sort': -1, 'arrow': false},
    {'id': 2, 'name': '销量', 'fileds': 'salecount', 'sort': -1, 'arrow': true},
    {'id': 3, 'name': '价格', 'fileds': 'price', 'sort': -1, 'arrow': true},
    {'id': 4, 'name': '筛选', 'arrow': false}
  ];
  int _selectedTabId = 1;
  // 点击头部排序次数
  int clickCount = 0;
  int clickId = 0;
  // is_best 精华  is_hot 热门 is_new 新品 sort 排序 价格升序 sort=price_1 价格降序 sort=price_-1 销量升序 sort=salecount_1 销量降序 sort=salecount_-1
  @override
  void initState() {
    super.initState();
    _getProductData();
    // 监听滚动条
    _scrollControler.addListener(() {
      // _scrollControler.position.pixels  获取滚动条滚动的高度
      // _scrollControler.position.maxScrollExtent  获取页面的高度
      if (_scrollControler.position.pixels >
          (_scrollControler.position.maxScrollExtent - 20)) {
        if (this._canLoad && this._hasMore) {
          _getProductData();
        }
      }
    });
  }

  _getProductData() async {
    setState(() {
      this._canLoad = false;
    });
    String api = Config.domain +
        "api/plist?cid=${widget.arguments['cid']}&page=${this._page}&pageSize=${this._pageSize}&sort=${this._sort}";
    var result = await Dio().get(api);
    var productList = ProductModel.fromJson(result.data);
    if (productList.result.length < this._pageSize) {
      setState(() {
        this._hasMore = false;
        this._canLoad = false;
      });
    } else {
      setState(() {
        this._page++;
        this._canLoad = true;
      });
    }
    setState(() {
      this._productList.addAll(productList.result);
      this.isLoaded = true;
    });
    print(api);
  }

  // 展示更多
  Widget showMore(int index) {
    bool last = index == (this._productList.length - 1);
    if (this._hasMore) {
      return last ? LoadingWidget() : Text('');
    } else {
      return last
          ? Container(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: Text('--- 我是有底线的 ---'))
          : Text('');
    }
  }

  // 产品列表
  Widget _productListWidget() {
    if (this.isLoaded) {
      if (this._productList.length == 0) {
        return Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: ScreenAdaper.height(80)),
          child: Center(
            child: Text('暂无数据'),
          ),
        );
      } else {
        return Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: ScreenAdaper.height(80)),
          child: ListView.builder(
            controller: _scrollControler,
            itemBuilder: (context, index) {
              return Container(
                color: Colors.white,
                padding: EdgeInsets.only(left: 8, right: 8),
                margin: EdgeInsets.only(top: 8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          margin:
                              EdgeInsets.only(right: ScreenAdaper.width(20)),
                          child: Image.network(
                              Tools.formatImgUrl(this._productList[index].pic),
                              fit: BoxFit.cover,
                              width: ScreenAdaper.width(200),
                              height: ScreenAdaper.height(200)),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.only(
                                top: ScreenAdaper.height(10),
                                bottom: ScreenAdaper.height(10)),
                            height: ScreenAdaper.height(200),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  this._productList[index].title,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 8),
                                      padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                                      decoration: BoxDecoration(
                                          color: Colors.black12,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(16.0))),
                                      child: Text('标签1',
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 14)),
                                    ),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                                      decoration: BoxDecoration(
                                          color: Colors.black12,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(16.0))),
                                      child: Text('标签2',
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 14)),
                                    ),
                                  ],
                                ),
                                Text(
                                  '￥${this._productList[index].price}',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    showMore(index)
                  ],
                ),
              );
            },
            itemCount: this._productList.length,
          ),
        );
      }
    } else {
      return LoadingWidget();
    }
  }

  // 点击头部tab
  void _onTabClick(int id) {
    if (this.clickId != id) {
      this.clickCount = 0;
    } else {
      this.clickCount++;
    }
    if (id == 4) {
      _scaffoldKey.currentState.openEndDrawer();
      return;
    }
    setState(() {
      this.clickId = id;
      if (this.clickCount != 0) {
        this._headTabs[id - 1]['sort'] *= -1;
      }
      this._sort =
          '${this._headTabs[id - 1]['fileds']}_${this._headTabs[id - 1]['sort']}';
      // 这里重置箭头方向
      this._headTabs.map((value) {
        if (value['id'] != id) {
          value['sort'] = -1;
        }
      }).toList();
      this._page = 1;
      this._canLoad = true;
      this._productList = [];
      this._hasMore = true;
      this._selectedTabId = id;
      this.isLoaded = false;
      this._getProductData();
      //页面回滚到顶部
      _scrollControler.jumpTo(0);
    });
  }

  //显示箭头
  Widget _showArrow(int id) {
    var selected = this._headTabs[id - 1];
    var color = this._selectedTabId == id ? Colors.red : Colors.black;
    if (selected['arrow']) {
      if (selected['sort'] == -1) {
        return Icon(Icons.arrow_drop_down, color: color);
      }
      return Icon(Icons.arrow_drop_up, color: color);
    }
    return Text('');
  }

  // 筛选
  Widget _topFilter() {
    return Positioned(
      top: 0,
      width: ScreenAdaper.width(750),
      height: ScreenAdaper.height(80),
      child: Container(
        color: Colors.white,
        child: Row(
          children: this._headTabs.map((value) {
            return Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  _onTabClick(value['id']);
                },
                child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        0, ScreenAdaper.height(16), ScreenAdaper.height(16), 0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('${value["name"]}',
                              style: TextStyle(
                                  color: (this._selectedTabId == value['id'])
                                      ? Colors.red
                                      : Colors.black),
                              textAlign: TextAlign.center),
                          _showArrow(value['id'])
                        ])),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdaper.init(context);
    return Container(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('产品详情'),
          actions: [Text('')],
        ),
        body: Stack(
          children: [
            _productListWidget(),
            _topFilter(),
          ],
        ),
        endDrawer: Drawer(
          child: ListView(
            children: <Widget>[Text('这个是抽屉')],
          ),
        ),
      ),
    );
  }
}
