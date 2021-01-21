import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../../model/focusModel.dart';
import '../../model/productModel.dart';
import '../../utils/tools.dart';
import '../../services/ScreenAdaper.dart';
import '../../config/Config.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  List _focusList = [];
  List _productList = [];
  List _bestList = [];
  @override
  void initState() {
    super.initState();
    _getFocusData();
    _getProductData();
    _getRecommonData();
  }

  // 获取轮播图信息
  _getFocusData() async {
    String api = '${Config.domain}api/focus';
    var result = await Dio().get(api);
    var focusList = FocusModel.fromJson(result.data);
    setState(() {
      this._focusList = focusList.result;
    });
  }

  // 获取产品推荐数据
  _getProductData() async {
    String api = '${Config.domain}api/plist?is_hot=1';
    var result = await Dio().get(api);
    var productList = ProductModel.fromJson(result.data);
    setState(() {
      this._productList = productList.result;
    });
  }

  // 获取热门推荐
  _getRecommonData() async {
    String api = '${Config.domain}api/plist?is_best=1';
    var result = await Dio().get(api);
    var bestList = ProductModel.fromJson(result.data);
    setState(() {
      this._bestList = bestList.result;
    });
  }

  // 轮播图
  Widget _swiperWidget() {
    if (this._focusList.length > 0) {
      return AspectRatio(
        aspectRatio: 2 / 1,
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return Image.network(
              Tools.formatImgUrl(this._focusList[index].pic),
              fit: BoxFit.fill,
            );
          },
          itemCount: this._focusList.length,
          pagination: new SwiperPagination(),
          autoplay: true,
        ),
      );
    } else {
      return Text('加载中...');
    }
  }

  // 公共的标题
  Widget _titleWidget(String value) {
    return Container(
      margin: EdgeInsets.only(left: ScreenAdaper.width(20)),
      padding: EdgeInsets.only(left: ScreenAdaper.width(20)),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(width: ScreenAdaper.width(10), color: Colors.red),
        ),
      ),
      child: Text(
        value,
        style: TextStyle(color: Colors.black54),
      ),
    );
  }

  // 猜你喜欢
  Widget _hotProductListWidget() {
    if (this._productList.length > 0) {
      return Container(
        width: double.infinity,
        height: ScreenAdaper.height(220),
        padding: EdgeInsets.all(ScreenAdaper.width(20)),
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, int index) {
              return Column(
                children: <Widget>[
                  Container(
                    width: ScreenAdaper.width(140),
                    height: ScreenAdaper.height(140),
                    margin: EdgeInsets.only(right: ScreenAdaper.width(20)),
                    child: Image.network(
                      Tools.formatImgUrl(this._productList[index].pic),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      '￥${this._productList[index].price}',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              );
            },
            itemCount: this._productList.length),
      );
    } else {
      return Text('');
    }
  }

  // 热门推荐
  Widget _bestProductListWidget() {
    var itemWidth = (ScreenAdaper.getScreenWidth() - 30) / 2;
    return Container(
      padding: EdgeInsets.all(10),
      child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: this._bestList.map((value) {
            return Container(
                width: itemWidth,
                padding: EdgeInsets.all(ScreenAdaper.width(10)),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                    width: 1,
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Image.network(
                          Tools.formatImgUrl(value.sPic),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: ScreenAdaper.height(10),
                          bottom: ScreenAdaper.height(10)),
                      child: Text(
                        value.title,
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: ScreenAdaper.height(10),
                          bottom: ScreenAdaper.height(10)),
                      child: Stack(
                        children: [
                          Align(
                            child: Text(
                              '￥${value.price}',
                              style: TextStyle(color: Colors.red, fontSize: 16),
                            ),
                            alignment: Alignment.centerLeft,
                          ),
                          Align(
                            child: Text(
                              '￥${value.oldPrice}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            alignment: Alignment.centerRight,
                          ),
                        ],
                      ),
                    ),
                  ],
                ));
          }).toList()),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdaper.init(context);
    return ListView(
      children: <Widget>[
        _swiperWidget(),
        SizedBox(height: ScreenAdaper.width(20)),
        _titleWidget('猜你喜欢'),
        _hotProductListWidget(),
        _titleWidget('热门推荐'),
        _bestProductListWidget(),
      ],
    );
  }
}
