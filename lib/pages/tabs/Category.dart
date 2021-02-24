import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../config/Config.dart';
import '../../services/ScreenAdaper.dart';
import '../../utils/tools.dart';
import '../../model/categoryModel.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage({Key key}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with AutomaticKeepAliveClientMixin {
  int selectedIndex = 0;
  List _categoryList = [];
  List _rightContentList = [];
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    _getCateData();
  }

  // 获取左侧菜单
  _getCateData() async {
    String api = '${Config.domain}api/pcate';
    var result = await Dio().get(api);
    var categoryData = CategoryModel.fromJson(result.data);
    setState(() {
      this._categoryList = categoryData.result;
    });
    this._getRightContent(this._categoryList[0].sId);
  }

  // 获取右侧内容
  _getRightContent(sId) async {
    String api = '${Config.domain}api/pcate?pid=$sId';
    var result = await Dio().get(api);
    var rightContentData = CategoryModel.fromJson(result.data);
    setState(() {
      this._rightContentList = rightContentData.result;
    });
  }

  Widget _leftCateWidget(leftWidth) {
    if (this._categoryList.length > 0) {
      return Container(
        width: leftWidth,
        height: double.infinity,
        child: ListView.builder(
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  this.selectedIndex = index;
                });
                this._getRightContent(this._categoryList[index].sId);
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1, color: Colors.black12),
                  ),
                  color: this.selectedIndex == index
                      ? Colors.black12
                      : Colors.white,
                ),
                child: Text(this._categoryList[index].title),
              ),
            );
          },
          itemCount: this._categoryList.length,
        ),
      );
    } else {
      return Container(
        width: leftWidth,
        height: double.infinity,
        child: Text(''),
      );
    }
  }

  // 右侧内容组件
  Widget _rightContentWidget(rightItemWidth) {
    if (this._rightContentList.length > 0) {
      return Expanded(
        flex: 1,
        child: Container(
          height: double.infinity,
          padding: EdgeInsets.all(10),
          child: GridView.builder(
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/product',
                      arguments: {'cid': this._rightContentList[index].sId});
                },
                child: Container(
                  width: rightItemWidth,
                  color: Colors.white,
                  // padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Image.network(
                          Tools.formatImgUrl(this._rightContentList[index].pic),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Text(
                          this._rightContentList[index].title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            itemCount: this._rightContentList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1 / 1.5,
            ),
          ),
        ),
      );
    } else {
      return Expanded(
        flex: 1,
        child: Container(
          height: double.infinity,
          padding: EdgeInsets.all(10),
          child: Text(''),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdaper.init(context);
    var leftWidth = ScreenAdaper.getScreenWidth() / 4;
    var rightItemWidth = (ScreenAdaper.getScreenWidth() - leftWidth - 40) / 3;
    return Row(
      children: [
        _leftCateWidget(leftWidth),
        _rightContentWidget(rightItemWidth),
      ],
    );
  }
}
