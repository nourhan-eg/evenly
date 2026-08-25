import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final String? prefixImageAsset;
  final Widget? suffixIcon;
  final IconData? prefixIconData;
  final bool isPassword;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final int maxLines ;

  const CustomTextField({
    super.key,
    this.controller,
    this.onChanged,
    this.suffixIcon,
    required this.hintText,
    this.prefixImageAsset,
    this.prefixIconData,
    this.isPassword = false,
    this.validator,
    this.keyboardType,
    this.maxLines=1,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    final iconColor = isDark ? Colors.white70 : Colors.grey.shade500;

    Widget? prefixWidget;
    if (widget.prefixImageAsset != null) {
      prefixWidget = Padding(
        padding: const EdgeInsets.all(12.0),
        child: Image.asset(
          widget.prefixImageAsset!,
          width: 20,
          height: 20,
          color: iconColor,
        ),
      );
    } else if (widget.prefixIconData != null) {
      prefixWidget = Icon(
        widget.prefixIconData,
        color: iconColor,
        size: 22,
      );
    }

    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      maxLines: widget.maxLines,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontSize: 16,
            color: isDark ? Colors.white : Colors.black87,
          ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: isDark ? Colors.white38 : Colors.grey.shade400,
          fontSize: 15,
        ),
        prefixIcon: prefixWidget,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: iconColor,
                  size: 22,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
        filled: true,
        fillColor: isDark ? const Color(0xFF002D8F) : Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF002D8F) : Colors.grey.shade300,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: primaryColor,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
