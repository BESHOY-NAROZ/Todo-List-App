import 'package:a_m_bloc_todo/archived_tasks.dart';
import 'package:a_m_bloc_todo/bloc_classes/app_states.dart';
import 'package:a_m_bloc_todo/done_tasks.dart';
import 'package:a_m_bloc_todo/new_tasks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  int changeCurrentPage = 0;
  List<Widget> listOfScreens = [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];
  methodWithoutSetState(int index) {
    changeCurrentPage = index;
    emit(AppChangeBottomNavBarState());
  }

  List<Map> allTasks = [];
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  Database database;
  createDatabase() async {
    database = await openDatabase(
      'NoteTodo.db',
      version: 1,
      onCreate: (db, version) async {
        print('database on create');
        await db.execute(
            'CREATE TABLE Todo(id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)');
      },
      onOpen: (db) {
        print('database on open');
      },
    );
    await getDatabase();
  }

  insertDatabase(String title, String time, String date) async {
    await createDatabase();
    await database.transaction((txn) => txn.rawInsert(
        'INSERT INTO Todo(title, date, time, status) VALUES("$title", "$date", "$time", "New")'));
    print('database inserted ${database.toString()}');
    emit(AppInsertDatabaseState());
    await getDatabase();
  }

  Color s = Colors.green;

  getDatabase() async {
    allTasks = await database.rawQuery('SELECT * FROM Todo');
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];



    allTasks.forEach((element) {
      if ((element)['status'] == 'New') {
        newTasks.add(element);
      } else if ((element)['status'] == 'Done') {
        doneTasks.add(element);
      } else if ((element)['status'] == 'Archived') {
        archivedTasks.add(element);
      }
    });

    print('get database is called');
    emit(AppGetDatabaseState());
  }

  updateDatabase(String status, int id) async {
    await database
        .rawUpdate('UPDATE Todo SET status = ? WHERE id = ?', ['$status', id]);
    emit(AppUpdateDatabaseState());
    print('update is called');
    await getDatabase();
  }

  deleteDatabase(int id) async {
    await database.rawDelete('DELETE FROM Todo WHERE id = ?', [id]);
    emit(AppDeleteDatabaseState());
    getDatabase();
  }

  bool isOpened = false;
  changeCurrentCondition(bool condition) {
    isOpened = condition;
    emit(AppChangeIconState());
  }
}
