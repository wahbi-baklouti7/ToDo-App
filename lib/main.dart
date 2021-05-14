import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/bloc/bloc_observe/bloc_observe.dart';
import 'layouts/home_layout.dart';

void main() {
  runApp(TodoApp());
  Bloc.observer = MyBlocObserver();
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Todo App",
      home: HomeLayout(),
    );
  }
}
