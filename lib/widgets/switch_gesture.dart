import 'package:flutter/material.dart';

class SwitchGesture extends StatelessWidget {
  final String text;
  final bool? selected;
  final VoidCallback onTap;

  const SwitchGesture(
    this.text, {
    Key? key,
    required this.onTap,
    this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          color: selected == true ? Theme.of(context).primaryColor : null,
          fontWeight: selected == true ? FontWeight.bold : null,
        ),
      ),
    );
  }
}
