import 'package:flutter/material.dart';

class CustomTab extends StatelessWidget {
  final String text;
  final bool? selected;
  final double? size;

  const CustomTab(
      {Key? key,
      required this.text,
      required this.selected,
      required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Tab(
        child: Text(
          text,
          style: TextStyle(
            fontSize: size,
            color: selected == true ? Theme.of(context).primaryColor : null,
            fontWeight: selected == true ? FontWeight.bold : null,
          ),
        ),
      ),
    );
  }
}
