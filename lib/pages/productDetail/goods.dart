import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jdshop/model/productDetailModel.dart';
import 'package:jdshop/services/ScreenAdapter.dart';
import 'package:jdshop/utils/tools.dart';
import 'package:jdshop/widget/CommonBtn.dart';
import 'package:jdshop/widget/SwiperWidget.dart';

class GoodsPage extends StatefulWidget {
  final List productDetailList;
  GoodsPage(this.productDetailList, {Key key}) : super(key: key);

  @override
  _GoodsPageState createState() => _GoodsPageState();
}

class _GoodsPageState extends State<GoodsPage> {
  List swiperList = [];
  ProductDetailItemModel _productDetail;
  @override
  void initState() {
    super.initState();
    setState(() {
      _productDetail = widget.productDetailList[0];
      this.swiperList.add(Tools.formatImgUrl(_productDetail.pic));
    });
  }

  _bottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return GestureDetector(
            onTap: () {
              return false;
            },
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  height: 500,
                  margin: EdgeInsets.only(bottom: 20),
                  child: ListView(
                      children: this._productDetail.attr.map((item) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin: EdgeInsets.only(
                              top: 15,
                              right: 10,
                            ),
                            child: Text(item.cate)),
                        Expanded(
                          flex: 1,
                          child: Wrap(
                              children: item.list.map((it) {
                            return Container(
                                margin: EdgeInsets.only(left: 4, right: 4),
                                child: Chip(label: Text(it)));
                          }).toList()),
                        )
                      ],
                    );
                  }).toList()),
                ),
                Positioned(
                  width: ScreenAdapter.width(750),
                  height: ScreenAdapter.height(100),
                  bottom: 0,
                  child: Container(
                    color: Colors.white,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: CommonBtn(
                            bgColor: Color.fromRGBO(255, 165, 0, 0.9),
                            text: '加入购物车',
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: CommonBtn(
                            bgColor: Colors.red,
                            text: '立即购买',
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
        backgroundColor: Colors.white);
  }

  // 商品内容
  _buildGoodsContent() {
    return Container(
      padding: EdgeInsets.all(5),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(bottom: 10),
            child: Text(
              this._productDetail?.title ?? '',
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(bottom: 10),
            child: Text(
              this._productDetail?.subTitle ?? '',
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                color: Colors.black45,
                fontSize: 14,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '特价：',
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  Text(
                    '￥${this._productDetail?.price ?? ''}',
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '原价：',
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  Text(
                    '￥${this._productDetail?.oldPrice ?? ''}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black45,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
            ],
          ),
          InkWell(
            onTap: () {
              _bottomSheet();
            },
            child: Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black26,
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    '已选：',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '115黑色,XL,1件',
                    style: TextStyle(fontSize: 14, color: Colors.black45),
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              // _bottomSheet();
            },
            child: Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black26,
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    '运费：',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '免费',
                    style: TextStyle(fontSize: 14, color: Colors.black45),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          SwiperWidget(this.swiperList, ratio: 1 / 1),
          _buildGoodsContent(),
        ],
      ),
    );
  }
}
