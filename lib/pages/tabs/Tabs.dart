import 'package:flutter/material.dart';
import 'package:jdshop/services/ScreenAdaper.dart';
import 'Cart.dart';
import 'Home.dart';
import 'Category.dart';
import 'User.dart';

class Tabs extends StatefulWidget {
  Tabs({Key key}) : super(key: key);

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int _currentIndex = 0;
  List<Widget> _pageList = [HomePage(), CategoryPage(), CartPage(), UserPage()];
  PageController _pageController;
  @override
  void initState() {
    this._pageController = new PageController(initialPage: this._currentIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex != 3
          ? AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.center_focus_weak,
                  color: Colors.black54,
                ),
                onPressed: () {},
              ),
              title: InkWell(
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, size: 25, color: Colors.black12),
                      Text(
                        '笔记本电脑',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/search');
                },
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.message,
                    color: Colors.black54,
                  ),
                  onPressed: () {},
                ),
              ],
              centerTitle: true,
            )
          : AppBar(centerTitle: true, title: Text('个人中心')),
      // body: _pageList[_currentIndex],
      // IndexedStack方法让页面层叠，缺点：刚进来的时候会加载全部层叠的页面数据
      /* body: IndexedStack(
        index: _currentIndex,
        children: this._pageList,
      ), */
      body: PageView(
        controller: this._pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        // 禁止滑动
        // physics: NeverScrollableScrollPhysics(),
        children: this._pageList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            this._pageController.jumpToPage(index);
          });
        },
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.red,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('首页'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            title: Text('分类'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text('购物车'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            title: Text('我的'),
          ),
        ],
      ),
    );
  }
}
