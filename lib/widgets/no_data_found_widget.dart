import 'package:flutter/material.dart';

class NoDataFound extends StatelessWidget {
  const NoDataFound({Key? key, required String this.additionalText})
      : super(key: key);

  final String additionalText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "No data found",
            style: TextStyle(fontSize: 25),
          ),
          const SizedBox(height: 10),
          Text(additionalText, style: TextStyle(fontSize: 15)),
          const SizedBox(
            height: 20,
          ),
          const Icon(
            Icons.file_copy,
            size: 60,
          )
        ],
      ),
    );
  }
}
