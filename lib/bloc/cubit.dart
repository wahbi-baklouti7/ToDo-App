import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/bloc/state.dart';
import 'package:todo_app/screens/archived_screen.dart';
import 'package:todo_app/screens/done_screen.dart';
import 'package:todo_app/screens/tasks_screen.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int selectedScreen = 0;
  List<Widget> screens = [TasksScreen(), DoneScreen(), ArchivedScreen()];

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  Database myDatabase;
  bool isBottomSheetShown = false;
  IconData flatIcon = Icons.edit;

  bool buttonIsChecked = false;
  bool buttonArchive = false;

  // change the index of bottom navigator sheet
  void getCurrentScreenIndex(int index) {
    selectedScreen = index;
    emit(ChangeBottomNavScreens());
  }

  // Create app database
  void createDatabase() {
    openDatabase("todo_app.db", version: 1, onCreate: (myDatabase, version) {
      print("Database created");
      createTable(myDatabase);
    }, onOpen: (myDatabase) {
      getDataFromDatabase(myDatabase);
      print("open database");
    }).then((value) {
      myDatabase = value;
      emit(AppCreateDatabase());
    });
  }

  // Create table in database
  void createTable(myDatabase) {
    myDatabase
        .execute(
            "create table IF NOT EXISTS Tasks(id INTEGER PRIMARY KEY,Title text,Date text,Time text,Status text)")
        .then((value) {
      print("table created");
    }).catchError((onError) {
      print("error to create table ${onError.toString()}");
    });
  }

  // insert data into database
  void insertIntoDatabase(
      {@required String title,
      @required String date,
      @required String time}) async {
    myDatabase.transaction((txn) async {
      await txn.rawInsert(
          "insert into Tasks(title,date,time,status) values('$title','$date','$time','New')");
    }).then((value) {
      print("inserted successfully");
      emit(AppInsertIntoDatabase());

      getDataFromDatabase(myDatabase);
    });
  }

  // retrieve data form database
  void getDataFromDatabase(myDatabase) {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];
    myDatabase.rawQuery("select * from Tasks").then((value) {
      value.forEach((element) {
        if (element["Status"] == "New") {
          newTasks.add(element);
        } else if (element["Status"] == "Done") {
          doneTasks.add(element);
        } else {
          archiveTasks.add(element);
        }
      });
      print(newTasks);
      emit(AppGetFromDatabase());
    });
  }

  void changeButtonState({@required bool isShow, @required IconData icon}) {
    isBottomSheetShown = isShow;
    flatIcon = icon;
    emit(ChangeButtonState());
  }

  // delete data from database
  void deleteTask({@required int id}) {
    myDatabase
        .rawDelete('DELETE FROM Tasks WHERE id=?',[id]).then((value) {
      
      emit(AppDeleteDatabase());
      getDataFromDatabase(myDatabase);
    });
  }

  // update data
  updateDatabase({@required String newStatus, @required int id}) {
    myDatabase.rawUpdate("UPDATE Tasks set Status=? WHERE id=?",
        ["$newStatus", "$id"]).then((value) {
      emit(AppUpdateDatabase());
      getDataFromDatabase(myDatabase);
    });
  }

  // check button
  void buttonCheckState({bool newState}) {
    buttonIsChecked = newState;
    emit(ChangeButtonState());
  }

  // archive button
  void buttonArchiveState({bool newState}) {
    buttonArchive = newState;
    emit(ChangeButtonState());
  }
}
