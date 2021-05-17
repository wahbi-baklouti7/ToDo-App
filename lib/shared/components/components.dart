import 'package:flutter/material.dart';
import 'package:todo_app/bloc/cubit.dart';

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

Widget buildContainerTask({
  Map taskList,
  context,
  int indexTask,
  Color colorCheckBox = Colors.black,
  IconData iconBox = Icons.check_box_outline_blank_outlined,
}) {
  return Dismissible(
    key: UniqueKey(),
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    taskList["Time"],
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
                  taskList["Title"],
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(taskList["Date"],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    )),
              ],
            ),
            Spacer(),
            IconButton(
              icon: Icon(iconBox, size: 30),
              color:(taskList["Status"]!="New")?Colors.green:Colors.black,
              // color:(AppCubit.get(context).buttonCheckState()==taskList["id"])?Colors.green:Colors.black,
              onPressed: () {
                print("Task id: ${taskList["id"]}");
                print("indexTaskId: $indexTask");
                AppCubit.get(context).buttonCheckState(newState:true );
                AppCubit.get(context)
                    .updateDatabase(newStatus: "Done", id: taskList["id"]);
              },
            ),
            IconButton(
              icon: Icon(
                  AppCubit.get(context).buttonArchive
                      ? Icons.archive
                      : Icons.archive_outlined,
                  size: 30),
              onPressed: () {
                AppCubit.get(context).buttonArchiveState(newState: true);

                AppCubit.get(context)
                    .updateDatabase(newStatus: "Archive", id: taskList["id"]);
              },
            )

          ],
        ),
      ),
    ),
    onDismissed: (direction) {
      AppCubit.get(context).deleteTask(id: taskList["id"]);
    },
  );
}

Widget emptyScreen() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Add Task",
            style: TextStyle(
              fontSize: 40,
              color: Colors.grey,
            )),
            Icon(Icons.add_circle_outline,size: 50,color: Colors.grey,)
      ],
    ),
  );
}


Widget taskBuilder({
  @required tasks
}){
  if (tasks.length <= 0) {
          return emptyScreen();
        } else {
          return ListView.separated(
            separatorBuilder: (BuildContext context, index) => Divider(
              thickness: 0.5,
            ),
            itemCount: tasks.length,
            itemBuilder: (context, index) => buildContainerTask(
              taskList: tasks[index],
              context: context,
              // colorCheckBox:(AppCubit.get(context).buttonCheckState()==tasks[index]["id"])?Colors.green:Colors.black,
              iconBox: AppCubit.get(context).buttonIsChecked
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
              indexTask: index,
            ),
          );
        }
}
