import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../utils/tools.dart';
import '../config/Config.dart';
import '../services/ScreenAdaper.dart';
import '../model/productModel.dart';

class ProductListPage extends StatefulWidget {
  Map arguments;
  ProductListPage({Key key, this.arguments}) : super(key: key);

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List _productList = [];
  bool isLoaded = false;
  int page = 1;
  int pageSize = 10;
  // is_best 精华  is_hot 热门 is_new 新品 sort 排序 价格升序 sort=price_1 价格降序 sort=price_-1 销量升序 sort=salecount_1 销量降序 sort=salecount_-1
  @override
  void initState() {
    super.initState();
    _getProductData();
  }

  _getProductData() async {
    String api = Config.domain +
        "api/plist?cid=${widget.arguments['cid']}&page=${this.page}pageSize=${this.pageSize}&";
    var result = await Dio().get(api);
    var productList = ProductModel.fromJson(result.data);
    print(productList.result);
    setState(() {
      this._productList = productList.result;
      this.isLoaded = true;
    });
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
            itemBuilder: (context, index) {
              return Container(
                color: Colors.white,
                padding: EdgeInsets.only(left: 8, right: 8),
                margin: EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: ScreenAdaper.width(20)),
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
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
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
                                          color: Colors.black54, fontSize: 14)),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                                  decoration: BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16.0))),
                                  child: Text('标签2',
                                      style: TextStyle(
                                          color: Colors.black54, fontSize: 14)),
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
              );
            },
            itemCount: this._productList.length,
          ),
        );
      }
    } else {
      return Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: ScreenAdaper.height(80)),
        child: Center(
          child: Text('加载中...'),
        ),
      );
    }
  }

  // 筛选
  Widget _topFilter() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: ScreenAdaper.height(80),
      child: Container(
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Text('综合', textAlign: TextAlign.center),
            ),
            Expanded(
              flex: 1,
              child: Text('销量', textAlign: TextAlign.center),
            ),
            Expanded(
              flex: 1,
              child: Text('价格', textAlign: TextAlign.center),
            ),
            Expanded(
              flex: 1,
              child: Text('筛选', textAlign: TextAlign.center),
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
        appBar: AppBar(
          title: Text('产品详情'),
        ),
        body: Stack(
          children: [
            _productListWidget(),
            _topFilter(),
          ],
        ),
      ),
    );
  }
}
