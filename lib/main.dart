import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:squirtle/navigator/route_names.dart';
import 'package:squirtle/navigator/routes.dart';
import 'package:squirtle/providers/courseProvider.dart';
import 'package:squirtle/providers/userProvider.dart';
import 'package:squirtle/theme.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<UserProvider>(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider<CourseProvider>(
          create: (_) => CourseProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: myTheme,
        //home: LoginScreen(),
        onGenerateRoute: generateRoute,
        initialRoute: Routes.LoginRoute,
      ),
    );
  }
}
