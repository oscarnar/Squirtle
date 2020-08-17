import 'package:flutter/material.dart';
import 'package:squirtle/models/taskModel.dart';

class Course {
  String name;
  String teacher;
  String photo;
  String courseID;
  int userCount;
  double progress;

  List<Tema> temasList = [];
  List<Task> tasksList = [];

  Course({
    @required this.name,
    @required this.courseID,
    this.teacher,
    this.photo,
    this.userCount,
    this.progress,
  });

  factory Course.fromJSON(Map<String, dynamic> response) {
    return Course(
      name: onlyCourseName(response['fullname']),
      courseID: response['id'].toString(),
    );
  }
}

String onlyCourseName(String name){
    int index = name.indexOf('-');
    return name.substring(index + 1);
  }
class Tema {
  String id;
  String name;
  List<Module> modules = [];

  Tema({this.id, this.name, this.modules});

  factory Tema.fromJSON(Map<String, dynamic> response) {
    return Tema(
      name: response['name'],
      id: response['id'].toString(),
      modules: buildModules(response['modules']),
    );
  }
}

class Module {
  String idModule;
  String name;
  String modname;
  List<Content> contents = [];

  Module({this.idModule, this.name, this.modname, this.contents});

  factory Module.fromJSON(Map<String, dynamic> response) {
    return Module(
      name: response['name'],
      idModule: response['id'].toString(),
      modname: response['modname'],
      contents: response.containsKey('contents')
          ? buildContents(response['contents'])
          : [],
    );
  }
}

List<Content> buildContents(dynamic response) {
  List<Content> listContents = [];
  for (var x in response) {
    listContents.add(Content.fromJSON(x));
  }
  return listContents;
}

List<Module> buildModules(dynamic response) {
  List<Module> listModules = [];
  for (var x in response) {
    listModules.add(Module.fromJSON(x));
  }
  return listModules;
}

class Content {
  String type;
  String filename;
  String fileUrl;
  int filesize;

  Content({this.type, this.fileUrl, this.filename, this.filesize});

  factory Content.fromJSON(Map<String, dynamic> response) {
    return Content(
      type: response['type'],
      fileUrl: response['fileurl'],
      filename: response['filename'],
      filesize: response['filesize'],
    );
  }
}
