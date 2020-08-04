import 'package:flutter/material.dart';

class User {
  String firstname;
  String lastname;
  String urlPhoto;
  String urlPortada;
  String about;
  String token;
  String username;
  String password;
  String userID;

  User({
    this.firstname,
    this.lastname,
    this.urlPhoto,
    this.urlPortada,
    this.about,
    this.token,
    this.username,
    this.password,
    this.userID,
  });

  factory User.fromJSON(Map<String,dynamic> response){
    return User(
      firstname: response['firstname'],
      lastname: response['lastname'],
      userID: response['userid'].toString(),
      urlPhoto: response['userpictureurl'],
    );
  }
}
