import 'package:flutter/material.dart';

enum SnakeBarStatus {
  success,
  error,
  note;

  Color color() {
    switch (this) {
      case SnakeBarStatus.error:
        return Colors.red;
      case SnakeBarStatus.success:
        return Colors.green;
      case SnakeBarStatus.note:
        return Colors.blue;
    }
  }
}
