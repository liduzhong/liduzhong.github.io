import 'package:flutter/material.dart';
import 'package:jdshop/services/ScreenAdapter.dart';

class CommonBtn extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final double radius;
  final double fontSize;
  final Color color;
  final Color bgColor;
  final Object onTap;
  CommonBtn(
      {Key key,
      this.text = '',
      this.width = double.infinity,
      this.height = 40,
      this.radius = 10,
      this.fontSize = 16,
      this.color = Colors.white,
      this.bgColor,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        alignment: Alignment.center,
        height: height,
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Text(
          text,
          style: TextStyle(color: color, fontSize: fontSize, letterSpacing: 2),
        ),
      ),
    );
  }
}
