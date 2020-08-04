import 'package:flutter/material.dart';

class Course {
  String name;
  String teacher;
  String photo;
  String courseID;
  int userCount;
  double progress;

  Course({
    @required this.name,
    @required this.courseID,
    this.teacher,
    this.photo,
    this.userCount,
    this.progress,
  });

  factory Course.fromJSON(Map<String,dynamic> response){
    return Course(
      name: response['fullname'],
      courseID: response['userid'].toString(),
      photo: response['userpictureurl'],
    );
  }
}
