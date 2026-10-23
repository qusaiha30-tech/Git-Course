import 'package:flutter/material.dart';

class Signinmethod extends StatelessWidget {
  final String imagePath;
  final VoidCallback? onTap;
  const Signinmethod({super.key, required this.imagePath, this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 50,
        height: 50,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.asset(imagePath, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
