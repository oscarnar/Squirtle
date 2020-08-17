import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:squirtle/interface/components/appBar.dart';
import 'package:squirtle/interface/components/drawer.dart';
import 'package:squirtle/models/userModel.dart';
import 'package:squirtle/navigator/route_names.dart';
import 'package:squirtle/navigator/routes.dart';
import 'package:squirtle/providers/courseProvider.dart';
import 'package:squirtle/providers/userProvider.dart';

class LayoutMobileScreen extends StatefulWidget {
  @override
  _LayoutMobileScreenState createState() => _LayoutMobileScreenState();
}

class _LayoutMobileScreenState extends State<LayoutMobileScreen> {
  int _currentIndex = 1;
  List<dynamic> listRoutes = [
    Routes.TaskRoute,
    Routes.HomeRoute,
    Routes.ProfileRoute
  ];
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final User user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: buildAppBar(size),
      drawer: MyDrawer(),
      body: Navigator(
        key: Get.nestedKey(1),
        onGenerateRoute: generateRoute,
        initialRoute: listRoutes[_currentIndex],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BottomNavigationBar(
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
              Get.toNamed(listRoutes[index], id: 1);
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_on),
              title: Text("Tareas"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("Cursos"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              title: Text("Perfil"),
            ),
          ],
        ),
      ),
    );
  }
}



class VistaPrueba extends StatelessWidget {
  final name;
  VistaPrueba(this.name);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        name,
        style: TextStyle(fontSize: 40),
      ),
    );
  }
}
