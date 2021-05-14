import 'package:flutter/material.dart';
import 'package:todo_app/bloc/cubit.dart';
import 'package:todo_app/bloc/state.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        return ListView.separated(
          separatorBuilder: (BuildContext context, index) => Divider(
            thickness: 0.5,
          ),
          itemCount: AppCubit.get(context).tasks.length,
          itemBuilder: (context, index) => buildContainerTask(
              taskList: AppCubit.get(context).tasks[index],
              onPressed: () {
                AppCubit.get(context).deleteTask(
                    taskIndex: AppCubit.get(context).tasks[index]["id"]);
              }),
        );
      },
    );
  }
}
