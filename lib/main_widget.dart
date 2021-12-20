import 'package:a_m_bloc_todo/bloc_classes/app_cubit.dart';
import 'package:a_m_bloc_todo/bloc_classes/app_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainWidget extends StatelessWidget {
  List listType = [];
  @override
  Widget build(BuildContext context) {
    AppCubit appCubit = AppCubit.get(context);
    print('main widget is called');
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, states) {},
      builder: (context, states) {
        return ListView.builder(
            itemBuilder: (context, index) {
              //Map map = tasks[index];
              return Dismissible(
                key: Key(listType[index]['id'].toString()),
                onDismissed: (direction) {
                  appCubit.deleteDatabase(listType[index]['id']);
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CircleAvatar(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            listType[index]['time'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                        radius: 24,
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 60,
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            listType[index]['title'],
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            listType[index]['date'],
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          )
                        ],
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 10,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.menu,
                          color: Colors.green,
                        ),
                        onPressed: () {
                          appCubit.updateDatabase('New', listType[index]['id']);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.check_circle_outline,
                          color: Colors.green,
                        ),
                        onPressed: () {
                          appCubit.updateDatabase(
                              'Done', listType[index]['id']);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.archive),
                        onPressed: () {
                          appCubit.updateDatabase(
                              'Archived', listType[index]['id']);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
            itemCount: listType.length);
      },
    );
  }

  MainWidget(this.listType);
}
