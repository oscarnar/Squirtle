import 'package:flutter/material.dart';
import 'package:squirtle/models/taskModel.dart';

class CardTask extends StatelessWidget {
  CardTask({this.task, this.course});
  final Task task;
  final String course;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      height: size.width * 0.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.blue[100],
      ),
      child: InkWell(
        onTap: () {
          print("Tap on Card");
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              course,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              task.name,
              style: TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
