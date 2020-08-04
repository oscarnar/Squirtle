/*
Esta clase ayuda en la navegacion en DUTIC
tanto en el login como los servicios de este.
Usamos request POST para todo.
Para todos los servicios, excepto Login, 
debemos usar el token de usuario que obtnemos
en el login.

SERVICIOS:
- Login: Para este caso debemos usar LoginURL
    donde mediante POST enviamos el 'username',
    el 'password' y el 'service' LoginService.
    Como respuesta obtenemos dos tokens y
    usamos el primer token.

- UserInfo: Usamos ServerURL y en el body enviamos
    'wsfuntion' con InfoServer, el formato de
    la respuesta 'moodlewsrestformat' como 'json'
    y el token del usuario 'wstoken'.
*/

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Server {
  static const String LoginURL =
      "https://aulavirtual.unsa.edu.pe/aulavirtual/login/token.php";
  static const String ServerURL =
      "https://aulavirtual.unsa.edu.pe/aulavirtual/webservice/rest/server.php";
  // Services
  static const String LoginService = 'moodle_mobile_app';
  static const String InfoService = 'core_webservice_get_site_info';
  static const String CoursesFunction = 'core_enrol_get_users_courses';
}

Future<dynamic> serviceLogin({@required dynamic body}) async {
  var url = Server.LoginURL;
  var response = await http.post(url, body: body);
  return json.decode(response.body);
}

Future<dynamic> service({@required dynamic body}) async {
  var url = Server.ServerURL;
  var response = await http.post(url, body: body);
  return json.decode(response.body);
}

Future<dynamic> userInfoService({@required String token}) async {
  var body = {
    'wsfunction': Server.InfoService,
    'moodlewsrestformat': 'json',
    'wstoken': token,
  };
  return service(body: body);
}

Future<dynamic> userCoursesService({@required String token,@required String userid}) async {
  //wsfunction=core_enrol_get_users_courses&moodlewsrestformat=json&wstoken=fefe622cc3ffe3c11bb63824947d66dc&userid=13919
  var body = {
    'wsfunction': Server.CoursesFunction,
    'moodlewsrestformat': 'json',
    'wstoken': token,
    'userid': userid,
  };
  return service(body: body);
}