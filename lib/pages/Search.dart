import 'package:flutter/material.dart';
import '../services/ScreenAdaper.dart';

class SearchPage extends StatefulWidget {
  String keyword;
  SearchPage({Key key, this.keyword}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: ScreenAdaper.height(60),
          padding: EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none),
            ),
          ),
        ),
        actions: [
          Container(
            height: ScreenAdaper.height(68),
            child: Text('搜索'),
          )
        ],
      ),
      body: Container(
        child: Text(''),
      ),
    );
  }
}
