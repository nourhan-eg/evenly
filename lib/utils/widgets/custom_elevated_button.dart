import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final Widget? icon;

  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textStyle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    var label = Text(
      text,
      style:
          textStyle ??
          Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white),
    );
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      onPressed: onPressed,
      child: icon == null
          ? label
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [icon!, SizedBox(width: 18), label],
            ),
    );
  }
}
