import 'package:flutter/material.dart';
import '../pages/tabs/Tabs.dart';
import '../pages/search/Search.dart';
import '../pages/productList/ProductList.dart';
import '../pages/productDetail/productDetail.dart';

// 添加路由路径
final routes = {
  '/': (context) => Tabs(),
  '/search': (context) => SearchPage(),
  '/product': (context, {arguments}) => ProductListPage(arguments: arguments),
  '/product-detail': (context, {arguments}) =>
      ProductDetailPage(id: arguments['id']),
};

// 固定写法
var onGenerateRoute = (RouteSettings settings) {
  // 统一处理
  final String name = settings.name;
  final Function pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
          builder: (context) =>
              pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {
      final Route route =
          MaterialPageRoute(builder: (context) => pageContentBuilder(context));
      return route;
    }
  }
};
