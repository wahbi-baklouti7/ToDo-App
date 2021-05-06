import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archieved_screen.dart';
import 'package:todo_app/modules/done_screen.dart';
import 'package:todo_app/modules/tasks_screen.dart';
import 'package:todo_app/shared/components/components.dart';

class HomeLayout extends StatefulWidget {
  @override
  _HomeLayoutState createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  List<Widget> screens = [TasksScreen(), DoneScreen(), ArchivedScreen()];
  int selectedScreen = 0;
  Database myDatabase;
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  var _formKey = GlobalKey<FormState>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isBottomSheetShown = false;
  IconData flatIcon = Icons.edit;

  @override
  void initState() {
    super.initState();
    createDatabase();
  }

  @override
  Widget build(BuildContext context) {
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
          if (isBottomSheetShown) {
            if (_formKey.currentState.validate()) {
              insertIntoDatabase(
                      title: titleController.text,
                      date: dateController.text,
                      time: timeController.text)
                  .then((value) {
                Navigator.pop(context);
                isBottomSheetShown = false;
                setState(() {
                  flatIcon = Icons.edit;
                });
              });
            }
          } else {
            _scaffoldKey.currentState.showBottomSheet((context) {

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
                          final TimeOfDay pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            builder: (BuildContext context, Widget child) {
                              return MediaQuery(
                                data: MediaQuery.of(context)
                                    .copyWith(alwaysUse24HourFormat: true),
                                child: child,
                              );
                            },
                          );
                          setState(() {
                            timeController.text = pickedTime.format(context);
                          });
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
                            setState(() {
                              dateController.text =
                                  DateFormat("dd-MM-yyyy").format(value);
                            });
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

            }).closed.then((value) {
              isBottomSheetShown = false;
                setState(() {
                  flatIcon = Icons.edit;
                });
            });
            setState(() {
              flatIcon = Icons.add;
              isBottomSheetShown = true;
            });
          }

          // insertIntoDatabase();
        },
        child: Icon(flatIcon),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue[500],
        currentIndex: selectedScreen,
        onTap: (item) {
          setState(() {
            selectedScreen = item;
          });
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
      body: screens[selectedScreen],
    );
  }

  void createDatabase() async {
    try {
      myDatabase = await openDatabase("todo_app.db", version: 1,
          onCreate: (myDatabase, version) {
        print("Database created");

        myDatabase
            .execute(
                "create table Tasks(Id int primary key,Title text,Date text,Time text,Status text)")
            .then((value) {
          print("table created");
        }).catchError((onError) {
          print("error to create table ${onError.toString()}");
        });
      }, onOpen: (myDatabase) {
        print("open database");
      });
    } catch (e) {
      print("error when create database ${e.toString()}");
    }
  }

  Future insertIntoDatabase(
      {@required String title, @required String date, @required String time}) async {
    return await myDatabase.transaction((txn) async {
      int id1 = await txn.rawInsert(
          "insert into Tasks(title,date,time,status) values('$title','$date','$time','current')");
      print("$id1 was inserted successfully");
    });
  }
}
