import 'package:flutter/material.dart';

class DoneScreen extends StatefulWidget {
  @override
  _DoneScreenState createState() => _DoneScreenState();
}

class _DoneScreenState extends State<DoneScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("Done",style: TextStyle(fontSize: 40,color: Colors.black),)),
    );
  }
}
