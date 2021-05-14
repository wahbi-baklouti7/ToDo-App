import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/bloc/cubit.dart';
import 'package:todo_app/bloc/state.dart';
import 'package:todo_app/shared/components/components.dart';

class HomeLayout extends StatelessWidget {
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  var _formKey = GlobalKey<FormState>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppState>(
          listener: (BuildContext context, AppState state) {
        if (state is AppInsertIntoDatabase) {
          Navigator.pop(context);
        }
      }, builder: (BuildContext context, AppState state) {
        AppCubit cubit = AppCubit.get(context);

        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text("Todo App"),
            centerTitle: true,
            backgroundColor: Colors.amber[500],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.amber[500],
            onPressed: () {
              if (cubit.isBottomSheetShown) {
                if (_formKey.currentState.validate()) {
                  cubit.insertIntoDatabase(
                      title: titleController.text,
                      date: dateController.text,
                      time: timeController.text);

                  cubit.changeButtonState(isShow: false, icon: Icons.edit);
                }
              } else {
                _scaffoldKey.currentState
                    .showBottomSheet((context) {
                      return Container(
                        padding: EdgeInsets.all(15),
                        // color: Colors.blue[400],
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              DefaultFormValidation(
                                label: "Title",
                                prefix: Icons.title,
                                textController: titleController,
                                type: TextInputType.name,
                                validate: (value) {
                                  if (value.isEmpty) {
                                    return "Title must be written";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              DefaultFormValidation(
                                label: "Time",
                                prefix: Icons.access_time,
                                textController: timeController,
                                type: TextInputType.datetime,
                                onTap: () async {
                                  final TimeOfDay pickedTime =
                                      await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                    builder:
                                        (BuildContext context, Widget child) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                            alwaysUse24HourFormat: true),
                                        child: child,
                                      );
                                    },
                                  );

                                  timeController.text =
                                      pickedTime.format(context);
                                },
                                validate: (value) {
                                  if (value.isEmpty) {
                                    return "Time must be selected";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              DefaultFormValidation(
                                label: "Date",
                                prefix: Icons.date_range_rounded,
                                textController: dateController,
                                type: TextInputType.datetime,
                                onTap: () {
                                  showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime(2100))
                                      .then((value) {
                                    dateController.text =
                                        DateFormat("dd-MM-yyyy").format(value);
                                  });
                                },
                                validate: (value) {
                                  if (value.isEmpty) {
                                    return "Date must be selected";
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    })
                    .closed
                    .then((value) {
                      cubit.changeButtonState(isShow: false, icon: Icons.edit);
                    });
                cubit.changeButtonState(isShow: true, icon: Icons.add);
              }

              // insertIntoDatabase();
            },
            child: Icon(cubit.flatIcon),
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.blue[500],
            currentIndex: cubit.selectedScreen,
            onTap: (item) {
              cubit.getCurrentScreenIndex(item);
            },
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.format_list_bulleted),
                label: "Tasks",
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outlined), label: "Done"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined), label: "Archived")
            ],
          ),
          body: ConditionalBuilder(
              condition: true,
              builder: (context) => cubit.screens[cubit.selectedScreen],
              fallback: (context) =>
                  Center(child: CircularProgressIndicator())),
        );
      }),
    );
  }
}
