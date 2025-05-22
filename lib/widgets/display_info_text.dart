import 'package:flutter/material.dart';

class DisplayInfoText extends StatelessWidget {
  const DisplayInfoText({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: '$title: ',
        style: TextStyle(color: Colors.black45),
        children: [
          TextSpan(
            text: value,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
