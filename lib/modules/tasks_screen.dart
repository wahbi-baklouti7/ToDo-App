import 'package:flutter/material.dart';

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("Tasks",style: TextStyle(fontSize: 40,color: Colors.black),)),
    );
  }
}
