import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelTxt;
  final double width;
  final double height;
  final bool isobscure;
  final Color backgroundColor;
  final IconData fixedIcon;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final void Function(String)? onFieldSubmitted;

  const CustomTextFormField({
    Key? key,
    required this.labelTxt,
    this.width = 110,
    this.height = 55.0,
    this.validator,
    this.isobscure = false,
    required this.fixedIcon,
    this.keyboardType = TextInputType.text,
    this.backgroundColor = Colors.white,
    this.onSaved,
    this.controller,
    this.onFieldSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        validator: validator,
        onSaved: onSaved,
        obscureText: isobscure,
        keyboardType: keyboardType,
        controller: controller,
        onFieldSubmitted: onFieldSubmitted,
        decoration: InputDecoration(
          labelText: labelTxt,
          prefixIcon: Icon(fixedIcon),
          border: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
