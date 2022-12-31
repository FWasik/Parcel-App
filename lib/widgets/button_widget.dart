import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton(
      {required Text this.text,
      required Color this.color,
      required GestureTapCallback this.onPressed,
      required Icon this.icon,
      required double this.width});

  final GestureTapCallback onPressed;
  final Color color;
  final Text text;
  final Icon icon;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * width,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            backgroundColor: color, minimumSize: const Size.fromHeight(50)),
        icon: icon,
        label: text,
        onPressed: onPressed,
      ),
    );
  }
}
