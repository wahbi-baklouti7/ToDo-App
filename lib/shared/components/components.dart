import 'package:flutter/material.dart';

class DefaultFormValidation extends StatelessWidget {
  @required
  TextEditingController textController;
  @required
  String label;
  @required
  TextInputType type;
  @required
  Function onTap;
  @required
  IconData prefix;

  @required
  Function validate;

  DefaultFormValidation(
      {this.label, this.onTap, this.validate, this.textController, this.type,this.prefix});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      validator: validate,
      keyboardType: type,
      onTap: onTap,
      
      
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(width: 2),
            borderRadius: BorderRadius.circular(10)),
        labelText: label,
        prefixIcon:Icon(prefix),
      ),
      
    );
  }
}
