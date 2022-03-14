import 'package:flutter/material.dart';

import '../../res/colors.dart';

class TextBox extends StatelessWidget {
  const TextBox({
    Key? key,
    required this.width,
    required this.marginLeft,
    required this.text,
  }) : super(key: key);

  //Widgetのパラメータ
  final double width;
  final double marginLeft;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      margin: EdgeInsets.only(left: marginLeft),
      decoration: BoxDecoration(
        color: buttonNormal,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: textWhite,
            // fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class DialogTextBox extends StatelessWidget {
  const DialogTextBox({
    Key? key,
    required this.width,
    required this.text,
    required this.data,
  }) : super(key: key);

  //Widgetのパラメータ
  final double width;
  final String text;
  final dynamic data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      decoration: BoxDecoration(
        color: buttonNormal,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: const TextStyle(
              color: textWhite,
              // fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '$data',
            style: const TextStyle(
              color: textWhite,
              // fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(),
        ],
      ),
    );
  }
}
