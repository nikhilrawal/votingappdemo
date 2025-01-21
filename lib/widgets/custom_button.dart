import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function? onPressed;
  final bool isLoading;

  CustomButton({
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading
          ? null
          : onPressed != null
              ? () => onPressed!()
              : null,
      child: isLoading
          ? CircularProgressIndicator(color: Colors.white)
          : Text(text),
    );
  }
}
