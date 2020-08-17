import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:squirtle/services/server.dart';

Future<dynamic> loginService(
    {@required String username, @required String password}) async {
      var url = Server.LoginURL;
      var valueJSON;
      var response = await http.post(url, body: {
        'username': username,
        'password': password,
        'service': Server.LoginService,
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    valueJSON = json.decode(response.body);
    
    return valueJSON;
}
