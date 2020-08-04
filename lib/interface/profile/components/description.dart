import 'package:flutter/material.dart';
import 'package:squirtle/models/userModel.dart';

class Description extends StatelessWidget {
  const Description({
    Key key,
    @required this.userTemp,
  }) : super(key: key);

  final User userTemp;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: Text(
            userTemp.firstname,
            style: Theme.of(context).textTheme.headline4.apply(
                  fontSizeFactor: 1,
                  fontWeightDelta: 3,
                  color: Colors.black,
                ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          child: Text(
            userTemp.about ?? "Nothing about u :c",
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }
}