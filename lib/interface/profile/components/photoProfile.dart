import 'package:flutter/material.dart';
import 'package:squirtle/models/userModel.dart';

class PhotoProfile extends StatelessWidget {
  const PhotoProfile({
    Key key,
    @required this.minSize,
    @required this.userTemp,
    @required this.wScreen,
  }) : super(key: key);

  final double minSize;
  final User userTemp;
  final double wScreen;
  final String urlPhotoDefault = 'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: minSize * 0.4,
        width: minSize * 0.4,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              userTemp.urlPhoto??urlPhotoDefault,
            ),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(wScreen * 0.2),
          border: Border.all(
            color: Theme.of(context).scaffoldBackgroundColor,
            width: 6,
          ),
        ),
      ),
    );
  }
}