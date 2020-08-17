import 'package:flutter/material.dart';
import 'package:squirtle/models/courseModel.dart';

class CourseProvider with ChangeNotifier {
  List<Course> listCourses = [];
  /*= [
    Course(
      courseID: '001',
      name: "Computacion Grafica",
      teacher: 'Vicente Machaca Arceda',
      photo:
          'https://2.bp.blogspot.com/-BrRiO6nA_8s/WgiC1fU_ZOI/AAAAAAAACPM/TcKaWnR9lgwEDCcu7v3nb69pLlLVdYdgwCLcBGAs/s1600/futurocomg.jpg',
    ),
    Course(
        courseID: '002',
        name: "Inteligencia Arificial",
        teacher: "Jesus",
        photo:
            'https://observatorio-ia.com/wp-content/uploads/2019/04/IA-tendencias.jpg'),
    Course(
      courseID: '003',
      name: "Redes y Comunicacion",
      teacher: "Lucy Angela",
      photo:
          'https://www.redeszone.net/app/uploads-redeszone.net/2019/10/portada_Herramientas_-red.png',
    ),
    Course(
      courseID: '004',
      name: "Investigacion en CS",
      teacher: "Wilber Ramos Lovon",
      photo:
          'https://image.shutterstock.com/image-photo/man-working-laptop-connecting-networking-260nw-403797997.jpg',
    ),
    Course(
      courseID: '005',
      name: "Ingenieria de Software",
      teacher: "Edgar Sarmiento",
      photo:
          'https://www.queestudiar.org/wp-content/uploads/2017/10/software-750x350.jpg',
    ),
    Course(
      courseID: '006',
      name: "Liderazgo y oratoria",
      teacher: "Roxana Flores",
      photo:
          'https://image.shutterstock.com/image-photo/man-working-laptop-connecting-networking-260nw-403797997.jpg',
    ),
    Course(
      courseID: '007',
      name: "Fotografia",
      teacher: "Clavero",
      photo:
          'https://www.queestudiar.org/wp-content/uploads/2017/10/software-750x350.jpg',
    ),
  ];*/

  void addCourse(Course newCourse) {
    listCourses.add(newCourse);
    notifyListeners();
  }

  void coursesFromJSON(dynamic data) {
    List listData = data as List;
    for (int i = 0; i < listData.length; i++) {
      Course courseTemp = Course.fromJSON(listData[i]);
      listCourses.add(courseTemp);
    }
    notifyListeners();
  }

  void addTemas({dynamic data, String courseid}) {
    List listData = data as List;
    int index = getIndex(courseid);
    if (index == -1) return;
    for (int i = 0; i < listData.length; i++) {
      Tema temaTemp = Tema.fromJSON(listData[i]);
      listCourses[index].temasList.add(temaTemp);
    }

    //listCourses[index].temasList.add(Tema.fromJSON(data));

    //notifyListeners();
  }

  int getIndex(String idCourse) {
    for (int x = 0; x < listCourses.length; x++) {
      if (listCourses[x].courseID == idCourse) {
        return x;
      }
    }
    return -1;
  }
}
