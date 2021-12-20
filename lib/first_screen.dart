import 'package:a_m_bloc_todo/bloc_classes/app_cubit.dart';
import 'package:a_m_bloc_todo/bloc_classes/app_states.dart';
import 'package:a_m_bloc_todo/constant.dart';
import 'package:a_m_bloc_todo/text_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class FirstScreen extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var validateKey = GlobalKey<FormState>();
  Future bottomSheet;
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print('first screen is called');
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
          listener: (BuildContext context, AppStates state) {
        if (state is AppInsertDatabaseState) {}
      }, builder: (context, appStates) {
        AppCubit appCubit = AppCubit.get(context);
        return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text('Note App'),
            ),
            floatingActionButton: FloatingActionButton(
              child: appCubit.isOpened
                  ? Icon(Icons.add)
                  : Icon(Icons.arrow_upward),
              onPressed: () async {
                if (appCubit.isOpened) {
                  if (validateKey.currentState.validate()) {
                    appCubit.insertDatabase(
                        titleController.text.toString(),
                        timeController.text.toString(),
                        dateController.text.toString());
                    Navigator.pop(context);

                    appCubit.changeCurrentCondition(false);
                  }
                } else {
                  appCubit.changeCurrentCondition(true);

                  bottomSheet = await scaffoldKey.currentState
                      .showBottomSheet(
                        (context) => Container(
                          padding: EdgeInsets.all(20),
                          child: Form(
                            key: validateKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                titleTextForm(titleController: titleController),
                                sizedBox,
                                timeTextForm(timeController: timeController),
                                sizedBox,
                                dateTextForm(dateController: dateController),
                              ],
                            ),
                          ),
                        ),
                      )
                      .closed;
                  //   setState(() {
                  appCubit.changeCurrentCondition(false);
                  // },);
                }
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: appCubit.changeCurrentPage,
              onTap: (index) {
                appCubit.methodWithoutSetState(index);
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.menu), title: Text('New')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline),
                    title: Text('Done')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive), title: Text('Archived')),
              ],
            ),
            body: appCubit.listOfScreens[appCubit.changeCurrentPage]);
      }),
    );
  }
}
//  tasks.length > 0
//  ? Provider.of<TaskList>(context)
//      .listOfScreens[Provider.of<TaskList>(context).changeCurrentPage]
//      : Center(child: CircularProgressIndicator()));

class dateTextForm extends StatelessWidget {
  const dateTextForm({
    Key key,
    @required this.dateController,
  }) : super(key: key);

  final TextEditingController dateController;

  @override
  Widget build(BuildContext context) {
    return DefaultTextForm(
      controller: dateController,
      hintText: 'Task Date',
      onTap: () async {
        DateTime date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime.parse('2021-12-31'));
        dateController.text = DateFormat.yMMMd().format(date);
      },
      validator: (String value) {
        if (value.isEmpty) {
          return ('date must not be empty');
        }
        return null;
      },
      icon: Icon(Icons.date_range),
    );
  }
}

class titleTextForm extends StatelessWidget {
  const titleTextForm({
    Key key,
    @required this.titleController,
  }) : super(key: key);

  final TextEditingController titleController;

  @override
  Widget build(BuildContext context) {
    return DefaultTextForm(
      controller: titleController,
      hintText: 'Task Title',
      onTap: () {},
      validator: (String value) {
        if (value.isEmpty) {
          return ('title must not be empty');
        }
        return null;
      },
      icon: Icon(Icons.title),
    );
  }
}

class timeTextForm extends StatelessWidget {
  const timeTextForm({
    Key key,
    @required this.timeController,
  }) : super(key: key);

  final TextEditingController timeController;

  @override
  Widget build(BuildContext context) {
    return DefaultTextForm(
      controller: timeController,
      hintText: 'Task Time',
      onTap: () async {
        TimeOfDay time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        timeController.text = time.format(context).toString();
      },
      validator: (String value) {
        if (value.isEmpty) {
          return ('time must not be empty');
        }
        return null;
      },
      icon: Icon(Icons.watch_later),
    );
  }
}
