import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:squirtle/interface/profile/components/backProfile.dart';
import 'package:squirtle/interface/profile/components/description.dart';
import 'package:squirtle/interface/profile/components/photoProfile.dart';
import 'package:squirtle/providers/userProvider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final userTemp = Provider.of<UserProvider>(context).user;
    double minSize;
    double maxSize;
    if (size.height > size.width) {
      minSize = size.width;
      maxSize = size.height;
    } else {
      minSize = size.height;
      maxSize = size.width;
    }
    return SingleChildScrollView(
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          BackProfile(
            hScreen: size.height,
            wScreen: size.width,
            userTemp: userTemp,
          ),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: size.height * 0.17,
                ),
                PhotoProfile(
                  minSize: minSize,
                  userTemp: userTemp,
                  wScreen: size.width,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 15,
                  ),
                  width: size.width * 0.92,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Description(userTemp: userTemp),
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
