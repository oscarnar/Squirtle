import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squirtle/interface/login/components/formLogin.dart';
import 'package:squirtle/navigator/route_names.dart';

// final token = 'asdasdfdgsdfgasdaawwddwsasxdsd'; Sharon
final token = 'fefe622cc3ffe3c11bb63824947d66dc'; //Oscar
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blueAccent, Colors.redAccent],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.width * 0.12),
                  child: Image.asset(
                    'assets/images/logo-name.png',
                    width: size.width * 0.5,
                  ),
                ),
                Text(
                  "LOGIN",
                  style: TextStyle(fontSize: 30),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.width * 0.03),
                  child: SizedBox(
                    width: size.width * 0.7,
                    child: FormWidget(),
                  ),
                ),
                Text(
                  "Forgot password?",
                  style: TextStyle(
                    letterSpacing: 2.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.width * 0.1),
                  child: OutlineButton(
                    shape: StadiumBorder(),
                    child: Text(
                      "Login with Google",
                      style: TextStyle(
                          letterSpacing: 2.5,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, Routes.MobileRoute);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

