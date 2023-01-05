import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key,
      required this.text,
      required this.color,
      required this.onPressed,
      required this.icon,
      required this.width})
      : super(key: key);

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

class CustomDeletePackageButton extends StatelessWidget {
  final GestureTapCallback onPressed;

  const CustomDeletePackageButton({Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        child: const Icon(
          Icons.delete,
        ),
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red, fixedSize: const Size(10, 20)));
  }
}
