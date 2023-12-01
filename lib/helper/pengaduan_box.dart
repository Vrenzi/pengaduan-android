import 'package:flutter/material.dart';

class PengaduanBox extends StatelessWidget {
  final String title;
  final String imagePath;

  const PengaduanBox({
    required this.title,
    required this.imagePath,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Image.asset(
            imagePath,
            width: 80,
            height: 80,
            // Adjust width and height according to your design
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}
