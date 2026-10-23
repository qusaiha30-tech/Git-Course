import 'package:flutter/material.dart';

class Logoauth extends StatelessWidget {
  // تم تصحيح الأقواس وإضافة الفاصلة المنقوطة هنا
  const Logoauth({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 70,
        width: 70,
        padding: EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(50),
        ),
        child: Image.asset(
          "images/Logo.jpeg",
          width: 40,
          height: 40,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
