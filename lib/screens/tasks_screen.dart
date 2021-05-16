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
        var tasks= AppCubit.get(context).newTasks;
        return ListView.separated(

          
          separatorBuilder: (BuildContext context, index) => Divider(
            thickness: 0.5,
          ),

          itemCount: tasks.length,
          itemBuilder: (context, index) => buildContainerTask(
              taskList:tasks[index],
              context: context,
              colorCheckBox:AppCubit.get(context).buttonIsChecked?Colors.green:Colors.black,
              iconBox: AppCubit.get(context).buttonIsChecked? Icons.check_box:Icons.check_box_outline_blank,
              indexTask: index,
              ),
        );
      },
    );
  }
}
