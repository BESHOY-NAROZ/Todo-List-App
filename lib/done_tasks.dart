import 'package:a_m_bloc_todo/bloc_classes/app_cubit.dart';
import 'package:a_m_bloc_todo/bloc_classes/app_states.dart';
import 'package:a_m_bloc_todo/main_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoneTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('done tasks is opened');
    AppCubit appCubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, state) {
        return MainWidget(appCubit.doneTasks);
      },
    );
  }
}
