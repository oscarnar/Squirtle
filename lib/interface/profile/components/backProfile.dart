import 'package:flutter/material.dart';
import 'package:squirtle/models/userModel.dart';

class BackProfile extends StatelessWidget {
  const BackProfile({
    Key key,
    @required this.hScreen,
    @required this.wScreen,
    @required this.userTemp,
  }) : super(key: key);

  final double hScreen;
  final double wScreen;
  final User userTemp;

  @override
  Widget build(BuildContext context) {
    double mSize;
    if (wScreen > hScreen)
      mSize = hScreen * 0.55;
    else
      mSize = hScreen * 0.33;
    return Column(
      children: <Widget>[
        Container(
          width: wScreen,
          height: mSize,
          child: userTemp.urlPortada != null
              ? ImageNetwork(userTemp: userTemp)
              : Image.asset(
                  'assets/images/port-default.jpg',
                  fit: BoxFit.cover,
                ),
        ),
        SizedBox(
          height: hScreen * 0.5,
        ),
      ],
    );
  }
}

class ImageNetwork extends StatelessWidget {
  const ImageNetwork({
    Key key,
    @required this.userTemp,
  }) : super(key: key);

  final User userTemp;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      userTemp.urlPortada,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        return progress == null
            ? child
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}
