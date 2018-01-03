import 'package:flutter/material.dart';

class PillButton extends StatelessWidget {
  String text;
  Color textColor;
  Color backgroundColor;
  VoidCallback onPressed;

  PillButton({
    this.text,
    this.textColor,
    this.backgroundColor,
    this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return new ClipRRect(
      borderRadius: new BorderRadius.circular(30.0),
      child: new RaisedButton(
        color: this.backgroundColor,
        onPressed: this.onPressed,
        child: new Padding(
          padding: new EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
          child: new Text(
            this.text,
            style: new TextStyle(
              color: this.textColor,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
    );
  }
}