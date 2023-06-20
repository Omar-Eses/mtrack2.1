import 'package:flutter/material.dart';
import 'package:mtrack/provider/theme_view_model.dart';
import 'package:provider/provider.dart';

class CustomSwitchButton extends StatelessWidget {
  const CustomSwitchButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Switch(
      value: themeProvider.getDarkTheme,
      onChanged: (value) => themeProvider.toggleTheme(),
    );
  }
}
