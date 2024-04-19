import 'package:flutter/material.dart';
import 'package:watermel/app/utils/theme/fonts.dart';

class MyText extends StatelessWidget {
  String? text_name;
  double? txtfontsize;
  Color? txtcolor;
  FontWeight? fontWeight;
  String? myFont;
  TextAlign txtAlign;
  double? lineHeight;
  dynamic textOverflow;
  dynamic maxline;

  MyText(
      {this.text_name,
      this.txtcolor,
      this.txtfontsize,
      this.fontWeight,
      this.myFont = Fonts.poppins,
      this.txtAlign = TextAlign.center,
      this.lineHeight = 0,
      this.maxline,
      this.textOverflow = TextOverflow.visible});

  @override
  Widget build(BuildContext context) {
    return Text(
      text_name!,
      textAlign: txtAlign,
      overflow: textOverflow,
      maxLines: maxline,
      style: TextStyle(
        height: lineHeight,
        decoration: TextDecoration.none,
        color: txtcolor,
        fontSize: txtfontsize,
        fontWeight: fontWeight,
        fontFamily: myFont,
      ),
    );
  }
}
