import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.labelTxt,
    required this.fixedIcon,
    this.width = 200,
    this.height = 50,
    this.keyboardType = TextInputType.text,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  final String labelTxt;
  final double width;
  final double height;
  final IconData fixedIcon;
  final TextInputType keyboardType;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelTxt,
          prefixIcon: Icon(fixedIcon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
