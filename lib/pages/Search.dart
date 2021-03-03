import 'dart:convert';

import 'package:flutter/material.dart';
import '../storage/storage.dart';
import '../services/ScreenAdaper.dart';
import 'dart:async';
import '../utils/tools.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _keywordControler;
  bool _isKeywordEmpty = true;
  String _keyword = '';
  List _history = [];

  // 提交
  void search() {
    if (_isKeywordEmpty) return;
    List tempHistory = [];
    _history.insert(0, this._keyword);
    _history.forEach((value) {
      if (!tempHistory.contains(value)) {
        tempHistory.add(value);
      }
    });
    setStorage('historyList', tempHistory.toString());
    setState(() {
      _history = tempHistory;
    });
    Navigator.pushNamed(context, '/product',
        arguments: {'keyword': this._keyword});
  }

  @override
  void initState() {
    super.initState();
    // 获取缓存数据
    getStorage('historyList').then((value) {
      List history = value.split(',');
      print(history.runtimeType.toString());
      print(history);
      setState(() {
        _history = value ?? [];
      });
    });
    _keywordControler = new TextEditingController(text: '');
  }

  void dispose() {
    _keywordControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: ScreenAdaper.width(540),
          height: ScreenAdaper.height(60),
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          child: TextField(
              maxLines: 1,
              autofocus: true,
              controller: _keywordControler,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none),
              ),
              onChanged: (value) {
                setState(() {
                  this._keyword = value;
                  this._isKeywordEmpty = this._keyword == '';
                });
              },
              onSubmitted: (value) {
                setState(() {
                  this._keyword = value;
                  this._isKeywordEmpty = this._keyword == '';
                });
                this.search();
              }),
        ),
        centerTitle: true,
        actions: [
          Container(
            width: 60,
            height: 60,
            child: Center(
              child: InkWell(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      '搜索',
                      style: TextStyle(
                          color: this._isKeywordEmpty
                              ? Colors.black26
                              : Colors.black),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      this._keyword = _keywordControler.text;
                      this._isKeywordEmpty = this._keyword == '';
                    });
                    this.search();
                  }),
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(ScreenAdaper.width(20)),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    width: ScreenAdaper.width(10),
                    height: 20,
                    color: Colors.red,
                    margin: EdgeInsets.only(right: 10),
                  ),
                  Text(
                    '历史搜索',
                    style: TextStyle(color: Colors.black54),
                  )
                ],
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.black26),
                onPressed: () {
                  setState(() {
                    this._history = [];
                  });
                },
              )
            ],
          ),
          Container(
            width: double.infinity,
            child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: this._history.length > 0
                    ? this._history.map((item) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              this._keyword = item;
                              _keywordControler.text = item;
                              this._isKeywordEmpty = this._keyword == '';
                            });
                            this.search();
                          },
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10, 4, 10, 4),
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(item),
                          ),
                        );
                      }).toList()
                    : [
                        Container(
                          child: Center(
                            child: Text('暂无历史搜索记录'),
                          ),
                        ),
                      ]),
          ),
        ]),
      ),
    );
  }
}
