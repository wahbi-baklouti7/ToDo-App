import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/cubit.dart';
import 'package:todo_app/bloc/state.dart';
import 'package:todo_app/shared/components/components.dart';


class DoneScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        return ListView.separated(
          separatorBuilder: (BuildContext context, index) => Divider(
            thickness: 0.5,
          ),
          itemCount: AppCubit.get(context).doneTasks.length,
          itemBuilder: (context, index) => buildContainerTask(
              taskList: AppCubit.get(context).doneTasks[index],context: context,
              onPressed: () {
                AppCubit.get(context).deleteTask(
                    taskIndex: AppCubit.get(context).doneTasks[index]["id"]);
              }),
        );
      },
    );
  }
}
