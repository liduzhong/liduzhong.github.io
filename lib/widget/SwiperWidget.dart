import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class SwiperWidget extends StatelessWidget {
  final List swiperList;
  final bool autoplay;
  final ratio;
  const SwiperWidget(this.swiperList,
      {Key key, this.autoplay = true, this.ratio = 2 / 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AspectRatio(
        aspectRatio: this.ratio,
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/photo-view',
                    arguments: {'url': this.swiperList[index]});
              },
              child: Image.network(
                this.swiperList[index],
                fit: BoxFit.contain,
              ),
            );
          },
          itemCount: this.swiperList.length,
          pagination: SwiperPagination(),
          autoplay: this.autoplay,
        ),
      ),
    );
  }
}
