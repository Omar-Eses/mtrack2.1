import 'package:flutter/material.dart';

class UserWidget extends StatefulWidget {
  final String name;
  final String email;
  final String imageUrl;
  final void Function() onPressed;

  const UserWidget({
    Key? key,
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.onPressed,
  }) : super(key: key);

  @override
  _UserWidgetState createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.5),
        color: Theme.of(context).primaryColorLight,
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(widget.imageUrl),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.email,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: widget.onPressed,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
