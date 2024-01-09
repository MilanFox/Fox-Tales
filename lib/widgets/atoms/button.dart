import 'package:flutter/material.dart';
import 'package:fox_tales/data/colors.dart';

class Button extends StatelessWidget {
  final String label;
  final void Function() onPressed;

  const Button(this.label, this.onPressed, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(primary),
          foregroundColor: MaterialStateProperty.all(Colors.white),
        ),
      ),
    );
  }
}
