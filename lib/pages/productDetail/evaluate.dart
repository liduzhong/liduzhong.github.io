import 'package:flutter/cupertino.dart';

class EvaluatePage extends StatefulWidget {
  final List productDetailList;

  EvaluatePage(this.productDetailList, {Key key}) : super(key: key);

  @override
  _EvaluatePageState createState() => _EvaluatePageState();
}

class _EvaluatePageState extends State<EvaluatePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('商品'),
    );
  }
}
