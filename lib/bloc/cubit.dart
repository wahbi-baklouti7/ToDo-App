import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/state.dart';
import 'package:todo_app/modules/archived_screen.dart';
import 'package:todo_app/modules/done_screen.dart';
import 'package:todo_app/modules/tasks_screen.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  List<Widget> screens = [TasksScreen(), DoneScreen(), ArchivedScreen()];
  int selectedScreen = 0;

  void getCurrentScreenIndex(int index) {
    selectedScreen = index;
    emit(ChangeBottomNavScreens());
  }
}
