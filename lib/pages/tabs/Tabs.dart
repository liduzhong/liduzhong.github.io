import 'dart:async';

import 'package:flutter/material.dart';
import '../../utils/event_bus.dart';
import '../../storage/storage.dart';
import '../../services/ScreenAdaper.dart';
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
  String _history = '';
  StreamSubscription listen;

  @override
  void initState() {
    super.initState();
    // 监听搜索
    listen = EventBusUtils.getInstance().on<ChangeSearchWord>().listen((event) {
      _history = event.keyword;
      setState(() {
        _history = _history;
      });
    });
    _getHistory();
    this._pageController = new PageController(initialPage: this._currentIndex);
  }

  @override
  void dispose() {
    super.dispose();
    listen?.cancel();
  }

  // 获取历史记录
  void _getHistory() async {
    // 获取缓存搜索历史数据
    var history = await Storage.getString('historyList');
    _history = history != null ? history?.split(',')[0] : '';
    setState(() {
      _history = _history;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
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
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // appbar
  Widget _buildAppBar() {
    return _currentIndex != 3
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
                      _history,
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
        : AppBar(
            centerTitle: true,
            title: Text('个人中心'),
          );
  }

  // 底部菜单导航
  Widget _buildBottomNav() {
    return BottomNavigationBar(
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
    );
  }
}
