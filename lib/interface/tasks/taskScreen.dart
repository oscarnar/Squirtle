import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:squirtle/interface/tasks/components/cardTask.dart';
import 'package:squirtle/models/courseModel.dart';
import 'package:squirtle/models/taskModel.dart';
import 'package:squirtle/providers/courseProvider.dart';
import 'package:squirtle/providers/userProvider.dart';
import 'package:squirtle/services/server.dart';

class TaskScreen extends StatelessWidget {
  List<Task> listTask = [];
  List<String> listNames = [];

  @override
  Widget build(BuildContext context) {
    final List<Course> listCourses =
        Provider.of<CourseProvider>(context).listCourses;
    if(listTask.isEmpty){
      pollingTasks(listCourses);
    }

    return listTask.isEmpty
        ? listFutureTaskBuilder(context)
        : ListTaskBuilder(
            listTask: listTask,
            listNames: listNames,
          );
  }

  void pollingTasks(List<Course> listCourses) {
    for (var x in listCourses) {
      //listTask += (x.tasksList);
      for (int i = 0; i < x.tasksList.length; i++) {
        listNames.add(x.name);
        listTask.add(x.tasksList[i]);
      }
    }
  }

  Widget listFutureTaskBuilder(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    return FutureBuilder(
      future: taskService(token: user.token),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('error courses info: ${snapshot.data.toString()}');
          return Center(child: Text('Ocurrio un error'));
        } else if (snapshot.hasData) {
          Provider.of<CourseProvider>(context, listen: false)
              .taskFromJSON(snapshot.data);
          final List<Course> listCourses =
              Provider.of<CourseProvider>(context).listCourses;
          pollingTasks(listCourses);
          return ListTaskBuilder(listTask: listTask, listNames: listNames);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class ListTaskBuilder extends StatelessWidget {
  ListTaskBuilder({@required this.listTask, @required this.listNames});

  final List<Task> listTask;
  final List<String> listNames;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return ListView.builder(
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(
            top: size.width * 0.02,
            left: size.width * 0.04,
            right: size.width * 0.04,
            bottom: (() {
              if (index + 1 == listTask.length)
                return size.width * 0.02;
              else
                return 0.0;
            }()),
          ),
          child: CardTask(
            task: listTask[index],
            course: listNames[index],
          ),
        );
      },
      itemCount: listTask.length,
    );
  }
}