# SQUIRTLE

Squirtle es una app que muestra de una forma mas amigable e intuitiva la plataforma de Moodle.

## Uso de la API

Se esta haciendo uso de la API de Moodle, especificamente DUTIC, esta app fue hecha solo con fines academicos.

## Construccion

Se hizo uso del framework [Flutter](https://flutter.dev/).

## Estilos de programación

### Restful

```dart
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
```

### Cookbook
```dart
import 'dart:typed_data';

import 'package:opencv/core/core.dart';
import 'package:opencv/core/imgproc.dart';

Future<Uint8List> cannyContours(
    {Uint8List image, double minT, double maxT}) async {
  dynamic ima = await ImgProc.cvtColor(image, ImgProc.colorBGR2GRAY);
  
  ima = await ImgProc.gaussianBlur(ima, [5.0,5.0],0);
  //ima = await ImgProc.bilateralFilter(ima, 9, 75, 75, Core.borderConstant);
  //ima = await ImgProc.adaptiveThreshold(ima, 255, ImgProc.adaptiveThreshGaussianC, ImgProc.threshBinary, 7, 15);
  //ima = await ImgProc.medianBlur(ima, 5);
  ima = await ImgProc.canny(ima, minT, maxT);
  //ima = await ImgProc.threshold(ima, 120, 255, ImgProc.threshBinary);
  //ima = await ImgProc.dilate(ima, [1, 1]);
  //ima = await ImgProc.erode(ima, [1, 1]);
  return ima;
}

Future<dynamic> findContours({Uint8List image, double minT, double maxT}) async {
  
  Uint8List ima = await cannyContours(image: image,minT: minT, maxT: maxT);
  dynamic edges = await ImgProc.onlyFindContours(ima);
  return edges;
}
```

### Trinity

```dart
onPressed: () {
    if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        User userTemp = Provider.of<UserProvider>(context,listen: false).userLogin;
        Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('Procesando...'),
            ),
        );

        loginService(username: userTemp.username, password: userTemp.password)
            .then((value) {
        if (value.containsKey('error')) {
            Scaffold.of(context).showSnackBar(
                SnackBar(
                    content: Text('User or Password invalid'),
                ),
            );
        } else {
            userInfoService(token: value['token']).then((response) {
                if (response.containsKey('exception') || response == null) {
                    Scaffold.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Error accediendo a DUTIC'),
                        ),
                    );
                } else {
                    User userTempInfo = User.fromJSON(response);
                    userTempInfo.username = userTemp.username;
                    userTempInfo.password = userTemp.password;
                    userTempInfo.token = value['token'];
                    Provider.of<UserProvider>(context, listen: false).user = userTempInfo;

                    Navigator.pushNamedAndRemoveUntil(
                        context,
                        Routes.MobileRoute,
                        (Route<dynamic> route) => false,
                    );
                }
            });
        }
    });
}
```
