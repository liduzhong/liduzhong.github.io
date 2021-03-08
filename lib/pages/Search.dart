import 'package:flutter/material.dart';
import '../storage/storage.dart';
import '../services/ScreenAdaper.dart';
import '../utils/event_bus.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _keywordControler;
  bool _isKeywordEmpty = true;
  String _keyword = '';
  List _historysList = [];

  @override
  void initState() {
    super.initState();
    // 获取缓存数据
    _getHistory();
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
        title: _buildTitle(),
        centerTitle: true,
        actions: [_buildAction()],
      ),
      body: _buildContent(),
    );
  }

  // 获取历史记录
  void _getHistory() async {
    var value = await Storage.getString('historyList');
    List<String> historys = value?.split(',') ?? [];
    print(historys.runtimeType.toString());
    print(historys);
    setState(() {
      _historysList = historys;
    });
  }

  // 搜索
  void search() async {
    if (_isKeywordEmpty) return;
    List<String> tempHistory = [];
    _historysList.insert(0, this._keyword);
    _historysList.forEach((value) {
      if (!tempHistory.contains(value)) {
        tempHistory.add(value);
      }
    });
    await Storage.setString('historyList', tempHistory.join(','));
    EventBusUtils.getInstance().fire(ChangeSearchWord(this._keyword));
    setState(() {
      _historysList = tempHistory;
    });
    Navigator.pushNamed(context, '/product',
        arguments: {'keyword': this._keyword});
  }

  //搜索框
  Widget _buildTitle() {
    return Container(
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
    );
  }

  //搜索按钮
  Widget _buildAction() {
    return Container(
      width: 60,
      height: 60,
      child: Center(
        child: InkWell(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                '搜索',
                style: TextStyle(
                    color:
                        this._isKeywordEmpty ? Colors.black26 : Colors.black),
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
    );
  }

  // 内容
  Widget _buildContent() {
    return Container(
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
                Storage.remove('historyList');
                setState(() {
                  this._historysList = [];
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
              children: this._historysList.length > 0
                  ? this._historysList.map((item) {
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
    );
  }
}
