import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 20,
              height: 20,
              margin: EdgeInsets.only(right: 10),
              child: CircularProgressIndicator(
                strokeWidth: 1,
              ),
            ),
            Text('加载中...', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
