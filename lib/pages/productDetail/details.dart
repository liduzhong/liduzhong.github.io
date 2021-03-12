import 'package:flutter/cupertino.dart';

class DetailsPage extends StatefulWidget {
  final List productDetailList;
  DetailsPage(this.productDetailList, {Key key}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('商品'),
    );
  }
}
