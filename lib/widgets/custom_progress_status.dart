import 'package:flutter/material.dart';

class CustomProgressIcon extends StatelessWidget {
  final double size;
  final Color color;

  const CustomProgressIcon({
    Key? key,
    this.size = 15,
    this.color = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color),
        strokeWidth: 4,
      ),
    );
  }
}
