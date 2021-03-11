import 'package:flutter/material.dart';
import 'package:jdshop/services/ScreenAdapter.dart';
import 'package:jdshop/widget/CommonBtn.dart';
import './details.dart';
import './evaluate.dart';
import './goods.dart';

class ProductDetailPage extends StatefulWidget {
  final String id;
  ProductDetailPage({Key key, this.id}) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  List tabs = ['商品', '详情', '评价'];

  @override
  void initState() {
    super.initState();
    print(widget.id);
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Container(
        child: TabBar(
          indicatorColor: Colors.red,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: this.tabs.map((tab) {
            return Tab(child: Text(tab));
          }).toList(),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.more_horiz),
          onPressed: () {
            showMenu(
                context: context,
                position:
                    RelativeRect.fromLTRB(ScreenAdapter.width(600), 60, 0, 0),
                items: [
                  PopupMenuItem(
                    child: Row(
                      children: <Widget>[Icon(Icons.home), Text("首页")],
                    ),
                  ),
                  PopupMenuItem(
                    child: Row(
                      children: <Widget>[Icon(Icons.search), Text("搜索")],
                    ),
                  )
                ]);
          },
        )
      ],
    );
  }

  Widget _buildContent() {
    return Stack(
      children: [
        TabBarView(
          children: [
            GoodsPage(),
            DetailsPage(),
            EvaluatePage(),
          ],
        ),
        Positioned(
          bottom: 0,
          width: ScreenAdapter.width(750),
          height: ScreenAdapter.height(100),
          child: Container(
            color: Colors.white,
            child: Row(
              children: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    width: 80,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart),
                        Text(
                          '购物车',
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ),
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
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: this.tabs.length,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildContent(),
      ),
    );
  }
}
