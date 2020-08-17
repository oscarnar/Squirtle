import 'package:flutter/material.dart';
import 'package:squirtle/interface/home/home.dart';
import 'package:squirtle/interface/login/login.dart';
import 'package:squirtle/interface/mobileScreen.dart';
import 'package:squirtle/interface/profile/profile.dart';
import 'package:squirtle/interface/tasks/taskScreen.dart';
import 'package:squirtle/navigator/route_names.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.MobileRoute:
      return MaterialPageRoute(builder: (context) => LayoutMobileScreen());
    case Routes.LoginRoute:
      return MaterialPageRoute(builder: (context) => LoginScreen());
    case Routes.HomeRoute:
      return MaterialPageRoute(builder: (context) => HomeScreen());
    case Routes.TaskRoute:
      return MaterialPageRoute(builder: (context) => TaskScreen());
    case Routes.ProfileRoute:
      return MaterialPageRoute(builder: (context) => ProfileScreen());
    default:
      return MaterialPageRoute(builder: (context) => LoginScreen());
  }
}