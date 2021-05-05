import 'package:flutter/material.dart';

class ArchivedScreen extends StatefulWidget {
  @override
  _ArchivedScreenState createState() => _ArchivedScreenState();
}

class _ArchivedScreenState extends State<ArchivedScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("Archived",style: TextStyle(fontSize: 40,color: Colors.black),)),
    );
  }
}
