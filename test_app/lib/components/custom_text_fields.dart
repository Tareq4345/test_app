import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
   
  const CustomTextField({
    super.key,
    required TextEditingController controller, required label,
  }) : _controller = controller, _label = label;

  final TextEditingController _controller;
  final String _label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: const BoxDecoration(
        
      ),
      child: TextFormField(
        controller: _controller,
        decoration:  InputDecoration(
          focusedBorder:const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black38),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(),
          ),
          fillColor: Colors.white10,
          filled: true,
          label: Text(_label)
                      
        ),
                      
      ),
    );
  }
}