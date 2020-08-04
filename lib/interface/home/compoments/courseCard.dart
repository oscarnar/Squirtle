import 'package:flutter/material.dart';
import 'package:squirtle/models/courseModel.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({
    Key key,
    @required this.currentCourse
  }) : super(key: key);

  final Course currentCourse;
  final String coursePhotoDefault = 'https://www.queestudiar.org/wp-content/uploads/2017/10/software-750x350.jpg';

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        height: size.width * 0.25,
        color: Colors.blue[200],
        //shape: RoundedRectangleBorder(
        //  side: BorderSide(color: Colors.white70, width: 1),
        //  borderRadius: BorderRadius.circular(20),
        //),
        child: InkWell(
          onTap: () {
            print("Tap on Card");
          },
          child: Row(
            children: [
              SizedBox(
                height: size.width * 0.25,
                width: size.width * 0.2,
                child: Image.network(
                  currentCourse.photo??coursePhotoDefault,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.04,
                    vertical: size.width * 0.01,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentCourse.name,
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        currentCourse.teacher??'No hay profe',
                        style: TextStyle(fontSize: 13),
                      ),
                      Expanded(
                        child: Center(
                          child: FlatButton(
                            color: Colors.white30,
                            onPressed: () {},
                            child: Text("Unirse a Meet"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}