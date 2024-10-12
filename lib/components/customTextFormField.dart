// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final String label;
  final String hint;
  final Function(String)? onChanged;
  final FormFieldValidator<String>? validator;
  final Function(String?)? onSaved;
  final bool obscureText;

  const CustomTextFormField({
    super.key,
    required this.label,
    required this.hint,
    this.onChanged,
    this.validator,
    this.onSaved,
    this.obscureText = false,
  });

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0, bottom: 10),
            child: Text(
              widget.label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            obscureText: widget.obscureText && !showPassword,
            onSaved: widget.onSaved,
            validator: widget.validator,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFAEBED4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide.none,
              ),
              hintStyle: const TextStyle(color: Colors.white38),
              hintText: widget.hint,
              suffixIcon: widget.obscureText
                  ? IconButton(
                      icon: Icon(
                        showPassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
