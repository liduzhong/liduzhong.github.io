import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class GoodsPage extends StatefulWidget {
  GoodsPage({Key key}) : super(key: key);

  @override
  _GoodsPageState createState() => _GoodsPageState();
}

class _GoodsPageState extends State<GoodsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          AspectRatio(
            aspectRatio: 2 / 1,
            child: Swiper(
              itemCount: 1,
              itemBuilder: (context, index) {
                return Image.network(
                  'https://search-operate.cdn.bcebos.com/86712ed8190be01bf2c41332c9566ca8.jpg',
                  fit: BoxFit.fill,
                );
              },
              pagination: new SwiperPagination(),
              autoplay: true,
            ),
          ),
        ],
      ),
    );
  }
}
