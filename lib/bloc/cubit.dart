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

  Database myDatabase;
  bool isBottomSheetShown = false;
  IconData flatIcon = Icons.edit;
  List<Map> tasks = [];

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
      getDataFromDatabase(myDatabase).then((value) {
        tasks = value;

        emit(AppGetFromDatabase());
        print(tasks);
      });
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

  void insertIntoDatabase(
      {@required String title,
      @required String date,
      @required String time}) async {
    myDatabase.transaction((txn) async {
      await txn.rawInsert(
          "insert into Tasks(title,date,time,status) values('$title','$date','$time','current')");
    }).then((value) {
      print("inserted successfully");
      emit(AppInsertIntoDatabase());

      getDataFromDatabase(myDatabase).then((value) {
        tasks = value;
        print(tasks);
        emit(AppGetFromDatabase());
      });
    });
  }

  Future<List<Map>> getDataFromDatabase(myDatabase) async {
    return await myDatabase.rawQuery("select * from Tasks");
  }

  void changeButtonState({@required bool isShow, @required IconData icon}) {
    isBottomSheetShown = isShow;
    flatIcon = icon;
    emit(ChangeButtonState());
  }

  void deleteTask({@required int taskIndex}) {
    myDatabase.rawDelete('DELETE FROM Tasks WHERE id=$taskIndex').then((value) {
      print("index:taskIndex");
      emit(DeleteButtonState());

      getDataFromDatabase(myDatabase).then((value) {
        tasks = value;
        print(tasks);
        emit(AppGetFromDatabase());
      });
    });
  }
}
