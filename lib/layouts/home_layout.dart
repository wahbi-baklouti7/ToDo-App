import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archieved_screen.dart';
import 'package:todo_app/modules/done_screen.dart';
import 'package:todo_app/modules/tasks_screen.dart';

class HomeLayout extends StatefulWidget {
  @override
  _HomeLayoutState createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  List<Widget> screens = [TasksScreen(), DoneScreen(), ArchivedScreen()];
  int selectedScreen = 0;
  Database myDatabase;

  @override
  void initState() {
    super.initState();
    createDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo App"),
        centerTitle: true,
        backgroundColor: Colors.amber[500],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber[500],
        onPressed: () {
          insertIntoDatabase();
        },
        child: Icon(Icons.add),
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
      print("error whene create database ${e.toString()}");
    }
  }

  void insertIntoDatabase() async {
    await myDatabase.transaction((txn) async {
      int id1 = await txn.rawInsert(
          "insert into Tasks(title,date,time,status) values('flutter storage','05/05/2020','08:00','current')");
      print("$id1 was inserted successfully");
    });
  }
}
