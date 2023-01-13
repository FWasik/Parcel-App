import 'package:flutter/material.dart';

class SwitchGesture extends StatelessWidget {
  final String text;
  final bool? selected;
  final VoidCallback onTap;
  final double? size;

  const SwitchGesture(
      {Key? key,
      required this.text,
      required this.onTap,
      required this.selected,
      required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: size,
          color: selected == true ? Theme.of(context).primaryColor : null,
          fontWeight: selected == true ? FontWeight.bold : null,
        ),
      ),
    );
  }
}
