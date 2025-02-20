import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final VoidCallback? toggleObscure;
  final Widget? suffixIcon;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.suffixIcon,
    this.toggleObscure,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      child: SizedBox(
        height: 48,
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            hintText: hintText,
            suffixIcon: toggleObscure != null
                ? IconButton(
                    icon: Icon(
                      obscureText
                          ? LineAwesomeIcons.eye_slash
                          : LineAwesomeIcons.eye,
                    ),
                    onPressed: toggleObscure,
                  )
                : suffixIcon, // ใช้ suffixIcon ถ้ามี
          ),
        ),
      ),
    );
  }
}
