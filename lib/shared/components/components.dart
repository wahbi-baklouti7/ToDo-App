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
              // color: (taskList["id"] == taskList[indexTask]["id"])
              //     ? Colors.green
              //     : Colors.black,
              onPressed: () {
                print("Task id: ${taskList["id"]}");
                print("indexTaskId: $indexTask");
                AppCubit.get(context).buttonCheckState(newState: true);
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

            // Icon(Icons.delete_forever,color: Colors.red,),
          ],
        ),
      ),
    ),
    onDismissed: (direction) {
      AppCubit.get(context).deleteTask(id: taskList["id"]);
    },
  );
}
