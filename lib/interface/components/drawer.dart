import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:squirtle/models/userModel.dart';
import 'package:squirtle/navigator/route_names.dart';
import 'package:squirtle/providers/courseProvider.dart';
import 'package:squirtle/providers/userProvider.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context, listen: false).user;
    return Drawer(
      child: Container(
        color: Theme.of(context).primaryColorDark,
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user.firstname),
              accountEmail: null,
              currentAccountPicture: CircleAvatar(
                backgroundColor:
                    Theme.of(context).platform == TargetPlatform.iOS
                        ? Colors.blue
                        : Colors.white,
                child: Text(
                  '${user.firstname[0]}',
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            ButtonDrawer(
              title: 'Calendario',
              icon: Icons.calendar_today,
            ),
            ButtonDrawer(title: 'Notas', icon: Icons.note),
            ButtonDrawer(title: 'Configuracion', icon: Icons.settings),
            ButtonDrawer(title: 'Acerca de nosotros', icon: Icons.info),
            Expanded(
              child: SizedBox(
                height: 25,
              ),
            ),
            ButtonLogout(),
          ],
        ),
      ),
    );
  }
}

final TextStyle textStyleDrawer = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.w600,
  fontSize: 16,
);

class ButtonDrawer extends StatelessWidget {
  const ButtonDrawer({
    Key key,
    @required this.title,
    @required this.icon,
  }) : super(key: key);

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.white,
        ),
        title: Text(
          title,
          style: textStyleDrawer,
        ),
        onTap: () {
          print('Press on $title');
        },
      ),
    );
  }
}

class ButtonLogout extends StatelessWidget {
  const ButtonLogout({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: ListTile(
        leading: Icon(
          Icons.exit_to_app,
          color: Colors.white,
        ),
        title: Text(
          'Logout',
          style: textStyleDrawer,
        ),
        onTap: () {
          Provider.of<UserProvider>(context, listen: false).user = User();
          Provider.of<CourseProvider>(context, listen: false).listCourses = [];
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.LoginRoute,
            (Route<dynamic> route) => false,
          );
        },
      ),
    );
  }
}
