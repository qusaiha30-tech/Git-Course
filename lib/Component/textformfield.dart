import 'package:flutter/material.dart';

class CustomTextForm extends StatefulWidget {
  final String hinttext;
  final TextEditingController mycontroller;
  final String title;
  final IconData? suffixIcon;
  final TextInputType? kekeyboardtype;
  final bool obscureText;
  final FormFieldValidator<String>? validator;

  const CustomTextForm({
    super.key,
    required this.hinttext,
    required this.mycontroller,
    required this.title,
    this.suffixIcon,
    this.kekeyboardtype,
    required this.obscureText,
    this.validator,
  });

  @override
  State<CustomTextForm> createState() => _CustomTextFormState();
}

class _CustomTextFormState extends State<CustomTextForm> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 10),
        TextFormField(
          validator: widget.validator,
          controller: widget.mycontroller,
          keyboardType: widget.kekeyboardtype ?? TextInputType.text,
          obscureText: _obscureText,
          decoration: InputDecoration(
            suffixIcon: widget.suffixIcon != null
                ? IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_off_rounded
                          : widget.suffixIcon,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
            hintText: widget.hinttext,
            hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
          ),
        ),
      ],
    );
  }
}
