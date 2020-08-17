import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:squirtle/interface/home/compoments/courseCard.dart';
import 'package:squirtle/models/courseModel.dart';
import 'package:squirtle/models/userModel.dart';
import 'package:squirtle/providers/courseProvider.dart';
import 'package:squirtle/providers/userProvider.dart';
import 'package:squirtle/services/loginService.dart';
import 'package:squirtle/services/server.dart';

// TODO: Hacer la vista de cada curso
// https://aulavirtual.unsa.edu.pe/aulavirtual/webservice/rest/server.php?wsfunction=core_course_get_contents&moodlewsrestformat=json&wstoken=fefe622cc3ffe3c11bb63824947d66dc&courseid=10175
// De ese link obtener los datos

// TODO: Hacer la vista de tareas
// https://aulavirtual.unsa.edu.pe/aulavirtual/webservice/rest/server.php?wsfunction=mod_assign_get_assignments&moodlewsrestformat=json&wstoken=fefe622cc3ffe3c11bb63824947d66dc
// De ese link sacar la info

// TODO: Descargar pdf
// https://aulavirtual.unsa.edu.pe/aulavirtual/webservice/pluginfile.php/299032/mod_resource/content/1/6_image_arithmetic.pdf?forcedownload=1&token=fefe622cc3ffe3c11bb63824947d66dc
// El link que proporciona en la informacion del curso para descargar
// al final del link del archivo poner &token=fefe622cc3ffe3c11bb63824947d66dc

// TODO: Segmentacion de texto
// Implemtar la segmentacion de texto con openCV

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User userTemp =
        Provider.of<UserProvider>(context, listen: false).user;
    return Provider.of<CourseProvider>(context).listCourses.isEmpty
        ? ListFutureBuilder(userTemp: userTemp)
        : ListBuilder(lista: Provider.of<CourseProvider>(context).listCourses);
  }
}

class ListFutureBuilder extends StatelessWidget {
  const ListFutureBuilder({
    Key key,
    @required this.userTemp,
  }) : super(key: key);

  final User userTemp;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          userCoursesService(token: userTemp.token, userid: userTemp.userID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('error courses: ${snapshot.data.toString()}');
          return Center(child: Text('Ocurrio un error'));
        } else if (snapshot.hasData) {
          print('data courses: ${snapshot.data}');
          Provider.of<CourseProvider>(context).coursesFromJSON(snapshot.data);
          return ListBuilder(
              lista: Provider.of<CourseProvider>(context).listCourses);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class ListBuilder extends StatelessWidget {
  const ListBuilder({
    Key key,
    @required this.lista,
  }) : super(key: key);

  final List<Course> lista;

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
              if (index + 1 == lista.length)
                return size.width * 0.04;
              else
                return 0.0;
            }()),
          ),
          child: CourseCard(
            currentCourse: lista[index],
          ),
        );
      },
      itemCount: lista.length,
    );
  }
}
