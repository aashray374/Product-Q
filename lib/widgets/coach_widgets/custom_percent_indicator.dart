import 'package:flutter/material.dart';

class CustomPercentIndicator extends StatelessWidget {
  const CustomPercentIndicator(
      {super.key,
      required this.percent,
      required this.progressColor,
      required this.centerText});

  final double percent;
  final Color progressColor;
  final String centerText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Concept',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Container(
          color: Colors.grey,
          width: double.infinity,
          height: 20,
          child: Stack(
            children: [
              Container(
                color: Colors.grey[300], // Background color
              ),
              Container(
                width: 0.9 * MediaQuery.of(context).size.width, // 90% width
                color: Colors.blue, // Progress color
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Text(
          'Practical',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Container(
          width: double.infinity,
          height: 20,
          child: Stack(
            children: [
              Container(
                color: Colors.grey[300], // Background color
              ),
              Container(
                width: 0.7 * MediaQuery.of(context).size.width, // 70% width
                color: Colors.green, // Progress color
              ),
            ],
          ),
        ),
        // Add more titles and progress containers as needed
      ],
    );

  }
}
