import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String label;
  final void Function() onPressed;

  const Button(this.label, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
