import 'package:flutter/material.dart';
import 'package:fox_tales/data/colors.dart';

class Button extends StatelessWidget {
  final String label;
  final void Function() onPressed;

  const Button(this.label, this.onPressed, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(primary),
          foregroundColor: MaterialStateProperty.all(Colors.white),
        ),
        child: Text(label),
      ),
    );
  }
}
