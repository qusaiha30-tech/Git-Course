import 'package:flutter/material.dart';

class Custombotton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  const Custombotton({super.key, required this.text, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      textColor: Colors.white,
      color: Colors.blueAccent[400],
      height: 40,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      child: Text(text),
    );
  } // تم إضافة قوس الإغلاق الخاص بدالة build هنا
}
