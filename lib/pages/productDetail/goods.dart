import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:jdshop/widget/SwiperWidget.dart';

class GoodsPage extends StatefulWidget {
  GoodsPage({Key key}) : super(key: key);

  @override
  _GoodsPageState createState() => _GoodsPageState();
}

class _GoodsPageState extends State<GoodsPage> {
  List swiperList = [
    'https://search-operate.cdn.bcebos.com/86712ed8190be01bf2c41332c9566ca8.jpg'
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          SwiperWidget(this.swiperList),
        ],
      ),
    );
  }
}
