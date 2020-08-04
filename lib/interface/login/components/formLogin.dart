import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:squirtle/models/userModel.dart';
import 'package:squirtle/navigator/route_names.dart';
import 'package:squirtle/providers/userProvider.dart';
import 'package:squirtle/services/loginService.dart';
import 'package:squirtle/services/server.dart';

class FormWidget extends StatefulWidget {
  @override
  _FormWidgetState createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    Provider.of<UserProvider>(context,listen: false).userLogin = User();
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 10),
            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return "Ingrese un usuario";
                }
              },
              keyboardType: TextInputType.emailAddress,
              decoration: decorationField(
                hintText: 'Username',
                icon: Icon(Icons.account_circle),
              ),
              onSaved: (value) {
                Provider.of<UserProvider>(context,listen: false).userLogin.username = value;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return "Ingrese un password";
                }
              },
              obscureText: true,
              decoration: decorationField(
                icon: Icon(Icons.https),
                hintText: 'Password',
              ),
              onSaved: (value) {
                Provider.of<UserProvider>(context,listen: false).userLogin.password = value;
              },
            ),
            SizedBox(
              height: size.width * 0.1,
            ),
            ButtonLogin(formKey: _formKey),
          ],
        ),
      ),
    );
  }

  final OutlineInputBorder errorBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red[400], width: 2.5),
    borderRadius: BorderRadius.circular(25),
  );
  final OutlineInputBorder focusedBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blue[400], width: 2.5),
    borderRadius: BorderRadius.circular(25),
  );
  final OutlineInputBorder enableBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
    borderRadius: BorderRadius.circular(25),
  );
  InputDecoration decorationField(
      {@required String hintText, @required Icon icon}) {
    return InputDecoration(
      hintText: hintText,
      enabledBorder: enableBorder,
      focusedBorder: focusedBorder,
      errorBorder: errorBorder,
      focusedErrorBorder: focusedBorder,
      disabledBorder: enableBorder,
      fillColor: Colors.white54,
      filled: true,
      prefixIcon: icon,
    );
  }
}

class ButtonLogin extends StatelessWidget {
  ButtonLogin({
    Key key,
    @required GlobalKey<FormState> formKey,
  })  : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormState> _formKey;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 40,
      ),
      onPressed: () {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          User userTemp = Provider.of<UserProvider>(context,listen: false).userLogin;
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('Procesando...'),
            ),
          );
          print(userTemp.username);
          print(userTemp.password);
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
                  //Provider.of<UserProvider>(context, listen: false).editProfile(userTempInfo);
                  Provider.of<UserProvider>(context, listen: false).user = userTempInfo;
                      //User.fromJSON(response);

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
      },
      color: Colors.blue[700], //Color(0xFF005099),
      shape: StadiumBorder(),
      child: Text(
        "LOGIN",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.white,
          fontSize: 17,
        ),
      ),
    );
  }
}
