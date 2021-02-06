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
  int page = 1;
  int pageSize = 10;
  bool canLoad = true;
  String sort = '';
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
        if (this.canLoad) {
          _getProductData();
        }
      }
    });
  }

  _getProductData() async {
    setState(() {
      this.canLoad = false;
    });
    print(canLoad);
    String api = Config.domain +
        "api/plist?cid=${widget.arguments['cid']}&page=${this.page}pageSize=${this.pageSize}&sort=${this.sort}";
    var result = await Dio().get(api);
    var productList = ProductModel.fromJson(result.data);
    setState(() {
      this._productList.addAll(productList.result);
      this.page++;
      this.isLoaded = true;
      this.canLoad = true;
    });
    print(api);
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
                    (index == this._productList.length - 1)
                        ? LoadingWidget()
                        : Text('')
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

  // 筛选
  Widget _topFilter() {
    return Positioned(
      top: 0,
      width: ScreenAdaper.width(750),
      height: ScreenAdaper.height(80),
      child: Container(
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      0, ScreenAdaper.height(16), ScreenAdaper.height(16), 0),
                  child: Text('综合',
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.center),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      0, ScreenAdaper.height(16), ScreenAdaper.height(16), 0),
                  child: Text('销量', textAlign: TextAlign.center),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      0, ScreenAdaper.height(16), ScreenAdaper.height(16), 0),
                  child: Text('价格', textAlign: TextAlign.center),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  _scaffoldKey.currentState.openEndDrawer();
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      0, ScreenAdaper.height(16), ScreenAdaper.height(16), 0),
                  child: Text('筛选', textAlign: TextAlign.center),
                ),
              ),
            ),
          ],
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
