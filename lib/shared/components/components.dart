import 'package:flutter/material.dart';

class DefaultFormValidation extends StatelessWidget {
  @required TextEditingController textController;
  @required String label;
  @required TextInputType type;
  @required Function onTap;
  @required IconData prefix;
  @required Function validate;

  DefaultFormValidation(
      {this.label,
      this.onTap,
      this.validate,
      this.textController,
      this.type,
      this.prefix});

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
        prefixIcon: Icon(prefix),
      ),
    );
  }
}



Widget buildContainerTask( Map map) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
    child: Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(

              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  map["Time"],
                  style: TextStyle(color: Colors.white),
                ),
              ),
              radius: 30,
              backgroundColor: Colors.blue[300]),
          SizedBox(
            width: 15,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                map["Title"],
                style: TextStyle(fontSize: 20),
              ),SizedBox(
            height: 4,
          ),
              Text(map["Date"],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ))
            ],
          )
        ],
      ),
    ),
  );
}
