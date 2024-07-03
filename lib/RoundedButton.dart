import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  Color colour;
  VoidCallback fun;
  String text;
   RoundedButton({super.key,required this.colour,required this.fun,required this.text});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        elevation: 5.0,
        child: MaterialButton(
          onPressed: fun,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            text
          ),
        ),
      ),
    );
  }
}
