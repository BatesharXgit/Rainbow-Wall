import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SquareTile extends StatelessWidget {
  final String imagePath;
  final String text;
  final Function()? onTap;
  const SquareTile(
      {super.key,
      required this.imagePath,
      required this.onTap,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: Color(0xFFE6EDFF),
        ),
        child: Row(
          children: [
            Image.asset(
              imagePath,
              height: 30,
            ),
            SizedBox(width: 10),
            Text(
              text,
              style: GoogleFonts.kanit(fontSize: 20, color: Color(0xFF1E1E2A)),
            ),
          ],
        ),
      ),
    );
  }
}
