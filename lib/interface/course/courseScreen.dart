import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:squirtle/interface/course/components/cardTema.dart';
import 'package:squirtle/models/courseModel.dart';
import 'package:squirtle/providers/courseProvider.dart';
import 'package:squirtle/providers/userProvider.dart';
import 'package:squirtle/services/server.dart';

class CourseScreen extends StatelessWidget {
  CourseScreen({this.currentCourse});
  final Course currentCourse;
  @override
  Widget build(BuildContext context) {
    return currentCourse.temasList.isEmpty
        ? ListFutureBuilder(idCourse: currentCourse.courseID)
        : ListModulesBuilder(temas: currentCourse.temasList);
  }
}

class ListFutureBuilder extends StatelessWidget {
  const ListFutureBuilder({
    Key key,
    @required this.idCourse,
  }) : super(key: key);

  final String idCourse;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final index =
        Provider.of<CourseProvider>(context, listen: false).getIndex(idCourse);

    return FutureBuilder(
      future: courseInfoService(token: user.token, courseid: idCourse),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('error courses info: ${snapshot.data.toString()}');
          return Center(child: Text('Ocurrio un error'));
        } else if (snapshot.hasData) {
          print('data courses info: ${snapshot.data}');
          Provider.of<CourseProvider>(context, listen: false)
              .addTemas(courseid: idCourse, data: snapshot.data);
          return ListModulesBuilder(
              temas: Provider.of<CourseProvider>(context)
                  .listCourses[index]
                  .temasList);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class ListModulesBuilder extends StatelessWidget {
  ListModulesBuilder({this.temas});

  final List<Tema> temas;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return ListView.builder(
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(
            top: size.width * 0.04,
            left: size.width * 0.04,
            right: size.width * 0.04,
            bottom: (() {
              if (index + 1 == temas.length)
                return size.width * 0.04;
              else
                return 0.0;
            }()),
          ),
          child: CardTema(
            tema: temas[index],
          ),
        );
      },
      itemCount: temas.length,
    );
  }
}


