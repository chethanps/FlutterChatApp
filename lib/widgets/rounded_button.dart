import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final Function onPressed;
  final double height;
  final double minWidth;

  RoundedButton(
      {this.buttonText,
      this.buttonColor,
      this.onPressed,
      this.height = 42.0,
      this.minWidth = 22.0});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        color: buttonColor,
        borderRadius: BorderRadius.circular(30.0),
        elevation: 5.0,
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: minWidth,
          height: height,
          child: Text(buttonText),
        ),
      ),
    );
  }
}
