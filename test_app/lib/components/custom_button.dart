import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const CustomButton({
    super.key, required this.text, 
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 40), 
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0),),),
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),),);
  }
}

