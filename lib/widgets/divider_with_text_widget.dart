import 'package:flutter/material.dart';

class DividerWithTextWidget extends StatelessWidget {
  const DividerWithTextWidget({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
          child: Divider(
        color: Colors.blueGrey.shade300,
      )),
      Text(text,
          style: const TextStyle(
            color: Colors.white,
          )),
      Expanded(
          child: Divider(
        color: Colors.blueGrey.shade300,
      )),
    ]);
  }
}
